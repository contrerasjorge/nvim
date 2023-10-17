local builtin = require('telescope.builtin')
local default_opts = { noremap = true }

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>ff',
    "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
    default_opts)
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
    "n",
    "<space>fb",
    ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
    { noremap = true }
)

require("telescope").setup {}
require("telescope").load_extension "file_browser"
