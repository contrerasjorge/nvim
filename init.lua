local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local f = require("settings.functions")
local map = f.map
local opt = f.opt


-- Colors!
cmd("colorscheme onedark")
cmd([[let g:gruvbox_contrast_dark = 'hard']])
cmd([[if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif]])
cmd([[let ayucolor="mirage"]])


----------------------------------
-- SETUP PLUGINS -----------------
----------------------------------
cmd([[packadd packer.nvim]])
require("plugins")
require("settings.functions")
require("settings.compe").setup()
require("settings.telescope").setup()
require("settings.lsp").setup()

require("nvim-autopairs").setup()
require('gitsigns').setup()

require("nvim-treesitter.configs").setup({
  playground = { enable = true },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  ensure_installed = "maintained",
  highlight = { enable = true },
})

--[[
require("lspsaga").init_lsp_saga({
  server_filetype_map = { metals = { "sbt", "scala" } },
  code_action_prompt = { virtual_text = false },
})
]]


----------------------------------
-- OPTIONS -----------------------
----------------------------------
local indent = 2
vim.o.shortmess = string.gsub(vim.o.shortmess, "F", "") .. "c"
vim.o.path = vim.o.path .. "**"

-- global
opt("o", "termguicolors", true)
opt("o", "hidden", true)
opt("o", "showtabline", 1)
opt("o", "updatetime", 300)
opt("o", "showmatch", true)
opt("o", "laststatus", 2)
opt("o", "wildignore", ".git,*/node_modules/*,*/target/*,.metals,.bloop")
opt("o", "ignorecase", true)
opt("o", "smartcase", true)
opt("o", "clipboard", "unnamed")
opt("o", "completeopt", "menu,menuone,noselect")

-- window-scoped
opt("w", "wrap", false)
opt("w", "cursorline", true)
opt("w", "signcolumn", "yes")

-- buffer-scoped
opt("b", "tabstop", indent)
opt("b", "shiftwidth", indent)
opt("b", "softtabstop", indent)
opt("b", "expandtab", true)
opt("b", "fileformat", "unix")


----------------------------------
-- VARIABLES ---------------------
----------------------------------
g["mapleader"] = " "
g["netrw_gx"] = "<cWORD>"

map("n", "<leader>n", [[:set relativenumber! nu!<CR>]])

-- nvim-metals
g["metals_server_version"] = "0.10.2-SNAPSHOT"

