local utils = require("utils")
-- Change leader to a comma
vim.g.mapleader = ","

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Disable arrow keys
utils.keymap("", "<up>", "<nop>")
utils.keymap("", "<down>", "<nop>")
utils.keymap("", "<left>", "<nop>")
utils.keymap("", "<right>", "<nop>")

-- Clear search highlighting with <leader> and c
utils.keymap("n", "<leader>c", ":nohl<CR>")

-- Move around splits using Alt + {h,j,k,l}
utils.keymap("n", "<A-h>", "<C-w>h")
utils.keymap("n", "<A-j>", "<C-w>j")
utils.keymap("n", "<A-k>", "<C-w>k")
utils.keymap("n", "<A-l>", "<C-w>l")

-- Reload configuration without restart nvim
utils.keymap("n", "<leader>r", ":so %<CR>")

-- Fast saving with <leader> and s
utils.keymap("n", "<leader>s", ":w<CR>")

-- Close all windows and exit from Neovim with <leader> and q
utils.keymap("n", "<leader>q", ":qa!<CR>")

-- Map key to move between buffer quickly
utils.keymap("n", "<leader>n", ":bnext<CR>")
utils.keymap("n", "<leader>p", ":bprevious<CR>")
utils.keymap("n", "<leader>d", ":bdelete<CR>")

utils.keymap("n", "<space>f", ":Format<CR>")
