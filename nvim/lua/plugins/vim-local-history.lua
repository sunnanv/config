local M = {}

function M.setup()
    vim.g.local_history_path = os.getenv('HOME') .. "/.vim/local_history"
    vim.g.local_history_max_changes = 500
    vim.g.local_history_new_change_delay = 60
end

return M
