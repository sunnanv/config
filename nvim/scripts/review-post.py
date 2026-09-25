#!/usr/bin/env python3
"""Post review.nvim comments to a GitHub pull request as a single review.

review.nvim collects comments and exports them as markdown; it never talks to
GitHub. This is that missing half: it takes the same comment records
`require("review.store").get_all()` returns and posts them as line comments on a
pull request, as one COMMENT / APPROVE / REQUEST_CHANGES review.

Comments arrive as a JSON array, from --comments FILE, from stdin, or from
--store (review.nvim's own per-repo JSON file). Each record uses review.nvim's
schema: file, line, optional line_end, optional side ("old"|"new"), type, text.

GitHub only accepts a line anchor that appears in the pull request's diff hunks,
so anchors outside them are clamped to the nearest lines that are, and every
adjustment is reported before anything is posted.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path

# review.nvim stores the built-in type keys regardless of how comment_types
# renames them for display, so the icons are keyed by those built-in names.
# Keep this in sync with the comment_types block in lua/plugins/utils.lua.
TYPE_ICONS = {
    'note': '❓',
    'suggestion': '🎨',
    'issue': '❗️',
    'praise': '💥',
}
FALLBACK_ICON = '💬'

EVENTS = ('COMMENT', 'APPROVE', 'REQUEST_CHANGES')

# review.nvim's side values, and the names the GitHub API uses for them.
GITHUB_SIDE = {'old': 'LEFT', 'new': 'RIGHT'}

# review.nvim uses line 0 to mean "a comment about the file, not a line".
FILE_LEVEL_LINE = 0


class ReviewPostError(Exception):
    """Anything that should stop the run with a message rather than a traceback."""


# --- gh plumbing -------------------------------------------------------------


def run_gh(args: list[str], *, stdin: str | None = None) -> str:
    try:
        result = subprocess.run(
            ['gh', *args],
            input=stdin,
            capture_output=True,
            text=True,
            check=False,
        )
    except FileNotFoundError:
        raise ReviewPostError('gh is not installed or not on PATH')
    if result.returncode != 0:
        detail = (result.stderr or result.stdout).strip()
        raise ReviewPostError(f'gh {" ".join(args)} failed:\n{detail}')
    return result.stdout


def git_root(cwd: Path) -> Path:
    result = subprocess.run(
        ['git', 'rev-parse', '--show-toplevel'],
        cwd=cwd,
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        raise ReviewPostError(f'{cwd} is not inside a git repository')
    return Path(result.stdout.strip())


@dataclass
class PullRequest:
    number: int
    repo: str
    head_sha: str
    url: str


def resolve_pull_request(pr: str | None, repo: str | None) -> PullRequest:
    """Look up the pull request to post to, defaulting to the current branch's."""
    args = ['pr', 'view']
    if pr:
        args.append(pr)
    if repo:
        args += ['--repo', repo]
    args += ['--json', 'number,headRefOid,url,headRepository,headRepositoryOwner,state']

    raw = run_gh(args)
    data = json.loads(raw)

    if data.get('state') != 'OPEN':
        print(
            f'warning: pull request #{data["number"]} is {data.get("state", "?").lower()}',
            file=sys.stderr,
        )

    if repo:
        name_with_owner = repo
    else:
        owner = (data.get('headRepositoryOwner') or {}).get('login')
        name = (data.get('headRepository') or {}).get('name')
        if not owner or not name:
            # A pull request from a fork reports the fork here, not the base, so
            # fall back to the repository gh resolved for the working directory.
            name_with_owner = json.loads(
                run_gh(['repo', 'view', '--json', 'nameWithOwner'])
            )['nameWithOwner']
        else:
            name_with_owner = f'{owner}/{name}'

    return PullRequest(
        number=data['number'],
        repo=name_with_owner,
        head_sha=data['headRefOid'],
        url=data['url'],
    )


def fetch_diff_lines(pr: PullRequest) -> dict[str, dict[str, set[int]]]:
    """Map each changed file to the line numbers GitHub will accept, per side."""
    raw = run_gh(
        [
            'api',
            '--paginate',
            f'repos/{pr.repo}/pulls/{pr.number}/files',
            '--jq',
            '.[] | {filename, patch}',
        ]
    )

    diff_lines: dict[str, dict[str, set[int]]] = {}
    for line in raw.splitlines():
        if not line.strip():
            continue
        entry = json.loads(line)
        patch = entry.get('patch')
        # Binary files and files too large to diff come back without a patch.
        diff_lines[entry['filename']] = (
            parse_patch(patch) if patch else {'LEFT': set(), 'RIGHT': set()}
        )
    return diff_lines


