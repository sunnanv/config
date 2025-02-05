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
            },
            config = function()
                local harpoon = require('harpoon')
                harpoon:setup()
            end
        },
    }
}
