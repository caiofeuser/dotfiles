-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
--- Wrapping actions (Neovim receives <Plug> key)
--- - To integrate with vscode
vim.api.nvim_create_user_command("WrapParen", function()
  -- reselect last visual range
  vim.cmd('normal! gv"zy')
  local txt = vim.fn.getreg("z")
  vim.cmd("normal! gvd")
  vim.api.nvim_put({ "(" .. txt .. ")" }, "c", true, true)
end, {})

vim.api.nvim_create_user_command("WrapBrace", function()
  vim.cmd('normal! gv"zy')
  local txt = vim.fn.getreg("z")
  vim.cmd("normal! gvd")
  vim.api.nvim_put({ "{" .. txt .. "}" }, "c", true, true)
end, {})

vim.api.nvim_create_user_command("WrapBracket", function()
  vim.cmd('normal! gv"zy')
  local txt = vim.fn.getreg("z")
  vim.cmd("normal! gvd")
  vim.api.nvim_put({ "[" .. txt .. "]" }, "c", true, true)
end, {})

vim.api.nvim_create_user_command("WrapDouble", function()
  vim.cmd('normal! gv"zy')
  local txt = vim.fn.getreg("z")
  vim.cmd("normal! gvd")
  vim.api.nvim_put({ '"' .. txt .. '"' }, "c", true, true)
end, {})

vim.api.nvim_create_user_command("WrapSingle", function()
  vim.cmd('normal! gv"zy')
  local txt = vim.fn.getreg("z")
  vim.cmd("normal! gvd")
  vim.api.nvim_put({ "'" .. txt .. "'" }, "c", true, true)
end, {})
