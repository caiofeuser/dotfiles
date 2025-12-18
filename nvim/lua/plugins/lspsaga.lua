return {
  -- 1. DISABLE LAZYVIM DEFAULTS (Keep this, it ensures keys work)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover" },
            { "gd", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition" },
            { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Code Action" },
            { "<leader>rn", "<cmd>Lspsaga rename<CR>", desc = "Rename" },
          },
        },
      },
    },
  },

  -- 2. THE "PRETTY" CONFIG
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup({
        -- UI: THE CURSOR LOOK
        ui = {
          border = "rounded",
          title = true,
          code_action = "💡",
        },

        -- HOVER WINDOW SETTINGS
        hover = {
          max_width = 0.8, -- Wider window (prevents cramping)
          open_link = "gx",
          open_browser = "!chrome",
        },

        -- CLEANUP JUNK
        lightbulb = { enable = false, virtual_text = false },
        beacon = { enable = false },
      })
    end,
  },
}
