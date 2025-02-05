return {
    {
        "kndndrj/nvim-dbee",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        build = function()
            require("dbee").install()
        end,
        config = function()
            require("dbee").setup({
                sources = {
                    require("dbee.sources").MemorySource:new({
                        {
                            name = "dev",
                            type = "postgres",
                            url = "postgres://localhost:5432/kog?sslmode=disable",
                        },
                    }),
                    require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS")
                }
            })
        end,
    }
}
