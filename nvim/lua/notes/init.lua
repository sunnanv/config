local M = {}

local notes_dir = vim.fn.expand("~/code/workspace/notes")
local dailies_dir = notes_dir .. "/dailies"
local weekly_dir = notes_dir .. "/weekly"
local workflows_dir = notes_dir .. "/workflows"
local scratch_path = notes_dir .. "/scratch.md"
local todo_path = notes_dir .. "/todo.md"
local DAY = 24 * 60 * 60

M.dir = notes_dir

local week_id = function(time)
	return os.date("%G-W%V", time)
end

local daily_path = function(time)
	return dailies_dir .. "/" .. os.date("%Y-%m-%d", time) .. ".md"
end

local review_path = function(time)
	return weekly_dir .. "/" .. week_id(time) .. "-review.md"
end

local is_empty_bullet = function(line)
	return line:match("^%s*%-%s*$") ~= nil or line:match("^%s*%-%s*%[%s*%]%s*$") ~= nil
end

local heading_line = function(lines, pattern)
	for i, l in ipairs(lines) do
		if l:match(pattern) then
			return i
		end
	end
end

local last_bullet_line = function(lines, from)
	local last
	for i = from + 1, #lines do
		local l = lines[i]
		if l:match("^%s*%-%s") then
			last = i
		elseif l:match("^%s*<!%-%-") or l:match("^##%s") then
			break
		end
	end
	return last
end

local add_bullet = function(lines, heading_pattern, prefix, text)
	local start = heading_line(lines, heading_pattern)
	if not start then
		table.insert(lines, prefix .. text)
		return
	end
	local last = last_bullet_line(lines, start)
	if last and is_empty_bullet(lines[last]) then
		lines[last] = prefix .. text
	else
		table.insert(lines, (last or start) + 1, prefix .. text)
	end
end

local ensure_daily = function(time)
	local path = daily_path(time)
	if vim.fn.filereadable(path) == 1 then
		return path
	end
	vim.fn.mkdir(dailies_dir, "p")
	local date = os.date("%Y-%m-%d", time)
	vim.fn.writefile({
		"---",
		"id: " .. date,
		"aliases: []",
		"tags: [daily]",
		"---",
		"# " .. date .. " " .. os.date("%a", time),
		"",
		"## Inbox",
		"- ",
		"",
		"<!--",
		"Trigger: ___ (pick ONE you already hit: end of work session / after standup / on PR open).",
		"Dump raw. Fragments fine. One line = success. Miss a day? Just continue, no restart.",
		"Anything goes: todo (- [ ]) · decision · discussion point · learning · reflection.",
		"Optional tags so Friday review can find them: #decision #learning #reflect #dri",
		"-->",
	}, path)
	return path
end

local ensure_todo = function()
	if vim.fn.filereadable(todo_path) == 1 then
		return todo_path
	end
	vim.fn.writefile({
		"---",
		"id: todo",
		"aliases: []",
		"tags: [todo]",
		"---",
		"# Todo",
		"",
		"- [ ] ",
	}, todo_path)
	return todo_path
end

local collect_open_todos = function(time)
	local wday = tonumber(os.date("%u", time))
	local monday = time - (wday - 1) * DAY
	local out = {}
	local scan = function(path)
		if vim.fn.filereadable(path) == 1 then
			for _, l in ipairs(vim.fn.readfile(path)) do
				if l:match("^%s*%- %[ %]") and not l:match("^%s*%- %[ %]%s*$") then
					table.insert(out, l)
				end
			end
		end
	end
	for i = 0, 6 do
		scan(daily_path(monday + i * DAY))
	end
	scan(review_path(time - 7 * DAY))
	scan(todo_path)
	return out
end

local ensure_review = function(time)
	local path = review_path(time)
	if vim.fn.filereadable(path) == 1 then
		return path
	end
	vim.fn.mkdir(weekly_dir, "p")
	local id = week_id(time)
	local carried = collect_open_todos(time)
	if #carried == 0 then
		carried = { "- " }
	end
	local lines = {
		"---",
		"id: " .. id .. "-review",
		"aliases: []",
		"tags: [weekly, review]",
		"---",
		"# Review " .. id,
		"",
		"<!-- 15 min, Fri PM. Read this week's dailies/*. PULL from them, don't re-derive from memory. -->",
		"",
		"## Learnings → permanent notes",
		"- ",
		"",
		"## Decisions made",
		"- ",
		"",
		"## Reflections (self)",
		"- ",
		"",
		"## DRI / docs to update",
		"- ",
		"",
		"## Carry-over todos",
	}
	vim.list_extend(lines, carried)
	vim.list_extend(lines, {
		"",
		"## One idea to formulate (presenting reps)",
		"<!-- 3-5 lines: situation → problem → proposal -->",
		"- ",
	})
	vim.fn.writefile(lines, path)
	return path
