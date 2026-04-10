-- ~/.config/nvim/lua/config/vscode.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- # Mini surround
-- gsaiw"   " quote word
-- gsaiw(   " parenthesize word
-- v...gsa( " surround selection
-- gsd(     " delete parentheses
-- gsr({    " change () to {}

require("lazy").setup({
  spec = {
    {
      "nvim-mini/mini.surround",
      opts = {
        mappings = {
          add = "gsa", --select with v-mode and the gsa[ ot { ...
          delete = "gsd", -- same thing but removes it
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr", -- put cursor inside gsr[curr,new] --eg. gsr({ will remove ( and put {
          update_n_lines = "gsn",
        },
      },
    },
    { "wellle/targets.vim", lazy = false }, -- make short cuts like ciq -> change inner word
    { "kana/vim-textobj-user", lazy = false },
    {
      "folke/flash.nvim",
      lazy = false,
      keys = {
        {
          "s",
          mode = { "n", "x", "o" },
          function()
            require("flash").jump()
          end,
          desc = "Flash",
        },
      },
    },
    {
      "vscode-neovim/vscode-multi-cursor.nvim", -- ctrl v, motion, mi, or mce for selection
      lazy = false,
      opts = {},
    },
  },
})

local ok, mc = pcall(require, "vscode-multi-cursor")
if ok then
  vim.keymap.set({ "n", "x", "i" }, "<D-d>", function()
    mc.addSelectionToNextFindMatch()
  end, { silent = true, noremap = true })
end
