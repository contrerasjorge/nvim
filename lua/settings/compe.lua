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

			--source = {
			--path = true,
			--buffer = true,
			--vsnip = {
			--filetypes = { "scala", "html", "javascript", "lua", "java", "go" },
			--},
			--nvim_lsp = {
			--priority = 1000,
			--filetypes = { "scala", "html", "javascript", "lua", "java", "go" },
			--},
			--},
	})
end

return M
