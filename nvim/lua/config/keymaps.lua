-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- show completition menu on M(option key) pressend with Esc
vim.keymap.set("i", "<M-Esc>", function()
  require("blink.cmp").show()
end, { desc = "Show completion menu" })
