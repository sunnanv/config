return {
    {
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            keys = {
                { "<leader>ma",      function() require('harpoon'):list():add() end },
                { "<leader>md",      function() require('harpoon'):list():remove() end },
                { "<leader>mc",      function() require('harpoon'):list():clear() end },
                { "<leader>m1",      function() require('harpoon'):list():select(1) end },
                { "<leader>m2",      function() require('harpoon'):list():select(2) end },
                { "<leader>m3",      function() require('harpoon'):list():select(3) end },
                { "<leader>m4",      function() require('harpoon'):list():select(4) end },
                { "<leader>mm",      function() require('harpoon'):list():next({ ui_nav_wrap = true }) end },
                { "<leader>mj",      function() require('harpoon'):list():prev({ ui_nav_wrap = true }) end },
                { "<leader>mk",      function() require('harpoon'):list():next({ ui_nav_wrap = true }) end },
                { "<leader>mu",      function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end },
                { "<C-l>", function() require('harpoon'):list():next({ ui_nav_wrap = true }) end },
                { "<C-h>", function() require('harpoon'):list():prev({ ui_nav_wrap = true }) end }
            },
            config = function()
                local harpoon = require('harpoon')
                harpoon:setup()
                local harpoon_extensions = require("harpoon.extensions")
                harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
            end
        },
    }
}
