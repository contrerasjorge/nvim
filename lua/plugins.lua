return require("packer").startup(function(use)
	use({ "neovim/nvim-lspconfig" })
	use({ "glepnir/lspsaga.nvim" })
	use({ "ckipp01/stylua-nvim" })
	use({ "sjl/tslime.vim" })
	use({ "christoomey/vim-tmux-navigator" })
	use({ "hrsh7th/nvim-compe", requires = { { "hrsh7th/vim-vsnip" } } })
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		cmd = "MarkdownPreview",
	})
	use({ "kevinhwang91/nvim-bqf" })
	use({ "kyazdani42/nvim-web-devicons" })
	use({ "mfussenegger/nvim-dap" })
	use({ "scalameta/nvim-metals" })
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzy-native.nvim" },
		},
	})
	use({ "nvim-treesitter/nvim-treesitter" })
	use({ "nvim-treesitter/playground" })
	use({ "tpope/vim-fugitive" })
	use({ "wbthomason/packer.nvim", opt = true })
	use({ "windwp/nvim-autopairs" })
	use({ "wlangstroth/vim-racket" })
	-- use({ "Yggdroot/indentLine" })
	use({ "preservim/nerdcommenter" })
	-- use({ "ap/vim-css-color" })
	use({ "mg979/vim-visual-multi" })
    use({
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('gitsigns').setup()
        end
    })
	use({ "kyazdani42/nvim-tree.lua" })
	use({ "rhysd/vim-clang-format" })

	use({ "leafgarland/typescript-vim" })
	use({ "peitalin/vim-jsx-typescript" })
	use({ "styled-components/vim-styled-components" })
	--use({ "jparise/vim-graphql" })
	use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })

  -- Colors!
	use({ "joshdick/onedark.vim" })
	use({ "ayu-theme/ayu-vim" })
	use({ "gruvbox-community/gruvbox" })
	use({ "norcalli/nvim-colorizer.lua" })
end)
