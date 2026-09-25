"""Tests for review-post.

Run with: python3 -m unittest discover -s ~/code/config/nvim/scripts/tests
"""

import importlib.util
import sys
import unittest
from pathlib import Path

# The script is a hyphenated executable rather than an importable module name,
# so load it by path and register it before the dataclasses in it are built.
_spec = importlib.util.spec_from_file_location(
    'review_post', Path(__file__).parent.parent / 'review-post.py'
)
review_post = importlib.util.module_from_spec(_spec)
sys.modules['review_post'] = review_post
_spec.loader.exec_module(review_post)


SIMPLE_PATCH = '''@@ -9,6 +9,7 @@
 )
 from shop.models.order import OrderStatus
 from shop.services.order import OrderService
+from shop.services.inventory import InventoryService

 from shop.api.serializers import OrderSerializer
 '''


class ParsePatchTests(unittest.TestCase):
    def test_ParsePatch_ContextAndAddedLines_CollectsEveryNewSideLine(self):
        # Arrange / Act
        sides = review_post.parse_patch(SIMPLE_PATCH)

        # Assert
        self.assertEqual(sides['RIGHT'], set(range(9, 16)))

    def test_ParsePatch_AddedLine_IsAbsentFromOldSide(self):
        # Arrange / Act
        sides = review_post.parse_patch(SIMPLE_PATCH)

        # Assert
        # Six old lines, and the added import is not one of them.
        self.assertEqual(sides['LEFT'], set(range(9, 15)))

    def test_ParsePatch_RemovedLines_AdvanceOnlyTheOldSide(self):
        # Arrange
        patch = '\n'.join(
            [
                '@@ -68,18 +69,13 @@ def process(self):',
                ' context_one',
                ' context_two',
                ' context_three',
                '-removed_one',
                '-removed_two',
                '-removed_three',
                '-removed_four',
                '-removed_five',
                '-removed_six',
                '-removed_seven',
                '-removed_eight',
                '+added_one',
                '+added_two',
                '+added_three',
                ' context_four',
                ' context_five',
                '-removed_nine',
                '+added_four',
                ' context_six',
                ' context_seven',
                ' context_eight',
                ' context_nine',
            ]
        )

        # Act
        sides = review_post.parse_patch(patch)

        # Assert
        self.assertEqual(sides['RIGHT'], set(range(69, 82)))
        self.assertEqual(sides['LEFT'], set(range(68, 86)))

    def test_ParsePatch_NoNewlineMarker_IsNotCountedAsALine(self):
        # Arrange
        patch = '\n'.join(
            [
                '@@ -1,2 +1,2 @@',
                ' kept',
                '-old_last',
                '\\ No newline at end of file',
                '+new_last',
                '\\ No newline at end of file',
            ]
        )

        # Act
        sides = review_post.parse_patch(patch)

        # Assert
        self.assertEqual(sides['RIGHT'], {1, 2})
        self.assertEqual(sides['LEFT'], {1, 2})

    def test_ParsePatch_SingleLineHunkHeader_ParsesOmittedCount(self):
        # Arrange
        patch = '@@ -5 +5 @@\n-old\n+new'

        # Act
        sides = review_post.parse_patch(patch)

        # Assert
        self.assertEqual(sides['RIGHT'], {5})
        self.assertEqual(sides['LEFT'], {5})

    def test_ParsePatch_MalformedHunkHeader_RaiseReviewPostError(self):
        # Arrange / Act / Assert
        with self.assertRaises(review_post.ReviewPostError):
            review_post.parse_patch('@@ nonsense @@\n context')


class ClampTests(unittest.TestCase):
    def test_Clamp_RangeInsideTheDiff_IsUnchanged(self):
        # Arrange / Act
        result = review_post.clamp(47, 59, set(range(45, 60)))

        # Assert
        self.assertEqual(result, (47, 59))

    def test_Clamp_RangeOverhangingBothEnds_ShrinksToTheDiff(self):
        # Arrange / Act
        result = review_post.clamp(37, 60, set(range(45, 60)))

        # Assert
        self.assertEqual(result, (45, 59))

    def test_Clamp_LinePastTheLastHunk_SnapsToTheNearestLine(self):
        # Arrange / Act
        result = review_post.clamp(82, 82, set(range(69, 82)))

        # Assert
        self.assertEqual(result, (81, 81))

    def test_Clamp_LineBeforeTheFirstHunk_SnapsToTheNearestLine(self):
        # Arrange / Act
        result = review_post.clamp(3, 3, set(range(69, 82)))

        # Assert
        self.assertEqual(result, (69, 69))

    def test_Clamp_LineInAGapBetweenHunks_SnapsToTheCloserEdge(self):
        # Arrange
        valid = set(range(1, 11)) | set(range(90, 101))

        # Act
        result = review_post.clamp(12, 12, valid)

        # Assert
        self.assertEqual(result, (10, 10))

    def test_Clamp_NoDiffLines_ReturnNone(self):
        # Arrange / Act
        result = review_post.clamp(5, 5, set())

        # Assert
        self.assertIsNone(result)