-- LSP
map("n", "gD", [[<cmd>lua vim.lsp.buf.declaration()<CR>]])
map("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]])
map("n", "K", [[<cmd>lua require"lspsaga.hover".render_hover_doc()<CR>]])
map("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]])
map("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]])
map("n", "gds", [[<cmd>lua require"telescope.builtin".lsp_document_symbols()<CR>]])
map("n", "gws", [[<cmd>lua require"settings.telescope".lsp_workspace_symbols()<CR>]])
map("n", "<leader>rn", [[<cmd>lua require"lspsaga.rename".rename()<CR>]])
map("n", "<leader>ca", [[<cmd>lua require"lspsaga.codeaction".code_action()<CR>]])
map("v", "<leader>ca", [[<cmd>lua require"lspsaga.codeaction".range_code_action()<CR>]])
map("n", "<leader>ws", [[<cmd>lua require"metals".worksheet_hover()<CR>]])
map("n", "<leader>a", [[<cmd>lua require"metals".open_all_diagnostics()<CR>]])
map("n", "<leader>d", [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]]) -- buffer diagnostics only
map("n", "<leader>e", [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]]) -- buffer diagnostics only
map("n", "]c", [[<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()<CR>]])
map("n", "[c", [[<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()<CR>]])
map("n", "<leader>ln", [[<cmd>lua vim.lsp.diagnostic.get_line_diagnostics()<CR>]])
map("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")

-- possibly delete stuff below
map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>' )
map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>' )
map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>' )
map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>' )
map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' )
map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>' )
map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>' )
map('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>' )
-- up to here of course

-- completion
map("i", "<S-Tab>", [[pumvisible() ? "<C-p>" : "<Tab>"]], { expr = true })
map("i", "<Tab>", [[pumvisible() ? "<C-n>" : "<Tab>"]], { expr = true })
map("i", "<CR>", [[compe#confirm("<CR>")]], { expr = true })

-- telescope
map("n", "<leader>ff", [[<cmd>lua require"telescope.builtin".find_files()<CR>]])
map("n", "<leader>fg", [[<cmd>lua require"telescope.builtin".live_grep()<CR>]])
map("n", "<leader>fb", [[<cmd>lua require"telescope.builtin".buffers()<CR>]])
map("n", "<leader>fh", [[<cmd>lua require"telescope.builtin".help_tags()<CR>]])
map("n", "<leader>fl", [[<cmd>lua require"telescope.builtin".git_files()<CR>]])
map("n", "<leader>fs", [[<cmd>lua require"telescope.builtin".file_browser()<CR>]])
map("n", "<leader>fd", [[<cmd>lua require"telescope.builtin".lsp_workspace_diagnostics()<CR>]])
map("n", "<leader>fp", [[<cmd>lua require"telescope.builtin".oldfiles()<CR>]])
-- 一番の大事な設定
map("n", "<leader>fc", [[<cmd>lua require"telescope.builtin".colorscheme()<CR>]])

-- nvim-dap
map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>dtb", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])

-- Nvim-tree 
map("n", "<leader>tt", [[:NvimTreeToggle<CR>]])
map("n", "<leader>tr", [[:NvimTreeRefresh<CR>]])
cmd([[let g:nvim_tree_side = 'right']])
cmd([[let g:nvim_tree_add_trailing = 1]])
--cmd([[let g:nvim_tree_quit_on_open = 1]])

-- Fugitive
map("n", "<leader>gs", [[:G<CR>]])
map("n", "<leader>gj", [[:diffget //3<CR>]])
map("n", "<leader>gf", [[:diffget //2<CR>]])

-- Markdown Preview
map("n", "<C-s>", [[<Plug>MarkdownPreviewToggle]])

-- Copy and stuff
map("n", "<leader>y", [["+y]])
map("v", "<leader>y", [["+y]])
map("n", "<leader>V", [[gg"+yG]])

-- 端末
map("t", "<Esc>", [[<C-\><C-n>]])
map("n", "<leader>;t", [[:terminal<CR>]])

cmd([[let g:NERDCreateDefaultMappings = 0]])
cmd([[let g:NERDSpaceDelims = 1]])
map("n", "<leader>cc", [[:call NERDComment(0,"toggle")<CR>]])


----------------------------------
-- COMMANDS ----------------------
----------------------------------
cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])
cmd([[autocmd FileType markdown setlocal textwidth=80]])
cmd([[autocmd BufEnter *.js call matchadd('ColorColumn', '\%81v', 100)]])
cmd([[autocmd BufReadPost,BufNewFile *.md,*.txt,COMMIT_EDITMSG set wrap linebreak nolist spell spelllang=en_us complete+=kspell]])
cmd([[autocmd BufReadPost,BufNewFile .html,*.txt,*.md,*.adoc set spell spelllang=en_us]])
cmd([[autocmd TermOpen * startinsert]])

-- tslime.vim
cmd([[let g:tslime_ensure_trailing_newlines = 1]]) -- Always send newline
cmd([[let g:tslime_normal_mapping = '<leader>sl']])
cmd([[let g:tslime_visual_mapping = '<leader>sl']])

-- LSP
cmd([[augroup lsp]])
cmd([[autocmd!]])
cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(Metals_config)]])
cmd([[augroup end]])

-- Needed to esnure float background doesn't get odd highlighting
-- https://github.com/joshdick/onedark.vim#onedarkset_highlight
cmd([[augroup colorset]])
cmd([[autocmd!]])
cmd([[autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" } })]])
cmd([[augroup END]])
cmd([[set nohlsearch]])


----------------------------------
-- Language Settings ------------------
----------------------------------

-- Go
cmd([[augroup ft_golang]])
cmd([[au!]])
cmd([[au BufEnter,BufNewFile,BufRead *.go setlocal formatoptions+=roq]])
cmd([[au BufEnter,BufNewFile,BufRead *.go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 nolist]])
cmd([[au BufEnter,BufNewFile,BufRead *.tmpl setlocal filetype=html]])
cmd([[augroup END]])
cmd([[autocmd BufWritePre *.go lua Goimports(1000)]])

-- Rust
cmd([[augroup ft_rust]])
cmd([[au!]])
cmd([[au BufEnter,BufNewFile,BufRead *.rs :compiler cargo]])
cmd([[au FileType rust set nolist]])
cmd([[augroup END]])

-- Racket
cmd([[au BufEnter,BufNewFile,BufRead *.rkt set filetype=racket]])

-- Python
cmd([[au BufNewFile,BufRead *.py
    \| set tabstop=4
    \| set softtabstop=4
    \| set shiftwidth=4
    \| set textwidth=79
    \| set expandtab
    \| set autoindent
    \| set fileformat=unix]])


-- C & C++
cmd([[augroup ft_c]])
cmd([[au!]])
cmd([[au BufNewFile,BufRead *.h,*.c setlocal filetype=c]])
cmd([[au Filetype c setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4]])
cmd([[au Filetype c setlocal cinoptions=l1,t0,g0 " This fixes weird indentation of switch/case]])
cmd([[augroup END]])

--[[]]
cmd([[let g:clang_format#style_options = { "AccessModifierOffset" : -4, "IndentWidth": 4, "TabWidth": 4, "AllowShortIfStatementsOnASingleLine" : "true", "AlwaysBreakTemplateDeclarations" : "true", "BreakBeforeBraces" : "Stroustrup" }]])
--]]
-- let g:clang_format#auto_format = 1
-- map to <Leader>cf in C++ code
cmd([[autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>]])
cmd([[autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>]])

-- JS & TS 
cmd([[augroup ft_typescript]])
cmd([[au!]])
cmd([[au Filetype typescript setlocal shiftwidth=2 softtabstop=2 expandtab]])
cmd([[augroup END]])

-- JSON color highlighting
cmd([[autocmd FileType json syntax match Comment +\/\/.\+$+]])


----------------------------------
-- LSP Settings ------------------
----------------------------------
--fn.sign_define("LspDiagnosticsSignError", { text = "▬" })
--fn.sign_define("LspDiagnosticsSignWarning", { text = "▬" })
--fn.sign_define("LspDiagnosticsSignInformation", { text = "▬" })
--fn.sign_define("LspDiagnosticsSignHint", { text = "▬" })

cmd([[hi! link LspReferenceText CursorColumn]])
cmd([[hi! link LspReferenceRead CursorColumn]])
cmd([[hi! link LspReferenceWrite CursorColumn]])

cmd([[hi! link LspSagaFinderSelection CursorColumn]])
cmd([[hi! link LspSagaDocTruncateLine LspSagaHoverBorder]])

