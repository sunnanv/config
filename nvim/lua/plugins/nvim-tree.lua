local M = {}

local function open_nvim_tree(data)

    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not directory then
        return
    end

    -- change to the directory
    vim.cmd.cd(data.file)

    -- open the tree
    require("nvim-tree.api").tree.open()
end

function M.setup()
    require("nvim-tree").setup {
        git = {
            ignore = false
        },
        view = {
            adaptive_size = true,
            mappings = {
                list = {
                    { key = 'fi', action = 'live_filter' }
                }
            }
        },
        actions = {
            open_file = {
                quit_on_open = true,
            }
        },
        renderer = {
            icons = {
                glyphs = {
                    git = {
                        untracked = "",
                    }
                }
            }
        }
    }

    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })


    local mappings = {
        ['<leader>n'] = ':NvimTreeFocus<CR>',
        ['<leader>N'] = ':NvimTreeFindFile<CR>',
    }

    for keys, mapping in pairs(mappings) do
        vim.api.nvim_set_keymap('n', keys, mapping, { noremap = true, silent = true })
    end
end

return M