class PlanCommentTests(unittest.TestCase):
    def setUp(self):
        self.diff_lines = {
            'app/views.py': {'RIGHT': set(range(45, 60)), 'LEFT': set(range(40, 55))},
        }

    def test_PlanComment_SingleLineInDiff_BuildsALineAnchor(self):
        # Arrange
        comment = {'file': 'app/views.py', 'line': 50, 'type': 'issue', 'text': 'bad'}

        # Act
        planned = review_post.plan_comment(comment, self.diff_lines)

        # Assert
        self.assertEqual(
            planned.payload,
            {'path': 'app/views.py', 'body': '❗️ bad', 'line': 50, 'side': 'RIGHT'},
        )
        self.assertEqual(planned.notes, [])

    def test_PlanComment_Range_BuildsAStartAndEndAnchor(self):
        # Arrange
        comment = {
            'file': 'app/views.py',
            'line': 47,
            'line_end': 55,
            'type': 'note',
            'text': 'why?',
        }

        # Act
        planned = review_post.plan_comment(comment, self.diff_lines)

        # Assert
        self.assertEqual(planned.payload['start_line'], 47)
        self.assertEqual(planned.payload['line'], 55)
        self.assertEqual(planned.payload['start_side'], 'RIGHT')
        self.assertEqual(planned.payload['body'], '❓ why?')

    def test_PlanComment_OldSide_AnchorsToTheLeftSide(self):
        # Arrange
        comment = {
            'file': 'app/views.py',
            'line': 42,
            'side': 'old',
            'type': 'suggestion',
            'text': 'was clearer',
        }

        # Act
        planned = review_post.plan_comment(comment, self.diff_lines)

        # Assert
        self.assertEqual(planned.payload['side'], 'LEFT')
        self.assertEqual(planned.payload['line'], 42)

    def test_PlanComment_RangeOutsideTheDiff_IsClampedAndNoted(self):
        # Arrange
        comment = {
            'file': 'app/views.py',
            'line': 37,
            'line_end': 60,
            'type': 'note',
            'text': 'broad',
        }

        # Act
        planned = review_post.plan_comment(comment, self.diff_lines)

        # Assert
        self.assertEqual(planned.payload['start_line'], 45)
        self.assertEqual(planned.payload['line'], 59)
        self.assertEqual(planned.notes, ['clamped from 37-60 to 45-59'])

    def test_PlanComment_FileLevelLine_AnchorsToTheFirstChangedLine(self):
        # Arrange
        comment = {'file': 'app/views.py', 'line': 0, 'type': 'praise', 'text': 'nice'}

        # Act
        planned = review_post.plan_comment(comment, self.diff_lines)

        # Assert
        # subject_type="file" is not accepted by the create-review endpoint.
        self.assertNotIn('subject_type', planned.payload)
        self.assertEqual(planned.payload['line'], 45)
        self.assertEqual(planned.payload['side'], 'RIGHT')
        self.assertEqual(planned.payload['body'], '💥 nice')
        self.assertIn('file-level comment', planned.notes[0])

    def test_PlanComment_FileNotInThePullRequest_IsSkipped(self):
        # Arrange
        comment = {'file': 'app/other.py', 'line': 5, 'type': 'note', 'text': 'hm'}

        # Act
        planned = review_post.plan_comment(comment, self.diff_lines)

        # Assert
        self.assertIsNone(planned.payload)
        self.assertIn('not part of this pull request', planned.skipped)

    def test_PlanComment_EmptyText_IsSkipped(self):
        # Arrange
        comment = {'file': 'app/views.py', 'line': 50, 'type': 'note', 'text': '  '}

        # Act
        planned = review_post.plan_comment(comment, self.diff_lines)

        # Assert
        self.assertIsNone(planned.payload)

    def test_PlanComment_UnknownType_UsesTheFallbackIcon(self):
        # Arrange
        comment = {'file': 'app/views.py', 'line': 50, 'type': 'wat', 'text': 'x'}

        # Act
        planned = review_post.plan_comment(comment, self.diff_lines)

        # Assert
        self.assertTrue(planned.payload['body'].startswith(review_post.FALLBACK_ICON))

    def test_PlanComment_SideWithNoDiffLines_AnchorsToTheOtherSide(self):
        # Arrange
        diff_lines = {'app/new.py': {'RIGHT': {1, 2}, 'LEFT': set()}}
        comment = {
            'file': 'app/new.py',
            'line': 3,
            'side': 'old',
            'type': 'note',
            'text': 'gone',
        }

        # Act
        planned = review_post.plan_comment(comment, diff_lines)

        # Assert
        self.assertEqual(planned.payload['side'], 'RIGHT')
        self.assertEqual(planned.payload['line'], 1)
        self.assertIn('no diff lines', planned.notes[0])

    def test_PlanComment_FileWithNoDiffLinesAtAll_IsSkipped(self):
        # Arrange
        diff_lines = {'app/binary.png': {'RIGHT': set(), 'LEFT': set()}}
        comment = {'file': 'app/binary.png', 'line': 0, 'type': 'note', 'text': 'hm'}

        # Act
        planned = review_post.plan_comment(comment, diff_lines)

        # Assert
        self.assertIsNone(planned.payload)
        self.assertIn('no diff lines', planned.skipped)


class StorePathTests(unittest.TestCase):
    def test_StorePath_KnownRepository_MatchesReviewNvimsHash(self):
        # Arrange
        root = Path('/home/user/code/project')

        # Act
        path = review_post.store_path(root)

        # Assert
        # Reproduced independently with review.nvim's *31 mod 2^31-1 hash.
        digest = 0
        for byte in str(root).encode():
            digest = ((digest * 31) + byte) % 2147483647
        self.assertEqual(path.name, f'{digest:x}.json')
        self.assertTrue(str(path).endswith('/.local/share/nvim/review/' + path.name))


if __name__ == '__main__':
    unittest.main()
