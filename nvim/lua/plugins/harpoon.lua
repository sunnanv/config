return {
    {
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            keys = {
                { "ma", function() require('harpoon'):list():add() end },
                { "md", function() require('harpoon'):list():remove() end },
                { "mc", function() require('harpoon'):list():clear() end },
                { "m1", function() require('harpoon'):list():select(1) end },
                { "m2", function() require('harpoon'):list():select(2) end },
                { "m3", function() require('harpoon'):list():select(3) end },
                { "m4", function() require('harpoon'):list():select(4) end },
                { "mm", function() require('harpoon'):list():next({ ui_nav_wrap = true }) end },
                { "mj", function() require('harpoon'):list():prev({ ui_nav_wrap = true }) end },
                { "mk", function() require('harpoon'):list():next({ ui_nav_wrap = true }) end },
                { "mu", function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end }
                -- {
                --     "mu",
                --     function()
                --         local file_paths = {}
                --         local harpoon_files = require('harpoon'):list()
                --         local conf = require("telescope.config").values
                --         for _, item in ipairs(harpoon_files.items) do
                --             table.insert(file_paths, item.value)
                --         end
                --
                --         require("telescope.pickers").new({}, {
                --             prompt_title = "Harpoon",
                --             finder = require("telescope.finders").new_table({
                --                 results = file_paths,
                --             }),
                --             previewer = conf.file_previewer({}),
                --             sorter = conf.generic_sorter({}),
                --         }):find()
                --     end,
                --     desc = "Harpoon Quick Menu",
                -- },
            },
            config = function()
                local harpoon = require('harpoon')
                harpoon:setup()
            end
        },
    }
}
