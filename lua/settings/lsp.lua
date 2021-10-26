local M = {}

M.setup = function()
    local shared_diagnostic_settings = vim.lsp.with(
                                           vim.lsp.diagnostic
                                               .on_publish_diagnostics,
                                           {virtual_text = false})
    local lsp_config = require("lspconfig")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    lsp_config.util.default_config = vim.tbl_extend("force", lsp_config.util
                                                        .default_config, {
        handlers = {
            ["textDocument/publishDiagnostics"] = shared_diagnostic_settings
        },
        capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
    })

    Metals_config = require("metals").bare_config()

    Metals_config.settings = {
        showImplicitArguments = true,
        showInferredType = true,
        excludedPackages = {
            "akka.actor.typed.javasl", "com.github.swagger.akka.javadsl",
            "akka.stream.javadsl"
        }
    }

    Metals_config.init_options.statusBarProvider = "on"
    Metals_config.handlers["textDocument/publishDiagnostics"] =
        shared_diagnostic_settings
    Metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(
                                     capabilities)

    local dap = require("dap")

    dap.configurations.scala = {
        {
            type = "scala",
            request = "launch",
            name = "Run",
            metals = {
                runType = "run",
                args = {"firstArg", "secondArg", "thirdArg"}
            }
        }, {
            type = "scala",
            request = "launch",
            name = "Test File",
            metals = {runType = "testFile"}
        }, {
            type = "scala",
            request = "launch",
            name = "Test Target",
            metals = {runType = "testTarget"}
        }
    }

    Metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
    end

    -- sumneko lua
    lsp_config.sumneko_lua.setup({
        cmd = {
            "/Users/contrerasjorge/.cache/nvim/nlua/sumneko_lua/lua-language-server/bin/macOS/lua-language-server"
        },
        args = {
            "-E",
            "/Users/contrerasjorge/.cache/nvim/nlua/sumneko_lua/lua-language-server/main.lua"
        },
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT", -- since using mainly for neovim
                    path = vim.split(package.path, ";")
                },
                diagnostics = {
                    globals = {"vim", "it", "describe", "before_each"}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                    }
                }
            }
        }
    })

    lsp_config.jsonls.setup({
        commands = {
            Format = {
                function()
                    vim.lsp.buf.range_formatting({}, {0, 0},
                                                 {vim.fn.line("$"), 0})
                end
            }
        }
    })

    lsp_config.dockerls.setup({})
    lsp_config.yamlls.setup({})
    lsp_config.pyright.setup({})
    lsp_config.rust_analyzer.setup({})

    lsp_config.clojure_lsp.setup {}
    lsp_config.ocamllsp.setup {}
    lsp_config.hls.setup {}
    lsp_config.elmls.setup {}
    lsp_config.purescriptls.setup {}

    lsp_config.html.setup({})
    lsp_config.cssls.setup({})
    lsp_config.tailwindcss.setup {}

    lsp_config.tsserver.setup({
        on_attach = function(client, bufnr)
            require("nvim-lsp-ts-utils").setup({})

            -- no default maps, so you may want to define some here
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>",
                                        {silent = true})
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gr",
                                        ":TSLspRenameFile<CR>", {silent = true})
            vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>",
                                        {silent = true})
        end
    })

    lsp_config.gopls.setup({
        cmd = {"gopls", "serve"},
        settings = {
            gopls = {analyses = {unusedparams = true}, staticcheck = true}
        }
    })

    lsp_config.clangd.setup({root_dir = function() return vim.loop.cwd() end})
end

-- Go imports
function Goimports(timeout_ms)
    local context = {source = {organizeImports = true}}
    vim.validate({context = {context, "t", true}})
    local params = vim.lsp.util.make_range_params()
    params.context = context
    local method = "textDocument/codeAction"
    local resp = vim.lsp.buf_request_sync(0, method, params, timeoutms)
    if resp and resp[1] then
        local result = resp[1].result
        if result and result[1] then
            local edit = result[1].edit
            vim.lsp.util.apply_workspace_edit(edit)
        end
    end
    vim.lsp.buf.formatting()
end

return M
