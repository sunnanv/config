return {
    {
        "tpope/vim-fugitive",
        cmd = {
            'Git',
            "GBrowse"
        },
        dependencies = 'tpope/vim-rhubarb'
    },
    {
        'akinsho/git-conflict.nvim',
        keys = {
            ']x', '[x'
        },
        cmd = {
            'GitConflictChooseOurs',
            'GitConflictChooseTheirs',
            'GitConflictChooseBoth',
            'GitConflictChooseNone',
            'GitConflictListQf',
        },
        version = "*",
        event = "VeryLazy",
        opts = {}
    },
}
