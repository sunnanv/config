return require('packer').startup({ function(use)
    use 'wbthomason/packer.nvim'

    -- UI
    use 'kyazdani42/nvim-web-devicons'
    use {
        'kyazdani42/nvim-tree.lua',
        config = function() require 'plugins.nvim-tree'.setup() end,
        requires = 'kyazdani42/nvim-web-devicons'
    }
    use {
        'nvim-lualine/lualine.nvim',
        config = function() require 'plugins.lualine'.setup() end,
        requires = 'kyazdani42/nvim-web-devicons'
    }
    use {
        'navarasu/onedark.nvim',
        config = function() require 'plugins.onedark'.setup() end
    }


    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require 'nvim-treesitter.install'.update { with_sync = true } () end,
        config = function() require 'plugins.nvim-treesitter'.setup() end,
    }
    use 'windwp/nvim-ts-autotag'
    use {
        'windwp/nvim-autopairs',
        config = function() require 'plugins.nvim-autopairs'.setup() end,
    }

    -- LSP and related
    use {
        'VonHeikemen/lsp-zero.nvim',
        config = function() require 'plugins.lsp-zero'.setup() end,
        requires = {
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
        }
    }

    use {
        'jayp0521/mason-null-ls.nvim',
        config = function() require 'plugins.null-ls'.setup() end,
        requires = {
            { 'williamboman/mason.nvim' },
            { 'jose-elias-alvarez/null-ls.nvim' }
        }
    }

    use {
        'mfussenegger/nvim-dap',
        config = function() require 'plugins.nvim-dap'.setup() end,
        requires = {
            'mfussenegger/nvim-dap-python',
            'rcarriga/nvim-dap-ui',
            'theHamsta/nvim-dap-virtual-text',
        }
    }


    -- Testing
    use {
        'vim-test/vim-test',
        config = function() require 'plugins.vim-test'.setup() end,
    }


    -- Telescope
    use 'nvim-lua/plenary.nvim'
    use {
        'nvim-telescope/telescope.nvim',
        config = function() require 'plugins.telescope'.setup() end,
        requires = 'nvim-lua/plenary.nvim'
    }
    use "nvim-telescope/telescope-file-browser.nvim"


    -- harpoon
    use {
        'ThePrimeagen/harpoon',
        config = function() require 'plugins.harpoon'.setup() end
    }


    -- GIT
    use {
        'lewis6991/gitsigns.nvim',
        config = function() require('plugins.gitsigns').setup() end,
        requires = 'nvim-lua/plenary.nvim',
    }
    use 'tpope/vim-fugitive'
    use 'sindrets/diffview.nvim'
    -- Utils
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'machakann/vim-highlightedyank'
    use 'pocco81/auto-save.nvim'
    use 'tpope/vim-abolish'
    use {
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require("nvim-highlight-colors").setup {
                enable_tailwind = true
            }
        end
    }


    use {
        'phaazon/hop.nvim',
        branch = 'v2',
        config = function() require 'plugins.hop'.setup() end,
    }
    use { 'lukas-reineke/indent-blankline.nvim',
        config = function() require 'plugins.indent-blankline'.setup() end
    }

    use {
        'phaazon/mind.nvim',
        branch = 'v2.2',
        config = function() require 'plugins.mind'.setup() end,
        requires = {
            'nvim-lua/plenary.nvim'
        }
    }

end,
    config = {
        package_root = vim.fn.stdpath('config') .. '/site/pack'
    } })
