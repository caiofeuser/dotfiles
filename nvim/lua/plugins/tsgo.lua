local blocked_completion_triggers = {
  [":"] = true,
  ["-"] = true,
  ["]"] = true,
}

local tsgo_memory_limit = "8GiB"
local tsgo_memory_limit_kb = 8 * 1024 * 1024
local tsgo_memory_check_interval_ms = 30 * 1000

local tsgo_memory_timer
local tsgo_memory_restart_pending = false

local function strip_tsgo_completion_triggers(client)
  local completion = client.server_capabilities.completionProvider
  if not completion or not completion.triggerCharacters then
    return
  end

  completion.triggerCharacters = vim.tbl_filter(function(trigger)
    return not blocked_completion_triggers[trigger]
  end, completion.triggerCharacters)
end

local function stop_tsgo_memory_watch()
  if not tsgo_memory_timer then
    return
  end

  tsgo_memory_timer:stop()
  tsgo_memory_timer:close()
  tsgo_memory_timer = nil
end

local function restart_tsgo_client(client, reload_buffer)
  client:stop(true)

  if reload_buffer then
    vim.defer_fn(function()
      vim.cmd("edit")
    end, 100)
  end
end

local function get_tsgo_cmd(config)
  local cmd = "tsgo"
  if (config or {}).root_dir then
    local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
    if vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
  end

  return { cmd, "--lsp", "--stdio" }
end

local function tsgo_cmd(dispatchers, config)
  local env = vim.tbl_extend("force", vim.fn.environ(), (config or {}).cmd_env or {}, {
    GOMEMLIMIT = tsgo_memory_limit,
  })

  return vim.lsp.rpc.start(get_tsgo_cmd(config), dispatchers, { env = env })
end

local function is_tsgo_lsp_process(command)
  return command:find("tsgo", 1, true) and command:find("--lsp", 1, true) and command:find("--stdio", 1, true)
end

local function restart_tsgo_for_memory(pid, rss_kb)
  if tsgo_memory_restart_pending then
    return
  end

  tsgo_memory_restart_pending = true
  vim.schedule(function()
    local clients = vim.lsp.get_clients({ name = "tsgo" })
    if #clients == 0 then
      stop_tsgo_memory_watch()
      tsgo_memory_restart_pending = false
      return
    end

    for _, client in ipairs(clients) do
      restart_tsgo_client(client, false)
    end

    vim.defer_fn(function()
      vim.cmd("edit")
      tsgo_memory_restart_pending = false
    end, 100)

    vim.notify(("Restarting tsgo: process %s reached %.1f GiB"):format(pid, rss_kb / 1024 / 1024), vim.log.levels.WARN)
  end)
end

local function check_tsgo_memory()
  if #vim.lsp.get_clients({ name = "tsgo" }) == 0 then
    stop_tsgo_memory_watch()
    return
  end

  vim.system({ "ps", "axo", "pid=,rss=,command=" }, { text = true }, function(result)
    for line in
      vim.gsplit(result.stdout or "", "\n", {
        plain = true,
        trimempty = true,
      })
    do
      local pid, rss_kb, command = line:match("^%s*(%d+)%s+(%d+)%s+(.+)$")
      rss_kb = tonumber(rss_kb)
      if pid and rss_kb and rss_kb > tsgo_memory_limit_kb and is_tsgo_lsp_process(command) then
        restart_tsgo_for_memory(pid, rss_kb)
        return
      end
    end
  end)
end

local function start_tsgo_memory_watch()
  if tsgo_memory_timer then
    return
  end

  tsgo_memory_timer = vim.uv.new_timer()
  tsgo_memory_timer:start(tsgo_memory_check_interval_ms, tsgo_memory_check_interval_ms, check_tsgo_memory)
end

local function restart_tsgo()
  local stopped = false

  for _, client in ipairs(vim.lsp.get_clients({ name = "tsgo" })) do
    stopped = true
    restart_tsgo_client(client, false)
  end

  if stopped then
    vim.defer_fn(function()
      vim.cmd("edit")
    end, 100)
  else
    vim.cmd("edit")
  end
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
          cmd = tsgo_cmd,
          cmd_env = {
            GOMEMLIMIT = tsgo_memory_limit,
          },
          flags = {
            debounce_text_changes = 400,
          },
          on_init = function(client)
            strip_tsgo_completion_triggers(client)
            start_tsgo_memory_watch()
          end,
        },
      },
    },
  },
}
