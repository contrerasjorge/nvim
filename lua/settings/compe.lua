local M = {}

M.setup = function()
	require("compe").setup({
		enabled = true,
		debug = false,
		min_length = 1,
		autocomplete = true,
		preselect = "enable",
		throttle_time = 80,
		source_timeout = 200,
		incomplete_delay = 400,
		alow_prefix_unmatch = false,

		source = {
			calc = true,
			vsnip = true,
			nvim_lsp = true,
			nvim_lua = true,
			spell = true,
			tags = true,
			snippets_nvim = true,
		},
	})
end

return M