def parse_patch(patch: str) -> dict[str, set[int]]:
    """Collect the line numbers each side of a unified diff actually shows.

    Context lines count: GitHub accepts a comment anywhere inside a hunk, not
    only on added lines.
    """
    left: set[int] = set()
    right: set[int] = set()
    old_line = new_line = 0

    for line in patch.splitlines():
        if line.startswith('@@'):
            # @@ -old_start[,old_count] +new_start[,new_count] @@ trailing
            try:
                spans = line.split('@@')[1].strip().split()
                old_line = int(spans[0][1:].split(',')[0])
                new_line = int(spans[1][1:].split(',')[0])
            except (IndexError, ValueError):
                raise ReviewPostError(f'could not parse hunk header: {line}')
        elif line.startswith('-'):
            left.add(old_line)
            old_line += 1
        elif line.startswith('+'):
            right.add(new_line)
            new_line += 1
        elif line.startswith('\\'):
            # "\ No newline at end of file" belongs to the line above it.
            continue
        else:
            # A context line, or the empty string git emits for a blank one.
            left.add(old_line)
            right.add(new_line)
            old_line += 1
            new_line += 1

    return {'LEFT': left, 'RIGHT': right}


# --- comment loading ---------------------------------------------------------


def store_path(root: Path) -> Path:
    """Reproduce review.nvim's storage path for a repository.

    Mirrors lua/review/storage.lua: a bespoke hash of the absolute git root,
    formatted as lowercase hex, under stdpath("data")/review.
    """
    digest = 0
    for byte in str(root).encode():
        digest = ((digest * 31) + byte) % 2147483647
    data_dir = Path.home() / '.local' / 'share' / 'nvim' / 'review'
    return data_dir / f'{digest:x}.json'


def load_comments(args: argparse.Namespace, root: Path) -> list[dict]:
    if args.store:
        path = store_path(root)
        if not path.exists():
            raise ReviewPostError(
                f'no review.nvim store for this repository at {path}'
            )
        # The store is keyed by file path; the comments themselves repeat it.
        by_file = json.loads(path.read_text())
        comments = [c for group in by_file.values() for c in group]
    elif args.comments:
        comments = json.loads(Path(args.comments).read_text())
    else:
        if sys.stdin.isatty():
            raise ReviewPostError(
                'no comments given: pass --store, --comments FILE, or JSON on stdin'
            )
        comments = json.loads(sys.stdin.read())

    if isinstance(comments, dict):
        # Tolerate the store's file-keyed shape arriving by another route.
        comments = [c for group in comments.values() for c in group]
    if not isinstance(comments, list):
        raise ReviewPostError('expected a JSON array of comments')
    if not comments:
        raise ReviewPostError('no comments to post')

    comments.sort(key=lambda c: (c.get('file', ''), c.get('line', 0)))
    return comments


# --- anchoring ---------------------------------------------------------------


@dataclass
class Planned:
    comment: dict
    payload: dict | None
    notes: list[str] = field(default_factory=list)
    skipped: str | None = None


def clamp(start: int, end: int, valid: set[int]) -> tuple[int, int] | None:
    """Pull a line range inward until both ends land on lines GitHub will accept."""
    if not valid:
        return None
    at_or_after = [v for v in valid if v >= start]
    at_or_before = [v for v in valid if v <= end]

    # A range entirely past one end of the diff collapses onto the nearest line.
    if not at_or_after:
        nearest = max(valid)
        return nearest, nearest
    if not at_or_before:
        nearest = min(valid)
        return nearest, nearest

    new_start = min(at_or_after)
    new_end = max(at_or_before)
    if new_start > new_end:
        # The range fell into a gap between two hunks; snap to the closer edge.
        nearest = min(valid, key=lambda v: min(abs(v - start), abs(v - end)))
        return nearest, nearest
    return new_start, new_end


def plan_comment(comment: dict, diff_lines: dict[str, dict[str, set[int]]]) -> Planned:
    path = comment.get('file')
    if not path:
        return Planned(comment, None, skipped='comment has no file')

    if path not in diff_lines:
        return Planned(
            comment,
            None,
            skipped=f'{path} is not part of this pull request',
        )

    text = (comment.get('text') or '').strip()
    if not text:
        return Planned(comment, None, skipped=f'{path}: comment has no text')

    icon = TYPE_ICONS.get(comment.get('type', ''), FALLBACK_ICON)
    body = f'{icon} {text}'

    side = GITHUB_SIDE.get(comment.get('side') or 'new', 'RIGHT')
    line = comment.get('line', FILE_LEVEL_LINE)
    line_end = comment.get('line_end') or line

    # The create-review endpoint only takes line anchors -- subject_type="file"
    # belongs to the separate review-comments endpoint, which would need its own
    # request and so break the one-review-per-run guarantee. A comment with
    # nowhere of its own to sit goes on the file's first changed line instead.
    valid = diff_lines[path][side]
    if line == FILE_LEVEL_LINE or not valid:
        anchor_side, anchor_lines = side, valid
        if not anchor_lines:
            anchor_side = 'RIGHT' if side == 'LEFT' else 'LEFT'
            anchor_lines = diff_lines[path][anchor_side]
        if not anchor_lines:
            return Planned(comment, None, skipped=f'{path}: has no diff lines')

        first = min(anchor_lines)
        reason = (
            'file-level comment'
            if line == FILE_LEVEL_LINE
            else f'{side} side has no diff lines'
        )
        return Planned(
            comment,
            {'path': path, 'body': body, 'line': first, 'side': anchor_side},
            notes=[f'{reason} → anchored to the first changed line ({first})'],
        )

    clamped = clamp(line, line_end, valid)
    if clamped is None:
        return Planned(comment, None, skipped=f'{path}: no anchorable lines')

    new_start, new_end = clamped
    notes = []
    if (new_start, new_end) != (line, line_end):
        before = f'{line}' if line == line_end else f'{line}-{line_end}'
        after = f'{new_start}' if new_start == new_end else f'{new_start}-{new_end}'
        notes.append(f'clamped from {before} to {after}')

    payload = {'path': path, 'body': body, 'line': new_end, 'side': side}
    if new_start != new_end:
        payload['start_line'] = new_start
        payload['start_side'] = side

    return Planned(comment, payload, notes=notes)


