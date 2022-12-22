local M = {}

function M.setup()
    require("nvim-tree").setup {
        git = {
            ignore = false
        },
        view = {
            adaptive_size = true,
            mappings = {
                list = {
                    { key = 'fi', action = 'live_filter'}
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


    local mappings = {
      ['<leader>n'] = ':NvimTreeFocus<CR>',
      ['<leader>N'] = ':NvimTreeFindFile<CR>',
    }

    for keys, mapping in pairs(mappings) do
      vim.api.nvim_set_keymap('n', keys, mapping, { noremap = true, silent = true })
    end
end

return M
