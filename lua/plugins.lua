return require("packer").startup(function(use)
    use 'LnL7/vim-nix'
    use 'cespare/vim-toml'
    use({'sbdchd/neoformat'})
    use({"neovim/nvim-lspconfig"})
    use 'simrat39/rust-tools.nvim'
    use({"nvim-lua/lsp_extensions.nvim"})
    use({"sjl/tslime.vim"})
    use({"christoomey/vim-tmux-navigator"})
    use({"hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-vsnip" },
        { "hrsh7th/vim-vsnip" },
      },
    })
    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install",
        cmd = "MarkdownPreview"
    })
    use({"kevinhwang91/nvim-bqf"})
    use({"kyazdani42/nvim-web-devicons"})
    use {"mfussenegger/nvim-dap"}
    use({"scalameta/nvim-metals"})
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            {"nvim-lua/popup.nvim"}, 
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-fzy-native.nvim"}
        }
    })
    use({"nvim-treesitter/nvim-treesitter"})
    use({"nvim-treesitter/playground"})
    use({"tpope/vim-fugitive"})
    use({"wbthomason/packer.nvim", opt = true})
    use({"windwp/nvim-autopairs"})
    use({"preservim/nerdcommenter"})
    use({"mg979/vim-visual-multi"})
    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      },
      config = function()
        require('gitsigns').setup()
      end
    }
    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function() require'nvim-tree'.setup {
        view = {
          side = 'right',
        }
      } end
    }

    use({"leafgarland/typescript-vim"})
    use({"peitalin/vim-jsx-typescript"})
    use({"styled-components/vim-styled-components"})
    -- use({ "jparise/vim-graphql" })
    use({"jose-elias-alvarez/nvim-lsp-ts-utils"})

    -- Clojure?!
    use "Olical/conjure"
    use "tpope/vim-surround"
    use "guns/vim-sexp"
    use "tpope/vim-sexp-mappings-for-regular-people"
    use "tpope/vim-dispatch"
    use "clojure-vim/vim-jack-in"
    use "radenling/vim-dispatch-neovim"

    -- Colors!
    use "ful1e5/onedark.nvim"
    use "marko-cerovac/material.nvim"
    use "morhetz/gruvbox"
    use "bluz71/vim-nightfly-guicolors"
    use "norcalli/nvim-colorizer.lua"
end)
