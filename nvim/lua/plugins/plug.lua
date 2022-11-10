return require('packer').startup({function(use)
  -- [[ Plugins Go Here ]
    use 'wbthomason/packer.nvim'
    use {                                              -- filesystem navigation
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons'        -- filesystem icons
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt=true}
    }

    -- use { 'Mofiqul/dracula.nvim' }
    use { 'navarasu/onedark.nvim' }

    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { "nvim-telescope/telescope-file-browser.nvim" }

    use 'ThePrimeagen/harpoon'

    use { 'Yggdroot/indentLine' }
    use { 'windwp/nvim-autopairs' }
    use { 'windwp/nvim-ts-autotag' }

    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }
    use { 'machakann/vim-highlightedyank' }
    use { 'tpope/vim-projectionist' }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({with_sync = true}) end,
    }

    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use {'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }}
    use {'RishabhRD/popfix'}
    use {'RishabhRD/nvim-lsputils'}

    use 'vim-test/vim-test'
    use { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" }
    use 'pocco81/auto-save.nvim'

    use {"jose-elias-alvarez/null-ls.nvim"}
    use {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function() require('plugins.gitsigns').setup() end
    }
    use 'tpope/vim-fugitive'
    use 'tpope/vim-abolish'
    use 'sindrets/diffview.nvim'

    use { 'mfussenegger/nvim-dap' }
    use { 'mfussenegger/nvim-dap-python' }

    use { 'sbdchd/neoformat' }

    use { 'phaazon/mind.nvim', branch = 'v2' }

    use { 'norcalli/nvim-colorizer.lua' }
    use { 'phaazon/hop.nvim', branch = 'v2' }

    use { 'dstein64/vim-startuptime' }
end,
config = {
  package_root = vim.fn.stdpath('config') .. '/site/pack'
}})

