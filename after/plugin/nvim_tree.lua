require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        side = "right",
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")
