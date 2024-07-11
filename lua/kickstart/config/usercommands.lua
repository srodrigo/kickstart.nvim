local te_buf = nil
local te_win_id = nil

local v = vim
local fun = v.fn
local cmd = v.api.nvim_command
local gotoid = fun.win_gotoid
local getid = fun.win_getid

local function openTerminal(orientation)
  if fun.bufexists(te_buf) ~= 1 then
    cmd 'au TermOpen * setlocal nonumber norelativenumber signcolumn=no'
    if orientation == 'vertical' then
      cmd 'vs | winc L | te'
    else
      cmd 'sp | winc J | te'
    end
    te_win_id = getid()
    te_buf = fun.bufnr '%'
  elseif gotoid(te_win_id) ~= 1 then
    if orientation == 'vertical' then
      cmd('vert sb' .. te_buf .. ' | winc L')
    else
      cmd('hor sb' .. te_buf .. ' | winc J')
    end
    te_win_id = getid()
  end
  cmd 'startinsert'
end

local function hideTerminal()
  cmd 'hide'
end

local function toggleTerm(orientation)
  if gotoid(te_win_id) == 1 then
    hideTerminal()
  else
    openTerminal(orientation)
  end
end

-- Terminal commands

vim.api.nvim_create_user_command('TermToggleVertical', function()
  vim.notify ':TermToggleVertical'
  toggleTerm 'vertical'
end, {})

vim.api.nvim_create_user_command('TermToggleHorizontal', function()
  vim.notify ':TermToggleHorizontal'
  toggleTerm 'horizontal'
end, {})

-- Better write and quit
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Qa', 'qa', {})
vim.api.nvim_create_user_command('Q', 'q', {})
