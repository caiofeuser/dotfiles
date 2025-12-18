-- return {
--   { "Mofiqul/dracula.nvim" },
--
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       transparent = "true",
--       colorscheme = "dracula",
--       styles = {
--         sidebars = "transparent",
--         floats = "transparent",
--       },
--       overrides = {
--         NormalFloat = { bg = "#1e1f29" },
--         FloatBorder = { fg = "#bd93f9", bg = "#1e1f29" },
--       },
--     },
--   },
-- }
--
return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
-- return {
--   {
--     "Mofiqul/dracula.nvim",
--     priority = 1000,
--     opts = {
--       transparent_bg = true,
--       -- This override block forces the sidebar and floating windows to be transparent
--       overrides = function(colors)
--         return {
--           -- 1. Force transparency for Floating Windows (Telescope/Mason/Lazy)
--           NormalFloat = { bg = "NONE" },
--           FloatBorder = { bg = "NONE" },
--
--           -- 2. Force transparency for Telescope (if you use it)
--           TelescopeNormal = { bg = "NONE" },
--           TelescopeBorder = { bg = "NONE" },
--           TelescopePromptNormal = { bg = "NONE" },
--           TelescopePromptBorder = { bg = "NONE" },
--           TelescopeResultsNormal = { bg = "NONE" },
--           TelescopeResultsBorder = { bg = "NONE" },
--           TelescopePreviewNormal = { bg = "NONE" },
--           TelescopePreviewBorder = { bg = "NONE" },
--
--           -- 3. Force transparency for Neo-tree (File explorer)
--           NeoTreeNormal = { bg = "NONE" },
--           NeoTreeNormalNC = { bg = "NONE" },
--           NeoTreeWinSeparator = { bg = "NONE", fg = colors.comment },
--         }
--       end,
--     },
--   },
--
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "dracula",
--     },
--   },
-- }
