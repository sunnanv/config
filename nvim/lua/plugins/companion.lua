return {
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        config = true,
        dependencies = {
            "j-hui/fidget.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { '<M-a>',     '<cmd>CodeCompanionActions<cr>',     mode = { 'n', 'v' } },
            { "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" } },
            { "ga",        "<cmd>CodeCompanionChat Add<cr>",    mode = 'v' }
        },
        opts = {
            strategies = {
                chat = {
                    adapter = 'copilot',
                    tools = {
                        vectorcode = {
                            description = "Run VectorCode to retrieve the project context.",
                            callback = function()
                                return require("vectorcode.integrations").codecompanion.chat.make_tool()
                            end,
                        },
                    }
                },
                inline = {
                    adapter = 'copilot'
                },
                cmd = {
                    adapter = 'copilot'
                },
            },
            display = {
                diff = {
                    provider = 'mini_diff'
                },
            },
            prompt_library = {
            }

        },
        init = function()
            local progress = require("fidget.progress")
            local handles = {}

            local function store_progress_handle(id, handle)
                handles[id] = handle
            end

            local function pop_progress_handle(id)
                local handle = handles[id]
                handles[id] = nil
                return handle
            end

            local function llm_role_title(adapter)
                local parts = {}
                table.insert(parts, adapter.formatted_name)
                if adapter.model and adapter.model ~= "" then
                    table.insert(parts, "(" .. adapter.model .. ")")
                end
                return table.concat(parts, " ")
            end

            local function create_progress_handle(request)
                return progress.handle.create({
                    title = "",
                    message = "  Sending...",
                    lsp_client = {
                        name = llm_role_title(request.data.adapter),
                    },
                })
            end

            local function report_exit_status(handle, request)
                if request.data.status == "success" then
                    handle.message = "Completed"
                elseif request.data.status == "error" then
                    handle.message = " Error"
                else
                    handle.message = "󰜺 Cancelled"
                end
            end

            local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

            vim.api.nvim_create_autocmd({ "User" }, {
                pattern = "CodeCompanionRequestStarted",
                group = group,
                callback = function(request)
                    local handle = create_progress_handle(request)
                    store_progress_handle(request.data.id, handle)
                end,
            })

            vim.api.nvim_create_autocmd({ "User" }, {
                pattern = "CodeCompanionRequestFinished",
                group = group,
                callback = function(request)
                    local handle = pop_progress_handle(request.data.id)
                    if handle then
                        report_exit_status(handle, request)
                        handle:finish()
                    end
                end,
            })
        end
    },
    {
        "Davidyz/VectorCode",
        version = "*", -- optional, depending on whether you're on nightly or release
        dependencies = { "nvim-lua/plenary.nvim" },
    }
}
