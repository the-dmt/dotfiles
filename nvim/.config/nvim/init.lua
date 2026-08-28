-- require("vim._core.ui2").enable({})

-- Time saving variable shortcuts
local g = vim.g
local o = vim.opt
local map = vim.keymap.set
local cmd = vim.cmd
local api = vim.api

o.compatible = false

o.number = true
o.relativenumber = true

o.ignorecase = true
o.smartcase = true

o.wrap = false

o.termguicolors = true
o.background = "dark"
o.syntax = "on"
o.hlsearch = false

o.hidden = true
o.splitright = true
o.splitbelow = true

o.errorbells = false
o.visualbell = false

o.laststatus = 0

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.autoindent = true
o.smartindent = true

o.mouse = "a"

o.swapfile = false
o.undofile = true
o.backup = false
o.writebackup = false

o.showtabline = 1

o.iskeyword:append("_")

o.winborder = "rounded"

g.mapleader = " "
g.maplocalleader = " "


-- Yank on highlight
api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight while yanking",
    callback = function() 
        vim.hl.on_yank()
    end,
})

-- Esc. key remap
map("i", "<C-c>", "<Esc>")

-- Move around windows
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Quick write
map("n", "<leader>w", ":w<CR>")
-- Quick source
map("n", "<leader>so", ":so<CR>")
-- Quick restart
map("n", "<leader>re", ":restart<CR>")

-- Center focus while scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "gg", "gg0")
map("n", "G", "G0")

-- Buffer navigation
map("n", "<TAB>", ":bnext<CR>")
map("n", "<S-TAB>", ":bprevious<CR>")
-- k("n", "<S-TAB>", ":bdelete<CR>")

-- ToggleTerm
map("n", "<leader>'", ":ToggleTerm direction=float<CR>")

vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/rebelot/kanagawa.nvim"
})

cmd.colorscheme("kanagawa")

