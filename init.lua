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
require("settings.compe").setup()
require("settings.telescope").setup()
require("settings.lsp").setup()

require("nvim-autopairs").setup()


local saga = require 'lspsaga'
saga.init_lsp_saga({
  code_action_icon = '💡',
  server_filetype_map = { metals = { "sbt", "scala" } },
  code_action_prompt = { virtual_text = false },
})


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
global_opt.wildignore = { ".git", "*/node_modules/*", "*/target/*", ".metals", ".bloop", ".ammonite" }
global_opt.ignorecase = true
global_opt.smartcase = true
global_opt.clipboard = "unnamed"
global_opt.completeopt = { "menu", "menuone", "noselect" }

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
-- VARIABLES ---------------------
----------------------------------
g["mapleader"] = " "
g["netrw_gx"] = "<cWORD>"

-- Numbers!!!
map("n", "<leader>n/", [[<cmd>lua RELOAD("settings.functions").toggle_nums()<CR>]])
map("n", "<leader>n", [[:set relativenumber! nu!<CR>]])

-- Neoformat
map("n", "<leader>nf", [[:Neoformat<CR>]])

-- LSP
map('n', 'gD', [[<Cmd>lua vim.lsp.buf.declaration()<CR>]])
map('n', 'gd', [[<Cmd>lua vim.lsp.buf.definition()<CR>]])
map('n', 'gi', [[<cmd>lua vim.lsp.buf.implementation()<CR>]])
map('n', '<C-k>', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map('n', '<space>wa', [[<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>]])
map('n', '<space>wr', [[<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>]])
map('n', '<space>wl', [[<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>]])
map('n', '<space>D', [[<cmd>lua vim.lsp.buf.type_definition()<CR>]])
map('n', 'gr', [[<cmd>lua vim.lsp.buf.references()<CR>]])
map('n', '<space>e', [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]])
map("n", "<leader>d", [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]]) -- buffer diagnostics only
map('n', '[d', [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]])
map('n', ']d', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]])
map('n', '<space>q', [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]])
map("n", "gds", [[<cmd>lua require"telescope.builtin".lsp_document_symbols()<CR>]])
map("n", "gws", [[<cmd>lua require"settings.telescope".lsp_workspace_symbols()<CR>]])
map("n", "<leader>ws", [[<cmd>lua require"metals".worksheet_hover()<CR>]])
map("n", "<leader>a", [[<cmd>lua require"metals".open_all_diagnostics()<CR>]])
map("n", "<leader>ln", [[<cmd>lua vim.lsp.diagnostic.get_line_diagnostics()<CR>]])
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")

map("n", "K", [[<cmd>lua require"lspsaga.hover".render_hover_doc()<CR>]])
map("n", "<leader>rn", [[<cmd>lua require"lspsaga.rename".rename()<CR>]])
map("n", "<leader>ca", [[<cmd>lua require"lspsaga.codeaction".code_action()<CR>]])
map("v", "<leader>ca", [[<cmd>lua require"lspsaga.codeaction".range_code_action()<CR>]])
-- map("n", "]c", [[<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()<CR>]])
-- map("n", "[c", [[<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()<CR>]])

