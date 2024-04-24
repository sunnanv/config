return {
    {
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            keys = "<leader>m",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            config = function()
                local harpoon = require('harpoon')


                harpoon:setup()


                local conf = require("telescope.config").values
                local function toggle_telescope(harpoon_files)
                    local file_paths = {}
                    for _, item in ipairs(harpoon_files.items) do
                        table.insert(file_paths, item.value)
                    end

                    require("telescope.pickers").new({}, {
                        prompt_title = "Harpoon",
                        finder = require("telescope.finders").new_table({
                            results = file_paths,
                        }),
                        previewer = conf.file_previewer({}),
                        sorter = conf.generic_sorter({}),
                    }):find()
                end

                local mappings = {
                    ['<leader>ma'] = function()
                        harpoon:list():add()
                    end,
                    ['<leader>md'] = function()
                        harpoon:list():remove()
                    end,
                    ['<leader>mu'] = function()
                        toggle_telescope(harpoon:list())
                    end,
                    ['<leader>mc'] = function()
                        harpoon:list():clear()
                    end,
                    ['<leader>m1'] = function()
                        harpoon:list():select(1)
                    end,
                    ['<leader>m2'] = function()
                        harpoon:list():select(2)
                    end,
                    ['<leader>m3'] = function()
                        harpoon:list():select(3)
                    end,
                    ['<leader>m4'] = function()
                        harpoon:list():select(4)
                    end,
                    ['<leader>mm'] = function()
                        harpoon:list():next({ ui_nav_wrap = true })
                    end,
                    ['<leader>mj'] = function()
                        harpoon:list():prev({ ui_nav_wrap = true })
                    end,
                    ['<leader>mk'] = function()
                        harpoon:list():next({ ui_nav_wrap = true })
                    end,
                }

                for keys, mapping in pairs(mappings) do
                    vim.api.nvim_set_keymap('n', keys, '', { callback = mapping, noremap = true, silent = true })
                end
            end
        },
    }
}
