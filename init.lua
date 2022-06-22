local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local f = require("settings.functions")
local map = f.map
local opt = vim.opt
local global_opt = vim.opt_global

----------------------------------
-- SETUP PLUGINS -----------------
----------------------------------

cmd([[packadd packer.nvim]])

require("plugins")
require("settings.globals")
require("settings.functions")
require("settings.cmp").setup()
require("settings.telescope").setup()
require("settings.lsp").setup()

require("nvim-autopairs").setup()

----------------------------------
-- OPTIONS -----------------------
----------------------------------

local indent = 2

cmd([[set nohlsearch]])
cmd([[set scrolloff=8]])

-- global
global_opt.shortmess:remove("F"):append("c")
global_opt.path:append("**")
global_opt.termguicolors = true
global_opt.hidden = true
global_opt.showtabline = 1
global_opt.updatetime = 300
global_opt.showmatch = true
global_opt.laststatus = 2
global_opt.wildignore = {
    ".git", "*/node_modules/*", "*/target/*", ".metals", ".bloop", ".ammonite"
}
global_opt.ignorecase = true
global_opt.smartcase = true
global_opt.clipboard = "unnamed"
global_opt.completeopt = {"menu", "menuone", "noselect"}

vim.api.nvim_command("set colorcolumn=80")

-- window-scoped
opt.wrap = false
opt.cursorline = true
opt.signcolumn = "yes"

-- buffer-scoped
opt.tabstop = indent
opt.shiftwidth = indent
opt.softtabstop = indent
opt.expandtab = true
opt.fileformat = "unix"

----------------------------------
-- Fun Mappings ------------------
----------------------------------

map('n', 'Y', [[y$]])

