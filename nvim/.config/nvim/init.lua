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
