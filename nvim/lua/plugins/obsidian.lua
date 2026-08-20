local notes_dir = vim.fn.expand("~/code/workspace/notes")
local dailies_dir = notes_dir .. "/dailies"
local weekly_dir = notes_dir .. "/weekly"
local DAY = 24 * 60 * 60

-- ISO week id, e.g. "2026-W25"
local week_id = function(time)
	return os.date("%G-W%V", time)
end

local daily_path = function(time)
	return dailies_dir .. "/" .. os.date("%Y-%m-%d", time) .. ".md"
end

local review_path = function(time)
	return weekly_dir .. "/" .. week_id(time) .. "-review.md"
end

-- Add a bullet to the Inbox section of a lines table (fills the empty seed bullet if present).
local add_inbox_bullet = function(lines, text)
	local start
	for i, l in ipairs(lines) do
		if l:match("^##%s+Inbox") then
			start = i
			break
		end
	end
	if not start then
		table.insert(lines, "## Inbox")
		table.insert(lines, "- " .. text)
		return
	end
	local last
	for i = start + 1, #lines do
		local l = lines[i]
		if l:match("^%s*%-%s") then
			last = i
		elseif l:match("^%s*<!%-%-") or l:match("^##%s") then
			break
		end
	end
	if last and lines[last]:match("^%s*%-%s*$") then
		lines[last] = "- " .. text
	elseif last then
		table.insert(lines, last + 1, "- " .. text)
	else
		table.insert(lines, start + 1, "- " .. text)
	end
end

-- Create today's daily note from template if missing.
local ensure_daily = function(time)
	local path = daily_path(time)
	if vim.fn.filereadable(path) == 1 then
		return path
	end
	vim.fn.mkdir(dailies_dir, "p")
	local date = os.date("%Y-%m-%d", time)
	local lines = {
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
	}
	vim.fn.writefile(lines, path)
	return path
end

-- Open checkboxes still pending this week (this week's dailies + last week's review carry-over).
local collect_open_todos = function(time)
	local wday = tonumber(os.date("%u", time)) -- 1=Mon .. 7=Sun
	local monday = time - (wday - 1) * DAY
	local out = {}
	local scan = function(path)
		if vim.fn.filereadable(path) == 1 then
			for _, l in ipairs(vim.fn.readfile(path)) do
				if l:match("^%s*%- %[ %]") then
					table.insert(out, l)
				end
			end
		end
	end
	for i = 0, 6 do
		scan(daily_path(monday + i * DAY))
	end
	scan(review_path(time - 7 * DAY))
	return out
end

-- Create this week's review note from template if missing; carry forward open todos.
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

-- Open today's daily and drop into insert on a fresh Inbox bullet.
local open_daily = function()
	vim.cmd.edit(ensure_daily(os.time()))
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local start
	for i, l in ipairs(lines) do
		if l:match("^##%s+Inbox") then
			start = i
			break
		end
	end
	if not start then
		return
	end
	local last = start
	for i = start + 1, #lines do
		local l = lines[i]
		if l:match("^%s*%-%s") then
			last = i
		elseif l:match("^%s*<!%-%-") or l:match("^##%s") then
			break
		end
	end
	-- if the last bullet already has content, open a fresh one below it
	if lines[last]:match("^%s*%-%s+%S") then
		vim.api.nvim_buf_set_lines(bufnr, last, last, false, { "- " })
		last = last + 1
	end
	vim.api.nvim_win_set_cursor(0, { last, 0 })
	vim.cmd("startinsert!")
end

-- Capture one line into today's Inbox without leaving the current buffer.
local quick_capture = function()
	vim.ui.input({ prompt = "Capture: " }, function(input)
		if not input or input == "" then
			return
		end
		local path = ensure_daily(os.time())
		local lines = vim.fn.readfile(path)
		add_inbox_bullet(lines, input)
		vim.fn.writefile(lines, path)
		vim.cmd("checktime")
		vim.notify("Captured → " .. os.date("%Y-%m-%d") .. ".md")
	end)
end

local open_review = function()
	vim.cmd.edit(ensure_review(os.time()))
end

return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- use latest release, remove to use latest commit
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		legacy_commands = false,
		workspaces = {
			{
				name = "workspace",
				path = "~/code/workspace/",
			},
		},
	},
	keys = {
		{ "<leader>od", open_daily, desc = "Daily note (capture)" },
		{ "<leader>oc", quick_capture, desc = "Quick capture → today" },
		{ "<leader>or", open_review, desc = "Weekly review" },
		{
			"<leader>oa",
			function()
				-- Agenda: all open checkboxes across notes
				Snacks.picker.grep({
					cwd = notes_dir,
					search = "^\\s*- \\[ \\]",
					regex = true,
					live = false,
				})
			end,
			desc = "Agenda (open todos)",
		},
		{
			"<leader>oo",
			"<cmd>edit " .. notes_dir .. "/scratch.md<cr>",
			desc = "Scratch",
		},
	},
}
