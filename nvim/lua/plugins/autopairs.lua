return {
  "windwp/nvim-autopairs",
  -- event = "InsertEnter",
  opts = {
    fast_wrap = {},
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)

    -- Wrap selection automatically when pressing a pair character
    local map = vim.keymap.set

    -- pairs
    map("v", "(", 'c(<C-r>")<Esc>', { noremap = true, silent = true })
    map("v", "{", 'c{<C-r>"}<Esc>', { noremap = true, silent = true })
    map("v", "[", 'c[<C-r>"]<Esc>', { noremap = true, silent = true })

    -- quotes
    map("v", '"', 'c"<C-r>""<Esc>', { noremap = true, silent = true })
    map("v", "'", "c'<C-r>\"'<Esc>", { noremap = true, silent = true })
  end,
}
