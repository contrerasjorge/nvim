local util = require "formatter.util"

require("formatter").setup {
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = {
        -- Formatter configurations for filetype "lua" go here
        -- and will be executed in order
        python = {
            -- "formatter.filetypes.lua" defines default configurations for the
            -- "lua" filetype
            require("formatter.filetypes.python").black,
            require("formatter.filetypes.python").isort,
        },
        javascript = {
            require("formatter.filetypes.javascript").prettier
        },
        typescript = {
            require("formatter.filetypes.typescript").prettier
        }
    }
}

vim.keymap.set("n", "<leader>f", "<cmd>:Format<CR>")
vim.keymap.set("n", "<leader>F", "<cmd>:FormatWrite<CR>")

vim.cmd [[
  autocmd BufWritePost * FormatWrite
]]