-- completion
map("i", "<S-Tab>", [[pumvisible() ? "<C-p>" : "<Tab>"]], { expr = true })
map("i", "<Tab>", [[pumvisible() ? "<C-n>" : "<Tab>"]], { expr = true })
map("i", "<CR>", [[compe#confirm("<CR>")]], { expr = true })

map("i", "<C-space>", [[compe#complete()]], { silent = true, expr = true })
map("i", "<C-e>", [[compe#close("<C-e>")]], { silent = true, expr = true })
map("i", "<C-f>", [[compe#scroll({ "delta": +4 })]], { silent = true, expr = true })
map("i", "<C-d>", [[compe#scroll({ "delta": -4 })]], { silent = true, expr = true })


-- REST
map("n", "<leader>re", [[<Plug>RestNvim]])
map("n", "<leader>rp", [[<Plug>RestNvimPreview]])


-- telescope
map("n", "<leader>ff", [[<cmd>lua require"telescope.builtin".find_files()<CR>]])
map("n", "<leader>fg", [[<cmd>lua require"telescope.builtin".live_grep()<CR>]])
map("n", "<leader>fb", [[<cmd>lua require"telescope.builtin".buffers()<CR>]])
map("n", "<leader>fh", [[<cmd>lua require"telescope.builtin".help_tags()<CR>]])
map("n", "<leader>fl", [[<cmd>lua require"telescope.builtin".git_files()<CR>]])
map("n", "<leader>fs", [[<cmd>lua require"telescope.builtin".file_browser()<CR>]])
map("n", "<leader>fd", [[<cmd>lua require"telescope.builtin".lsp_workspace_diagnostics()<CR>]])
map("n", "<leader>fp", [[<cmd>lua require"telescope.builtin".oldfiles()<CR>]])
map("n", "<leader>fn", [[<cmd>lua require"settings.telescope".search_nvim()<CR>]])
-- 一番の大事な設定
map("n", "<leader>fc", [[<cmd>lua require"telescope.builtin".colorscheme()<CR>]])
map("n", "<leader>fm", [[<cmd>lua require("telescope").extensions.metals.commands()<CR>]])


-- nvim-dap
map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>ds", [[<cmd>lua require"dap.ui.variables".scopes()<CR>]])
map("n", "<leader>dtb", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])

-- Nvim-tree
map("n", "<leader>tt", [[:NvimTreeToggle<CR>]])
map("n", "<leader>tr", [[:NvimTreeRefresh<CR>]])
cmd([[let g:nvim_tree_side = 'right']])
cmd([[let g:nvim_tree_add_trailing = 1]])
cmd([[let g:nvim_tree_quit_on_open = 1]])

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

-- LSP (i.e. Scala)
cmd([[augroup lsp]])
cmd([[autocmd!]])
cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(Metals_config)]])
cmd([[augroup end]])


----------------------------------
-- Language Settings ------------------
----------------------------------

-- Go
cmd([[augroup ft_golang]])
cmd([[au!]])
cmd([[au BufEnter,BufNewFile,BufRead *.go setlocal formatoptions+=roq]])
cmd([[au BufEnter,BufNewFile,BufRead *.go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 nolist]])
cmd([[au BufEnter,BufNewFile,BufRead *.tmpl setlocal filetype=html]])
cmd([[au BufEnter,BufNewFile,BufRead *.jet setlocal filetype=html]])
cmd([[augroup END]])
cmd([[autocmd BufWritePre *.go lua Goimports(1000)]])

-- Rust
-- cmd([[augroup ft_rust]])
-- cmd([[au!]])
-- cmd([[au BufEnter,BufNewFile,BufRead *.rs :compiler cargo]])
-- cmd([[au FileType rust set nolist]])
-- cmd([[augroup END]])

local opts = {
    tools = { -- rust-tools options
        -- automatically set inlay hints (type hints)
        -- There is an issue due to which the hints are not applied on the first
        -- opened file. For now, write to the file to trigger a reapplication of
        -- the hints or just run :RustSetInlayHints.
        -- default: true
        autoSetHints = true,

        -- whether to show hover actions inside the hover window
        -- this overrides the default hover handler
        -- default: true
        hover_with_actions = true,

        runnables = {
            -- whether to use telescope for selection menu or not
            -- default: true
            use_telescope = true

            -- rest of the opts are forwarded to telescope
        },

        inlay_hints = {
            -- wheter to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<-",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix  = "=>",

            -- whether to align to the lenght of the longest line in the file
            max_len_align = false,

            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            right_align = false,

            -- padding from the right if right_align is true
            right_align_padding = 7,
        },

        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
              {"╭", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╮", "FloatBorder"},
              {"│", "FloatBorder"},
              {"╯", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╰", "FloatBorder"},
              {"│", "FloatBorder"}
            },
        }
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {}, -- rust-analyer options
}

require('rust-tools').setup(opts)


-- Racket
cmd([[au BufEnter,BufNewFile,BufRead *.rkt set filetype=racket]])

-- Python
cmd([[au FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4]])

-- C & C++
cmd([[augroup ft_c]])
cmd([[au!]])
cmd([[au BufNewFile,BufRead *.h,*.c setlocal filetype=c]])
cmd([[au Filetype c setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4]])
cmd([[au Filetype c setlocal cinoptions=l1,t0,g0 " This fixes weird indentation of switch/case]])
cmd([[augroup END]])

cmd([[augroup ft_cpp]])
cmd([[au!]])
cmd([[au BufNewFile,BufRead *.cpp setlocal filetype=cpp]])
cmd([[au Filetype cpp setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4]])
cmd([[au Filetype cpp setlocal cinoptions=l1,t0,g0 " This fixes weird indentation of switch/case]])
cmd([[augroup END]])

-- cmd([[let g:clang_format#style_options = { "AccessModifierOffset" : -4, "IndentWidth": 4, "TabWidth": 4, "AllowShortIfStatementsOnASingleLine" : "true", "AlwaysBreakTemplateDeclarations" : "true", "BreakBeforeBraces" : "Stroustrup" }]])
-- let g:clang_format#auto_format = 1
-- map to <Leader>cf in C++ code
-- cmd([[autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>]])
-- cmd([[autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>]])

cmd([[let g:neoformat_cpp_clangformat = { 'exe': 'clang-format', 'args': ['--style="{ AccessModifierOffset: -4, IndentWidth: 4, TabWidth: 4, AllowShortIfStatementsOnASingleLine : true, AlwaysBreakTemplateDeclarations: true, BreakBeforeBraces: Stroustrup }"'] }]])
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
fn.sign_define("LspDiagnosticsSignError", { text = "▬" })
fn.sign_define("LspDiagnosticsSignWarning", { text = "▬" })
fn.sign_define("LspDiagnosticsSignInformation", { text = "▬" })
fn.sign_define("LspDiagnosticsSignHint", { text = "▬" })

cmd([[hi! link LspReferenceText CursorColumn]])
cmd([[hi! link LspReferenceRead CursorColumn]])
cmd([[hi! link LspReferenceWrite CursorColumn]])

cmd([[hi! link LspSagaFinderSelection CursorColumn]])
cmd([[hi! link LspSagaDocTruncateLine LspSagaHoverBorder]])

----------------------------------
-- Color Settings ------------------
----------------------------------

-- Colors!
require("onedark").setup({
  commentStyle = "italic",
})

-- cmd("colorscheme nightfly")
cmd([[let g:gruvbox_contrast_dark = 'hard']])
cmd([[if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif]])
cmd([[let ayucolor="mirage"]])

-- Colors galore
require("colorizer").setup()
