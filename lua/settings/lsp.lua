local M = {}

M.setup = function()
	local shared_diagnostic_settings = 
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })
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
	}

	Metals_config.init_options.statusBarProvider = "on"
	Metals_config.handlers["textDocument/publishDiagnostics"] = shared_diagnostic_settings
	Metals_config.capabilities = capabilities

	local dap = require("dap")

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
		cmd = {
			"/Users/contrerasjorge/.cache/nvim/nlua/sumneko_lua/lua-language-server/bin/macOS/lua-language-server",
		},
		args = {
			"-E",
			"/Users/contrerasjorge/.cache/nvim/nlua/sumneko_lua/lua-language-server/main.lua",
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
  --
  lsp_config.html.setup({
  })
  lsp_config.cssls.setup({})
  lsp_config.pyright.setup({})
  lsp_config.rust_analyzer.setup({})

  -- local servers = { "pyright", "rust_analyzer", "html", "cssls" }
  -- for _, lsp in ipairs(servers) do
    -- lsp_config[lsp].setup { 
        -- capabilities = capabilities;
        -- on_attach = on_attach;
        -- -- init_options = {
        -- --     onlyAnalyzeProjectsWithOpenFiles = true,
        -- --     suggestFromUnimportedLibraries = false,
        -- --     closingLabels = true,
        -- -- };
    -- }
  -- end

	lsp_config.tsserver.setup({
		on_attach = function(client, bufnr)
			require("nvim-lsp-ts-utils").setup({})

			-- no default maps, so you may want to define some here
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", { silent = true })
			vim.api.nvim_buf_set_keymap(bufnr, "n", "qq", ":TSLspFixCurrent<CR>", { silent = true })
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", { silent = true })
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", { silent = true })
		end,
	})

	lsp_config.gopls.setup({
		cmd = { "gopls", "serve" },
		settings = {
			gopls = { analyses = { unusedparams = true }, staticcheck = true },
		},
	})

	lsp_config.clangd.setup({
		root_dir = function()
			return vim.loop.cwd()
		end,
	})

  local eslint = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    lintIgnoreExitCode = true,
    formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
    formatStdin = true
  }

  local function eslint_config_exists()
    local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

    if not vim.tbl_isempty(eslintrc) then
      return true
    end

    if vim.fn.filereadable("package.json") then
      if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
        return true
      end
    end

    return false
  end

  lsp_config.efm.setup {
    on_attach = function(client)
      client.resolved_capabilities.document_formatting = true
      client.resolved_capabilities.goto_definition = false
      set_lsp_config(client)
      end,
      root_dir = function()
        if not eslint_config_exists() then
          return nil
            end
            return vim.fn.getcwd()
            end,
            settings = {
              languages = {
                javascript = {eslint},
                javascriptreact = {eslint},
                ["javascript.jsx"] = {eslint},
                typescript = {eslint},
                ["typescript.tsx"] = {eslint},
                typescriptreact = {eslint},
                lua = {
                  {formatCommand = "lua-format -i", formatStdin = true}
                }
              }
            },
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescript.tsx",
              "typescriptreact"
            },
  }

  -- require "lspconfig".efm.setup {
    -- init_options = {documentFormatting = true},
    -- settings = {
      -- rootMarkers = {".git/"},
      -- languages = {
        -- lua = {
          -- {formatCommand = "lua-format -i", formatStdin = true}
        -- },
        -- python = {
          -- {lintCommand = "flake8 --stdin-display-name ${INPUT} -", lintStdin = true, lintFormats = "%f:%l:%c: %m"},
          -- {formatCommand = "black --quiet -", formatStdin = true}
        -- },
        -- javascript = {
          -- {lintCommand = "eslint -f visualstudio --stdin --stdin-filename ${INPUT}", lintStdin = true},
          -- {formatCommand = "prettier --stdin-filepath"}
        -- }
      -- }
    -- }
  -- }

  -- local filetypes = {
    -- javascript = "eslint",
    -- typescript = "eslint",
    -- typescriptreact = "eslint",
    -- python = "flake8",
  -- }

  -- local linters = {
    -- eslint = {
      -- sourceName = "eslint",
      -- command = "eslint_d",
      -- rootPatterns = { ".eslintrc.json", "package.json" },
      -- debounce = 100,
      -- args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
      -- parseJson = {
        -- errorsRoot = "[0].messages",
        -- line = "line",
        -- column = "column",
        -- endLine = "endLine",
        -- endColumn = "endColumn",
        -- message = "${message} [${ruleId}]",
        -- security = "severity",
      -- },
      -- securities = { [2] = "error", [1] = "warning" },
    -- },
    -- flake8 = {
      -- comman = "flake8",
      -- debounce = 100,
      -- args = { "--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s", "-" },
      -- offsetLine = 0,
      -- offsetColumn = 0,
      -- sourceName = "flake8",
      -- formatLines = 1,
      -- formatPattern = {
        -- "(\\d+),(\\d+),([A-Z]),(.*)(\\r|\\n)*$",
        -- {
          -- line = 1,
          -- column = 2,
          -- security = 3,
          -- message = 4,
        -- },
      -- },
      -- securities = {
        -- ["W"] = "warning",
        -- ["E"] = "error",
        -- ["F"] = "error",
        -- ["C"] = "error",
        -- ["N"] = "error",
      -- },
    -- },
  -- }

  -- local formatters = {
    -- prettier = { command = "prettier", args = { "--stdin-filepath", "%filepath" } },
    -- black = {
      -- command = "black",
      -- args = { "--quiet", "-" },
    -- },
  -- }

  -- local formatFiletypes = {
    -- javascript = "prettier",
    -- typescript = "prettier",
    -- typescriptreact = "prettier",
    -- python = "black",
  -- }

  -- lsp_config.diagnosticls.setup({
    -- filetypes = vim.tbl_keys(filetypes),
    -- init_options = {
      -- filetypes = filetypes,
      -- linters = linters,
      -- formatters = formatters,
      -- formatFiletypes = formatFiletypes,
    -- },
  -- })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  require('lsp_extensions.workspace.diagnostic').handler, {
    signs = {
      severity_limit = "Error",
    }
  }
)

-- Go imports
function Goimports(timeout_ms)
	local context = { source = { organizeImports = true } }
	vim.validate({ context = { context, "t", true } })
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

	-- local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
	-- if not result or next(result) == nil then
		-- return
	-- end
	-- local actions = result[1].result
	-- if not actions then
		-- return
	-- end
	-- local action = actions[1]

	-- if action.edit or type(action.command) == "table" then
		-- if action.edit then
			-- vim.lsp.util.apply_workspace_edit(action.edit)
		-- end
		-- if type(action.command) == "table" then
			-- vim.lsp.buf.execute_command(action.command)
		-- end
	-- else
		-- vim.lsp.buf.execute_command(action)
	-- end
end

return M