end

local git_branch = function(dir)
	if not dir or dir == "" or vim.fn.isdirectory(dir) == 0 then
		return nil
	end
	local out = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--abbrev-ref", "HEAD" })
	if vim.v.shell_error ~= 0 then
		return nil
	end
	local branch = vim.trim(out[1] or "")
	if branch == "" or branch == "HEAD" then
		return nil
	end
	return branch
end

local branch_slug = function(branch)
	if not branch or branch == "main" or branch == "master" then
		return nil
	end
	return branch:match("KOG%-%d+") or (branch:gsub("[/%s]+", "-"))
end

local branch_note_path = function(origin)
	local slug = branch_slug(git_branch(origin))
	if not slug then
		return scratch_path
	end
	local dir = workflows_dir .. "/" .. slug
	vim.fn.mkdir(dir, "p")
	return dir .. "/notes.md"
end

local open_capture = function(path, heading_pattern, prefix)
	vim.cmd.edit(path)
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local start = heading_line(lines, heading_pattern)
	if not start then
		return
	end
	local last = last_bullet_line(lines, start)
	if last and is_empty_bullet(lines[last]) then
		vim.api.nvim_buf_set_lines(bufnr, last - 1, last, false, { prefix })
	else
		last = (last or start) + 1
		vim.api.nvim_buf_set_lines(bufnr, last - 1, last - 1, false, { prefix })
	end
	vim.api.nvim_win_set_cursor(0, { last, 0 })
	vim.cmd("startinsert!")
end

local capture_line = function(prompt, path_fn, heading_pattern, prefix)
	vim.ui.input({ prompt = prompt }, function(input)
		if not input or input == "" then
			return
		end
		local path = path_fn()
		local lines = vim.fn.readfile(path)
		add_bullet(lines, heading_pattern, prefix, input)
		vim.fn.writefile(lines, path)
		vim.cmd("checktime")
		vim.notify("Captured → " .. vim.fn.fnamemodify(path, ":t"))
	end)
end

local targets = {
	daily = function()
		open_capture(ensure_daily(os.time()), "^##%s+Inbox", "- ")
	end,
	todo = function()
		open_capture(ensure_todo(), "^#%s+Todo", "- [ ] ")
	end,
	branch = function(origin)
		vim.cmd.edit(branch_note_path(origin))
	end,
	scratch = function()
		vim.cmd.edit(scratch_path)
	end,
	review = function()
		vim.cmd.edit(ensure_review(os.time()))
	end,
}

M.open = function(target, origin)
	local fn = targets[target]
	if not fn then
		vim.notify("notes: unknown target " .. tostring(target), vim.log.levels.WARN)
		return
	end
	fn(origin)
end

M.capture_daily = function()
	capture_line("Capture: ", function()
		return ensure_daily(os.time())
	end, "^##%s+Inbox", "- ")
end

M.capture_todo = function()
	capture_line("Todo: ", ensure_todo, "^#%s+Todo", "- [ ] ")
end

M.agenda = function()
	Snacks.picker.grep({
		cwd = notes_dir,
		search = "^\\s*- \\[ \\]",
		regex = true,
		live = false,
	})
end

M.setup = function()
	vim.api.nvim_create_user_command("NotesOpen", function(opts)
		M.open(opts.fargs[1], opts.fargs[2])
	end, { nargs = "+", desc = "Open a notes entrypoint" })

	local map = function(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { desc = desc })
	end
	map("<leader>od", function()
		M.open("daily")
	end, "Daily note (capture)")
	map("<leader>oc", M.capture_daily, "Quick capture → today")
	map("<leader>ot", M.capture_todo, "Capture → todo")
	map("<leader>oT", function()
		M.open("todo")
	end, "Todo list")
	map("<leader>ob", function()
		M.open("branch", vim.fn.getcwd())
	end, "Branch notes")
	map("<leader>or", function()
		M.open("review")
	end, "Weekly review")
	map("<leader>oo", function()
		M.open("scratch")
	end, "Scratch")
	map("<leader>oa", M.agenda, "Agenda (open todos)")
end

return M