-- keep it centered!
map('n', 'n', [[nzzzv]])
map('n', 'N', [[Nzzzv]])
map('n', 'J', [[mzJ`z]])

-- undo break points
map('i', ',', [[,<c-g>u]])
map('i', '.', [[.<c-g>u]])
map('i', '!', [[!<c-g>u]])
map('i', '?', [[?<c-g>u]])

----------------------------------
-- VARIABLES ---------------------
----------------------------------
g["mapleader"] = " "
g["maplocalleader"] = ","
g["netrw_gx"] = "<cWORD>"

-- Numbers!!!
map("n", "<leader>n/",
    [[<cmd>lua RELOAD("settings.functions").toggle_nums()<CR>]])
map("n", "<leader>n", [[:set relativenumber! nu!<CR>]])

-- Neoformat
map("n", "<leader>nf", [[:Neoformat<CR>]])

-- LSP
map('n', 'gD', [[<Cmd>lua vim.lsp.buf.declaration()<CR>]])
map('n', 'gd', [[<Cmd>lua vim.lsp.buf.definition()<CR>]])
map('n', 'gi', [[<cmd>lua vim.lsp.buf.implementation()<CR>]])
map('n', 'gr', [[<cmd>lua vim.lsp.buf.references()<CR>]])
map('n', '<C-k>', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map('n', '<space>wa', [[<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>]])
map('n', '<space>wr', [[<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>]])
map('n', '<space>wl',
    [[<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>]])
map('n', '<space>D', [[<cmd>lua vim.lsp.buf.type_definition()<CR>]])
map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]])
map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]])
map('n', '<leader>e', [[<cmd>lua vim.diagnostic.open_float(0, {scope = "line"})<CR>]])
map("n", "<leader>d", [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]]) -- buffer diagnostics only
map('n', '[d', [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]])
map('n', ']d', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]])
map('n', '<space>q', [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]])
map("n", "gds",
    [[<cmd>lua require"telescope.builtin".lsp_document_symbols()<CR>]])
map("n", "gws",
    [[<cmd>lua require"settings.telescope".lsp_workspace_symbols()<CR>]])
map("n", "<leader>ws", [[<cmd>lua require"metals".worksheet_hover()<CR>]])
map("n", "<leader>ln",
    [[<cmd>lua vim.lsp.diagnostic.get_line_diagnostics()<CR>]])
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
map("n", "K", [[<cmd>lua vim.lsp.buf.hover()<CR>]])
map("n", "<leader>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]])
map("n", "<leader>ca", [[<cmd>lua vim.lsp.buf.code_action()<CR>]])

map("n", "<leader>d", [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]]) -- buffer diagnostics only
map("n", "<leader>nd", [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]])
map("n", "<leader>pd", [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]])
map("n", "<leader>ld",
    [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]])

map("n", "<leader>st",
    [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]])

-- REST
map("n", "<leader>re", [[<Plug>RestNvim]])
map("n", "<leader>rp", [[<Plug>RestNvimPreview]])

-- Harpoon 
map("n", "<leader>ha", [[<cmd>lua require("harpoon.mark").add_file()<CR>]])
map("n", "<leader>hu", [[<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]])
map("n", "<leader>hq", [[<cmd>lua require("harpoon.ui").nav_file(1)<CR>]])
map("n", "<leader>hw", [[<cmd>lua require("harpoon.ui").nav_file(2)<CR>]])
map("n", "<leader>he", [[<cmd>lua require("harpoon.ui").nav_file(3)<CR>]])
map("n", "<leader>hr", [[<cmd>lua require("harpoon.ui").nav_file(4)<CR>]])


-- Trouble
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)

-- telescope
map("n", "<leader>ff", [[<cmd>lua require"telescope.builtin".find_files()<CR>]])
map("n", "<leader>fg", [[<cmd>lua require"telescope.builtin".live_grep()<CR>]])
map("n", "<leader>fb", [[<cmd>lua require"telescope.builtin".buffers()<CR>]])
map("n", "<leader>fh", [[<cmd>lua require"telescope.builtin".help_tags()<CR>]])
map("n", "<leader>fl", [[<cmd>lua require"telescope.builtin".git_files()<CR>]])
map("n", "<leader>fs",
    [[<cmd>lua require"telescope.builtin".file_browser()<CR>]])
map("n", "<leader>fd",
    [[<cmd>lua require"telescope.builtin".lsp_workspace_diagnostics()<CR>]])
map("n", "<leader>fp", [[<cmd>lua require"telescope.builtin".oldfiles()<CR>]])
map("n", "<leader>fn",
    [[<cmd>lua require"settings.telescope".search_nvim()<CR>]])
-- 一番の大事な設定
map("n", "<leader>fc", [[<cmd>lua require"telescope.builtin".colorscheme()<CR>]])
map("n", "<leader>fm",
    [[<cmd>lua require("telescope").extensions.metals.commands()<CR>]])

-- nvim-dap
map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>ds", [[<cmd>lua require"dap.ui.variables".scopes()<CR>]])
map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
map("n", "<leader>dtb", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

-- Nvim-tree
map("n", "<leader>tt", [[:NvimTreeToggle<CR>]])
map("n", "<leader>tr", [[:NvimTreeRefresh<CR>]])

-- Eslint
map("n", "<leader>es", [[:EslintFixAll<CR>]])

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
map("n", "<leader>cc", [[:call nerdcommenter#Comment(0,"toggle")<CR>]])
map("v", "<leader>cc", [[:call nerdcommenter#Comment(0,"toggle")<CR>]])

----------------------------------
-- COMMANDS ----------------------
----------------------------------
cmd(
    [[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])
cmd([[autocmd FileType markdown setlocal textwidth=80]])
cmd([[autocmd BufEnter *.js call matchadd('ColorColumn', '\%81v', 100)]])
cmd(
    [[autocmd BufReadPost,BufNewFile *.md,*.txt,COMMIT_EDITMSG set wrap linebreak nolist spell spelllang=en_us complete+=kspell]])
cmd(
    [[autocmd BufReadPost,BufNewFile .html,*.txt,*.md,*.adoc set spell spelllang=en_us]])
cmd([[autocmd TermOpen * startinsert]])

-- tslime.vim
cmd([[let g:tslime_ensure_trailing_newlines = 1]]) -- Always send newline
cmd([[let g:tslime_normal_mapping = '<leader>sl']])
cmd([[let g:tslime_visual_mapping = '<leader>sl']])

-- LSP (i.e. Scala)
cmd([[augroup lsp]])
cmd([[autocmd!]])
cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
cmd(
    [[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(Metals_config)]])
cmd([[augroup end]])

----------------------------------
-- Language Settings ------------------
----------------------------------

require('lspkind').init({
    mode = 'symbol_text',
    preset = 'codicons',
    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = ""
    },
})


-- Go
cmd([[augroup ft_golang]])
cmd([[au!]])
cmd([[au BufEnter,BufNewFile,BufRead *.go setlocal formatoptions+=roq]])
cmd(
    [[au BufEnter,BufNewFile,BufRead *.go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 nolist]])
cmd([[au BufEnter,BufNewFile,BufRead *.tmpl setlocal filetype=html]])
cmd([[au BufEnter,BufNewFile,BufRead *.jet setlocal filetype=html]])
cmd([[augroup END]])
cmd([[autocmd BufWritePre *.go lua Goimports(1000)]])


local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        runnables = {
            use_telescope = true
        },
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "<-",
            other_hints_prefix = "=>",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7
        },
        hover_actions = {
            border = {
                {"╭", "FloatBorder"}, {"─", "FloatBorder"},
                {"╮", "FloatBorder"}, {"│", "FloatBorder"},
                {"╯", "FloatBorder"}, {"─", "FloatBorder"},
                {"╰", "FloatBorder"}, {"│", "FloatBorder"}
            }
        }
    },
    server = {} -- rust-analyer options
}

-- require('rust-tools').setup(opts)

-- Racket
cmd([[au BufEnter,BufNewFile,BufRead *.rkt set filetype=racket]])

-- Python
cmd(
    [[au FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4]])

-- C & C++
cmd([[augroup ft_c]])
cmd([[au!]])
cmd([[au BufNewFile,BufRead *.h,*.c setlocal filetype=c]])
cmd([[au Filetype c setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4]])
cmd(
    [[au Filetype c setlocal cinoptions=l1,t0,g0 " This fixes weird indentation of switch/case]])
cmd([[augroup END]])

cmd([[augroup ft_cpp]])
cmd([[au!]])
cmd([[au BufNewFile,BufRead *.cpp setlocal filetype=cpp]])
cmd([[au Filetype cpp setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4]])
cmd(
    [[au Filetype cpp setlocal cinoptions=l1,t0,g0 " This fixes weird indentation of switch/case]])
cmd([[augroup END]])

cmd(
    [[let g:neoformat_cpp_clangformat = { 'exe': 'clang-format', 'args': ['--style="{ AccessModifierOffset: -4, IndentWidth: 4, TabWidth: 4, AllowShortIfStatementsOnASingleLine : true, AlwaysBreakTemplateDeclarations: true, BreakBeforeBraces: Stroustrup }"'] }]])
cmd([[let g:neoformat_enabled_cpp = ['clangformat'] ]])
cmd([[let g:neoformat_enabled_c = ['clangformat'] ]])

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
fn.sign_define("LspDiagnosticsSignError", {text = "▬"})
fn.sign_define("LspDiagnosticsSignWarning", {text = "▬"})
fn.sign_define("LspDiagnosticsSignInformation", {text = "▬"})
fn.sign_define("LspDiagnosticsSignHint", {text = "▬"})

cmd([[hi! link LspReferenceText CursorColumn]])
cmd([[hi! link LspReferenceRead CursorColumn]])
cmd([[hi! link LspReferenceWrite CursorColumn]])

----------------------------------
-- Color Settings ------------------
----------------------------------

cmd("colorscheme kanagawa")

cmd([[if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif]])

-- Colors galore
require("colorizer").setup()
