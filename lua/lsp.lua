
-- compe stuff

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  alow_prefix_unmatch = false;

  source = {
   path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
  end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
 -- elseif vim.fn.call("vsnip#available", {1}) == 1 then
 --   return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
--  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
 --   return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()",
                        {expr =true, silent = true})
vim.api.nvim_set_keymap("i", "<CR>", [[compe#confirm("<CR>")]],
                        {expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<C-e>", [[compe#close("<C-e>")]],
                        {expr = true, silent = true})

-- General lsp stuff                        

local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local opts = { noremap=true, silent=true }

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

end

_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
  end

-- Go imports
function goimports(timeoutms)
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


local servers = {'diagnosticls', 'cssls', 'html', 'pyright', 'gopls', 'rust_analyzer'}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
  }
end

require('nlua.lsp.nvim').setup(nvim_lsp, {
  on_attach = on_attach,

  -- Include globals you want to tell the LSP are real :)
  globals = {
    -- Colorbuddy
    "Color", "c", "Group", "g", "s",
  }
})

nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end
}

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
      command= "flake8",
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

nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}