# --- output ------------------------------------------------------------------


def describe(planned: Planned) -> str:
    payload = planned.payload
    assert payload is not None
    path = payload['path']
    if payload.get('subject_type') == 'file':
        location = path
    else:
        start = payload.get('start_line')
        anchor = f'{start}-{payload["line"]}' if start else str(payload['line'])
        marker = '~' if payload['side'] == 'LEFT' else ''
        location = f'{path}:{marker}{anchor}'

    suffix = f'  ({"; ".join(planned.notes)})' if planned.notes else ''
    first_line = payload['body'].splitlines()[0]
    if len(first_line) > 72:
        first_line = first_line[:71] + '…'
    return f'  {location}{suffix}\n    {first_line}'


def preview(pr: PullRequest, event: str, planned: list[Planned]) -> None:
    postable = [p for p in planned if p.payload]
    skipped = [p for p in planned if p.skipped]

    print(f'{pr.repo} #{pr.number}  event={event}  head={pr.head_sha[:10]}')
    print(pr.url)
    print()
    for item in postable:
        print(describe(item))
    if skipped:
        print()
        print('Not posted:')
        for item in skipped:
            print(f'  ! {item.skipped}')
    print()
    print(f'{len(postable)} comment(s) to post, {len(skipped)} skipped')


def confirm() -> bool:
    """Ask on the terminal, so stdin stays free for the comments themselves."""
    try:
        with open('/dev/tty', 'r+') as tty:
            tty.write('\nPost this review? [y/N] ')
            tty.flush()
            answer = tty.readline().strip().lower()
    except OSError:
        print('no terminal available to confirm on; pass --yes to post', file=sys.stderr)
        return False
    return answer in ('y', 'yes')


# --- main --------------------------------------------------------------------


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog='review-post',
        description='Post review.nvim comments to a GitHub pull request review.',
    )
    parser.add_argument(
        '--pr',
        help='pull request number, URL, or branch (default: the current branch)',
    )
    parser.add_argument('--repo', help='OWNER/NAME (default: the current repository)')
    parser.add_argument(
        '--event',
        default='COMMENT',
        type=str.upper,
        choices=EVENTS,
        help='the kind of review to submit (default: COMMENT)',
    )
    parser.add_argument(
        '--body',
        default='',
        help='top-level review body (default: none, so only line comments appear)',
    )
    source = parser.add_mutually_exclusive_group()
    source.add_argument(
        '--store',
        action='store_true',
        help="read review.nvim's own store for this repository",
    )
    source.add_argument('--comments', help='path to a JSON array of comments')
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='show what would be posted and exit',
    )
    parser.add_argument(
        '-y',
        '--yes',
        action='store_true',
        help='skip the confirmation prompt',
    )
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)

    root = git_root(Path.cwd())
    comments = load_comments(args, root)
    pr = resolve_pull_request(args.pr, args.repo)
    diff_lines = fetch_diff_lines(pr)

    planned = [plan_comment(c, diff_lines) for c in comments]
    postable = [p for p in planned if p.payload]

    preview(pr, args.event, planned)

    if not postable:
        raise ReviewPostError('nothing left to post')

    if args.dry_run:
        return 0

    if not args.yes and not confirm():
        print('Aborted; nothing posted.')
        return 1

    payload = {
        'commit_id': pr.head_sha,
        'event': args.event,
        'body': args.body,
        'comments': [p.payload for p in postable],
    }
    raw = run_gh(
        [
            'api',
            f'repos/{pr.repo}/pulls/{pr.number}/reviews',
            '--method',
            'POST',
            '--input',
            '-',
        ],
        stdin=json.dumps(payload),
    )
    review = json.loads(raw)
    print(f'\nPosted {len(postable)} comment(s): {review["html_url"]}')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main(sys.argv[1:]))
    except ReviewPostError as error:
        print(f'error: {error}', file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(130)
