local blocked_completion_triggers = {
  [":"] = true,
  ["]"] = true,
}

local function strip_tsgo_completion_triggers(client)
  local completion = client.server_capabilities.completionProvider
  if not completion or not completion.triggerCharacters then
    return
  end

  completion.triggerCharacters = vim.tbl_filter(function(trigger)
    return not blocked_completion_triggers[trigger]
  end, completion.triggerCharacters)
end

local function restart_tsgo()
  local stopped = false

  for _, client in ipairs(vim.lsp.get_clients({ name = "tsgo" })) do
    stopped = true
    client:stop(true)
  end

  vim.defer_fn(function()
    vim.cmd("edit")
  end, stopped and 100 or 0)
end

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_user_command("TsgoRestart", restart_tsgo, {
        desc = "Restart the tsgo language server",
      })
    end,
    opts = {
      servers = {
        -- Keep exactly one TypeScript language server active.
        tsserver = { enabled = false },
        ts_ls = { enabled = false },
        vtsls = { enabled = false },

        biome = {
          flags = {
            debounce_text_changes = 400,
          },
        },

        tsgo = {
          flags = {
            debounce_text_changes = 400,
          },
          on_init = function(client)
            strip_tsgo_completion_triggers(client)
          end,
        },
      },
    },
  },
}
