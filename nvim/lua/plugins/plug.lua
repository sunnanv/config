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

    use { 'Mofiqul/dracula.nvim' }

    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use { 'Yggdroot/indentLine' }
    use { 'windwp/nvim-autopairs' }

    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }
    use { 'machakann/vim-highlightedyank' }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({with_sync = true}) end,
    }

    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'

    use 'vim-test/vim-test'
    use {
      "nvim-neotest/neotest",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "haydenmeade/neotest-jest",
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-vim-test",
      }
    }
    use 'pocco81/auto-save.nvim'

    use {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
    }
    use 'tpope/vim-fugitive'

    use { 'mfussenegger/nvim-dap' }
    use { 'mfussenegger/nvim-dap-python' }


end,
config = {
  package_root = vim.fn.stdpath('config') .. '/site/pack'
}})

