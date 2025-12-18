-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Go to previous buffer with <
vim.keymap.set("n", "<", ":bprevious<CR>", { noremap = true, silent = true })

-- Go to next buffer with >
vim.keymap.set("n", ">", ":bnext<CR>", { noremap = true, silent = true })
-- Don't overwrite register on delete
vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set("n", "d", '"_d')
vim.keymap.set("n", "x", '"_x')
