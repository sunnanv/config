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
    use 'Pocco81/AutoSave.nvim'
end,
config = {
  package_root = vim.fn.stdpath('config') .. '/site/pack'
}})

