-- require('colorbuddy').colorscheme('gruvbuddy')
-- vim.cmd.colorscheme "catppuccin"
require('colorizer').setup()
require("catppuccin").setup({
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"


-- function ColorMyPencils(color)
-- 	color = color or "rose-pine"
-- 	vim.cmd.colorscheme(color)
--
-- 	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- 	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- 	vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
-- end
--
-- ColorMyPencils()
