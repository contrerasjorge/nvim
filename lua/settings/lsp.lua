local M = {}

--local servers = {'diagnosticls', 'cssls', 'html', 'pyright', 'gopls', 'rust_analyzer'}
--for _, lsp in ipairs(servers) do
  --lsp_config[lsp].setup {
    --on_attach = on_attach,
  --}
--end


M.setup = function()
  local shared_diagnostic_settings = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })
  local lsp_config = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  lsp_config.util.default_config = vim.tbl_extend("force", lsp_config.util.default_config, {
    handlers = {
      ["textDocument/publishDiagnostics"] = shared_diagnostic_settings,
    },
    capabilities = capabilities,
  })

  Metals_config = require("metals").bare_config
  Metals_config.settings = {
    showImplicitArguments = true,
    showInferredType = true,
    excludedPackages = {
      "akka.actor.typed.javasl",
      "com.github.swagger.akka.javadsl",
      "akka.stream.javadsl",
    },
    --fallbackScalaVersion = "2.13.5"
  }

  Metals_config.init_options.statusBarProvider = "on"
  Metals_config.handlers["textDocument/publishDiagnostics"] = shared_diagnostic_settings
  Metals_config.capabilities = capabilities

  local dap = require("dap")

  -- For that they usually provide a `console` option in their |dap-configuration|.
  -- The supported values are usually called `internalConsole`, `integratedTerminal`
  -- and `externalTerminal`.

  dap.configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "Run",
      metalsRunType = "run",
    },
    {
      type = "scala",
      request = "launch",
      name = "Test File",
      metalsRunType = "testFile",
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      metalsRunType = "testTarget",
    },
  }

  Metals_config.on_attach = function(client, bufnr)
    require("metals").setup_dap()
  end

  -- sumneko lua
  lsp_config.sumneko_lua.setup({
    --/Users/contrerasjorge/.cache/nvim/nlua/sumneko_lua/lua-language-server
    cmd = {
      --"/Users/contrerasjorge/.cache/lua-workspace/lua-language-server/bin/macOS/lua-language-server",
      "/Users/contrerasjorge/.cache/nvim/nlua/sumneko_lua/lua-language-server/bin/macOS/lua-language-server",
      "-E",
      --"/Users/contrerasjorge/.cache/lua-workspace/lua-language-server/main.lua",
      "/Users/contrerasjorge/.cache/nvim/nlua/sumneko_lua/lua-language-server/main.lua",
    },
    commands = {
      Format = {
        function()
          require("stylua-nvim").format_file()
        end,
      },
    },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT", -- since using mainly for neovim
          path = vim.split(package.path, ";"),
        },
        diagnostics = { globals = { "vim", "it" } },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
        },
      },
    },
  })

  --lsp_config.dockerls.setup({})
  --lsp_config.jsonls.setup({
    --commands = {
      --Format = {
        --function()
          --vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
        --end,
      --},
    --},
  --})
  --lsp_config.yamlls.setup({})
  --lsp_config.racket_langserver.setup({})
  lsp_config.html.setup({})
  lsp_config.cssls.setup({})
  lsp_config.rust_analyzer.setup({})
--local servers = {'diagnosticls', 'cssls', 'html', 'pyright', 'gopls', 'rust_analyzer'}
  --lsp_config.diagnosticls.setup({})

  lsp_config.tsserver.setup({
    on_attach = function(client, bufnr)
      require("nvim-lsp-ts-utils").setup {}

      -- no default maps, so you may want to define some here
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", {silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, "n", "qq", ":TSLspFixCurrent<CR>", {silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", {silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", {silent = true})
    end
  })

  lsp_config.gopls.setup({
    cmd = { "gopls", "serve" },
    settings = {
      gopls = { analyses = { unusedparams = true }, staticcheck = true },
    },
  })

  lsp_config.clangd.setup {
    root_dir = function() return vim.loop.cwd() end
  }

  --vim.lsp.set_log_level('trace')

  local filetypes = {
    javascript = "eslint",
    typescript = "eslint",
    typescriptreact = "eslint",
    python = "flake8"
  }

  local linters = {
    eslint = {
      sourceName = "eslint",
      command = "eslint_d",
      rootPatterns = {".eslintrc.json", "package.json"},
      debounce = 100,
      args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
      parseJson = {
        errorsRoot = "[0].messages",
        line = "line",
        column = "column",
        endLine = "endLine",
        endColumn = "endColumn",
        message = "${message} [${ruleId}]",
        security = "severity"
      },
      securities = {[2] = "error", [1] = "warning"}
    },
    flake8 = {
      comman= "flake8",
      debounce= 100,
      args= { "--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s", "-" },
      offsetLine= 0,
      offsetColumn= 0,
      sourceName= "flake8",
      formatLines= 1,
      formatPattern= {
        "(\\d+),(\\d+),([A-Z]),(.*)(\\r|\\n)*$",
        {
          line= 1,
          column= 2,
          security= 3,
          message= 4
        }
      },
      securities= {
        ["W"]= "warning",
        ["E"]= "error",
        ["F"]= "error",
        ["C"]= "error",
        ["N"]= "error"
      }
    }
  }

  local formatters = {
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}},
    black = {
      command = "black",
      args= {"--quiet", "-"}
    }
  }

  local formatFiletypes = {
    javascript = "prettier",
    typescript = "prettier",
    typescriptreact = "prettier",
    python = "black"
  }

  lsp_config.diagnosticls.setup {
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
      filetypes = filetypes,
      linters = linters,
      formatters = formatters,
      formatFiletypes = formatFiletypes
    }
  }


end

-- Go imports
function Goimports(timeoutms)
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, "t", true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  -- See the implementation of the textDocument/codeAction callback
  -- (lua/vim/lsp/handler.lua) for how to do this properly.
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  if not result or next(result) == nil then return end
  local actions = result[1].result
  if not actions then return end
  local action = actions[1]

  -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
  -- is a CodeAction, it can have either an edit, a command or both. Edits
  -- should be executed first.
  if action.edit or type(action.command) == "table" then
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit)
    end
    if type(action.command) == "table" then
      vim.lsp.buf.execute_command(action.command)
    end
  else
    vim.lsp.buf.execute_command(action)
  end
end

return M
