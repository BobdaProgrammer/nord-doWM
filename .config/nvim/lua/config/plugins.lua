-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable", -- latest stable release
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  {

     'edluffy/hologram.nvim',
    "nvim-tree/nvim-web-devicons",
     'neovim/nvim-lspconfig',          -- LSP configurations
    'hrsh7th/nvim-cmp',              -- Autocompletion plugin
    'hrsh7th/cmp-nvim-lsp',          -- LSP source for nvim-cmp
    'hrsh7th/cmp-buffer',            -- Buffer completions
    'hrsh7th/cmp-path',              -- Path completions
    'hrsh7th/cmp-cmdline',           -- Command line completions
    'L3MON4D3/LuaSnip',	-- Snippets plugin "nvim-tree/nvim-web-devicons",
  },{ 'wakatime/vim-wakatime', lazy = false },
{
  dir = "~/code/quickbuffer.nvim/",
  dev = true,
  config = function()
    require("quickbuffer").setup({
      target_file = "~/code/buffers/floating.md",
      border = "single", -- single, rounded, etc
      width = 0.8, -- width of window in % of screen size
      height = 0.8, -- height of window in % of screen size
      bufferposition = "center", -- top-left, top-right, bottom-left, bottom-right, right-center
      pickerposition = "center-right", 
      project_folders = {
        {
            path = "~/code/doWM",
            target_file = "~/code/buffers/doWM/notes.md"
        },
        {
            path = "~/code/quickbuffer.nvim",
            target_file = "~/code/buffers/quickbuffer/notes.md"
        },
        {
            path = "~/code/workspace-viewer",
            target_file = "~/code/buffers/workspace-viewer/notes.md"
        },
        {
            path = "~/rices",
            target_file = "~/code/buffers/rices/notes.md"
        }
      },
      keybinds = {
            gotobuffer = "b",
            gotopicker = "p",
            closepicker = "<Esc>",
            closebuffer = "<Esc>"
      }
    })
  end
},
{
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
},
{
  "akinsho/flutter-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = true,
},
{
  "wsdjeg/picker.nvim",
  event = "VeryLazy",
  config = function()
      require('picker').setup({
        filter = {
          ignorecase = false, -- ignorecase (boolean): defaults to false
          matcher = 'fzy', -- fzy or matchfuzzy
        },
        window = {
          width = 0.8, -- set picker screen width, default is 0.8 * vim.o.columns
          height = 0.8,
          col = 0.1,
          row = 0.1,
          current_icon = '>',
          current_icon_hl = 'CursorLine',
          enable_preview = false,
          preview_timeout = 500,
          show_score = false, -- display/hide match score at the end of each item.
        },
        highlight = {
          matched = 'Tag',
          score = 'Comment',
        },
        prompt = {
          position = 'bottom', -- set prompt position, bottom or top
          icon = '>',
          icon_hl = 'Error',
          insert_timeout = 100,
          title = true, -- display/hide source name
        },
        mappings = {
          close = '<Esc>',
          next_item = '<Tab>',
          previous_item = '<S-Tab>',
          open_item = '<Enter>',
          toggle_preview = '<C-p>',
        },
      })
  end,
},
{
  "startup-nvim/startup.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
  config = function()
    require "startup".setup()
  end
},
{  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp", -- optional, but recommended
  },
  config = function()
    require("codeium").setup({
      -- enables ghost text like Copilot
      enable_chat = false,
    })
  end
},
{
  "mattn/emmet-vim",
  ft = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  init = function()
    vim.g.user_emmet_leader_key = '<C-y>'
  end,
},
{
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    branch = "main",
    main = "nvim-treesitter",
    init = function()
        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                -- Enable treesitter highlighting and disable regex syntax
                pcall(vim.treesitter.start)
                -- Enable treesitter-based indentation
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })

        local ensureInstalled = { "lua", "rasi", "go" } -- Add 'rasi' to this list
        local alreadyInstalled = require('nvim-treesitter.config').get_installed()
        local parsersToInstall = vim.iter(ensureInstalled)
        :filter(function(parser)
            return not vim.tbl_contains(alreadyInstalled, parser)
        end)
        :totable()
        require('nvim-treesitter').install(parsersToInstall)
    end,
},
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Removed gopls setup here
    end,
  },
  {
	  "RRethy/vim-hexokinase",
	  build = "make hexokinase", -- compiles the binary
	  config = function()
		  vim.g.Hexokinase_highlighters = { "foreground", "virtual" }
	  end,
  },
  --{
  --  "catppuccin/nvim",
  --  name = "catppuccin",
  --  config = function()
  --    require("catppuccin").setup({
  --      flavour = "mocha", -- Set to your preferred flavour
  --    })
  --    vim.cmd.colorscheme("catppuccin")
  --  end,
  --},
  {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
    "neovim/nvim-lspconfig", -- optional
  },
    enabled=false,
  opts = {} -- your configuration
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup {}
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup {
        options = {
          theme = "nord",
          section_separators = { "", "" },
          component_separators = { "", "" },
        },
      }
    end,
  },
  {
    'romgrk/barbar.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer",      -- Buffer completions
      "hrsh7th/cmp-path",        -- Path completions
      "hrsh7th/cmp-cmdline",     -- Command-line completions
      "L3MON4D3/LuaSnip",        -- Snippet engine
      "saadparwaiz1/cmp_luasnip" -- Snippet completions
    }
  },
{
  "gbprod/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("nord")

    -- override completion menu highlight
    vim.api.nvim_set_hl(0, "PmenuSel", {
      bg = "#000000",
      fg = "#ffffff",
    })
  end,
},
  install = {
    colorscheme = { "nord" },
  },
})
require('hologram').setup{
    auto_display = true -- WIP automatic markdown image display, may be prone to breaking
}


