return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- tsgo panics on ']' as a completion trigger character (bug in dev versions).
        -- Strip it from server capabilities before nvim-cmp can send those requests.
        biome = {
          flags = {
            debounce_text_changes = 400,
          },
        },
        tsgo = {
          flags = {
            debounce_text_changes = 400,
          },
          -- tsgo dev builds panic on ']' as a completion trigger character.
          -- Strip it in on_init (fires before LspAttach, so before nvim-cmp
          -- caches trigger chars).
          on_init = function(client)
            local cp = client.server_capabilities.completionProvider
            if cp and cp.triggerCharacters then
              cp.triggerCharacters = vim.tbl_filter(function(c)
                return c ~= "]"
              end, cp.triggerCharacters)
            end
          end,
        },
      },
    },
  },
}
