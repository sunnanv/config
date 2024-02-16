local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    { 'kyazdani42/nvim-web-devicons', lazy = false, priority = 1000 },
    {
        'kyazdani42/nvim-tree.lua',
        config = function() require 'plugins.nvim-tree'.setup() end,
        dependencies = 'kyazdani42/nvim-web-devicons'
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function() require 'plugins.lualine'.setup() end,
        dependencies = 'kyazdani42/nvim-web-devicons'
    },
    -- {
    --     'navarasu/onedark.nvim',
    --     config = function() require 'plugins.onedark'.setup() end
    -- },
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        config = function() require 'plugins.tokyonight'.setup() end
    },
    -- {
    --     'rmehri01/onenord.nvim',
    --     config = function() require 'plugins.onenord'.setup() end
    -- },
    {
        'nvim-treesitter/nvim-treesitter',
        version = 'v0.9.1',
        config = function() require 'plugins.nvim-treesitter'.setup() end,
        build = ":TSUpdate",
    },
    {
        'windwp/nvim-ts-autotag',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function() require('nvim-ts-autotag').setup() end,
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function() require 'plugins.nvim-autopairs'.setup() end,
    },

    {
        'voldikss/vim-floaterm',
        config = function() require 'plugins.floaterm'.setup() end,
    },
    -- LSP and related
    {
        'VonHeikemen/lsp-zero.nvim',
        config = function() require 'plugins.lsp-zero'.setup() end,
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        },
    },

    {
        'jayp0521/mason-null-ls.nvim',
        config = function() require 'plugins.null-ls'.setup() end,
        dependencies = {
            { 'williamboman/mason.nvim' },
            { 'nvimtools/none-ls.nvim' }
        },
    },

    {
        'mfussenegger/nvim-dap',
        keys = { '<leader>d' },
        config = function() require 'plugins.nvim-dap'.setup() end,
        dependencies = {
            'mfussenegger/nvim-dap-python',
            'rcarriga/nvim-dap-ui',
            'theHamsta/nvim-dap-virtual-text',
        },
    },


    -- Testing
    {
        'vim-test/vim-test',
        -- keys = { '<leader>t' },
        -- config = function() require 'plugins.vim-test'.setup() end,
    },

    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-jest",
            "nvim-neotest/neotest-vim-test",

        },
        config = function() require 'plugins.neotest'.setup() end,

    },


    -- Telescope
    'nvim-lua/plenary.nvim',
    {
        'nvim-telescope/telescope.nvim',
        config = function() require 'plugins.telescope'.setup() end,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-live-grep-args.nvim',
        },
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },


    -- harpoon
    {
        'ThePrimeagen/harpoon',
        config = function() require 'plugins.harpoon'.setup() end,
        keys = '<leader>h'
    },


    -- GIT
    {
        'lewis6991/gitsigns.nvim',
        config = function() require('plugins.gitsigns').setup() end,
        dependencies = 'nvim-lua/plenary.nvim',
    },
    'tpope/vim-fugitive',
    {
        'sindrets/diffview.nvim',
        cmd = 'DiffviewOpen',
    },
    -- Utils
    'tpope/vim-commentary',
    'tpope/vim-surround',
    -- 'machakann/vim-highlightedyank',
    'pocco81/auto-save.nvim',
    'tpope/vim-abolish',
    {
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require('nvim-highlight-colors').setup {
                enable_tailwind = true
            }
        end
    },
    'RRethy/vim-illuminate',
    'rhysd/conflict-marker.vim',
    {
        'phaazon/hop.nvim',
        branch = 'v2',
        config = function() require 'plugins.hop'.setup() end,
    },
    -- {
    --     'zbirenbaum/copilot.lua',
    --     config = function() require 'plugins.copilot'.setup() end
    -- },
    {
        'github/copilot.vim',
        config = function() require 'plugins.copilot'.setup() end

    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        opts = {
            show_help = "yes",   -- Show help text for CopilotChatInPlace, default: yes
            debug = false,       -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
            disable_extra_info = 'no', -- Disable extra information (e.g: system prompt) in the response.
            -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
        },
        build = function()
            vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
        end,
        event = "VeryLazy",
        keys = {
            { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
            { "<leader>cct", "<cmd>CopilotChatTests<cr>",   desc = "CopilotChat - Generate tests" },
            {
                "<leader>ccv",
                ":CopilotChatVisual",
                mode = "x",
                desc = "CopilotChat - Open in vertical split",
            },
            {
                "<leader>ccx",
                ":CopilotChatInPlace<cr>",
                mode = "x",
                desc = "CopilotChat - Run in-place code",
            },
        },
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function() require 'plugins.indent-blankline'.setup() end,
        main = "ibl",
        opts = {}
    },

    {
        'phaazon/mind.nvim',
        branch = 'v2.2',
        config = function() require 'plugins.mind'.setup() end,
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        cmd = { 'MindOpenMain', 'MindOpenProject', 'MindOpenSmartProject' },
    },

    {
        'dinhhuy258/vim-local-history',
        branch = 'master',
        build = ':UpdateRemotePlugins',
        config = function() require 'plugins.vim-local-history'.setup() end
    },
    {
        'tzachar/highlight-undo.nvim',
        config = function() require 'plugins.highlight-undo'.setup() end
    },
    {
        "folke/neodev.nvim",
        opts = {}
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    }
})
