-- ~/.config/nvim/init.lua
-- Basic Neovim config with sane defaults (no plugins required)

-- Leader keys (set before any mappings)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- UI
opt.number = true            -- line numbers
opt.relativenumber = true    -- relative line numbers
opt.cursorline = true        -- highlight current line
opt.signcolumn = "yes"       -- always show sign column (no layout shift)
opt.termguicolors = true     -- true color support
opt.scrolloff = 8            -- keep context around cursor
opt.sidescrolloff = 8
opt.wrap = false             -- no line wrapping
opt.showmode = false         -- mode is redundant with most statuslines
opt.cmdheight = 1
opt.laststatus = 3           -- single global statusline
opt.colorcolumn = "100"      -- soft line length guide

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Indentation
opt.expandtab = true         -- spaces instead of tabs
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true        -- case-insensitive search...
opt.smartcase = true         -- ...unless uppercase is used
opt.hlsearch = true
opt.incsearch = true

-- Editing behavior
opt.clipboard = "unnamedplus"  -- use system clipboard
opt.mouse = "a"                -- enable mouse
opt.undofile = true            -- persistent undo
opt.swapfile = false
opt.backup = false
opt.updatetime = 250           -- faster CursorHold / swap writes
opt.timeoutlen = 400           -- faster mapped-sequence timeout
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true             -- ask instead of failing on unsaved changes

-- Whitespace visualization
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Keymaps
local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save / quit
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Keep selection when indenting in visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered on scroll / search jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste over selection without clobbering the register
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Better j/k on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Restore cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Per-filetype indentation overrides
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "python", "rust", "go" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Plugins (lazy.nvim)
-- Bootstrap the plugin manager on first launch
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Gruvbox colorscheme (loaded first so the theme applies at startup)
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "soft", -- "hard", "soft", or "" for the default
        transparent_mode = false,
        italic = {
          strings = false,
          comments = true,
        },
      })
      vim.o.background = "dark" -- use "light" for the light variant
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- Treesitter: better syntax highlighting, indentation, and text objects
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "css", "html", "javascript", "json", "lua", "markdown",
          "markdown_inline", "python", "query", "regex", "tsx", "typescript",
          "vim", "vimdoc", "yaml",
        },
        auto_install = true, -- install parsers for new filetypes on demand
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            node_decremental = "<BS>",
          },
        },
      })
    end,
  },

  -- Telescope: fuzzy finder for files, text, buffers, and more
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Native sorter for speed (needs `make`; skipped if unavailable)
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep in project" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in buffer" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
          file_ignore_patterns = { "^.git/", "node_modules/" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = { hidden = true }, -- show dotfiles
        },
      })

      pcall(telescope.load_extension, "fzf")
    end,
  },
}, {
  change_detection = { notify = false },
})
