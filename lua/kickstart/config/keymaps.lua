---@param buf? number
---@param value? boolean
local function toggle_inlay_hints(buf, value)
  local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  if type(ih) == 'function' then
    ih(buf, value)
  elseif type(ih) == 'table' and ih.enable then
    if value == nil then
      value = not ih.is_enabled { bufnr = buf or 0 }
    end
    ih.enable(value, { bufnr = buf })

    if value then
      vim.notify 'Inlay Hints enabled'
    else
      vim.notify 'Inlay Hints disabled'
    end
  end
end

local diagnostics_enabled = true
local function toggle_diagnostics()
  -- if this Neovim version supports checking if diagnostics are enabled
  -- then use that for the current state
  if vim.diagnostic.is_enabled then
    diagnostics_enabled = vim.diagnostic.is_enabled()
  elseif vim.diagnostic.is_disabled then
    diagnostics_enabled = not vim.diagnostic.is_disabled()
  end
  diagnostics_enabled = not diagnostics_enabled

  if diagnostics_enabled then
    vim.diagnostic.enable()
    vim.notify 'Diagnostics enabled'
  else
    vim.diagnostic.disable()
    vim.notify 'Diagnostics disabled'
  end
end

vim.g.format_on_save = true
local function toggle_format_on_save()
  vim.g.format_on_save = not vim.g.format_on_save

  if vim.g.format_on_save then
    vim.notify 'Format On Save enabled'
  else
    vim.notify 'Format On Save disabled'
  end
end

local function open_buffer_diagnostics_on_quickfix()
  local qflist = {}

  local diagnostics = vim.diagnostic.get()
  for _, diag in ipairs(diagnostics) do
    if vim.fn.bufnr '%' == diag.bufnr then
      table.insert(qflist, {
        bufnr = diag.bufnr,
        lnum = diag.lnum + 1,
        col = diag.col + 1,
        text = diag.message,
        severity = diag.severity,
      })
    end
  end

  vim.fn.setqflist(qflist, 'r')
  vim.cmd.copen()
end

local function delete_all_other_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_get_option_value('buflisted', { buf = buf })
      and not vim.api.nvim_get_option_value('modified', { buf = buf })
      and buf ~= vim.api.nvim_get_current_buf()
    then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to Previous [d]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to Next [d]iagnostic message' })
map('n', '[e', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Go to Previous [e]rror message' })
map('n', ']e', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Go to Next [e]rror message' })
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line [d]iagnostics' })
map('n', '<leader>cq', open_buffer_diagnostics_on_quickfix, { desc = 'Diagnostic [q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
map('n', '<C-w>m', '<C-w>|<C-w>_', { desc = 'Maximise Window' })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })
-- Resize window using <M> arrow keys
map('n', '<M-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<M-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<M-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<M-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- Back to Normal mode
map('i', 'jk', '<esc>')

-- Buffers
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', '<leader>bd', '<cmd>:bp | sp | bn | bd<cr>', { desc = '[d]elete Buffer' })
map('n', '<leader>bD', delete_all_other_buffers, { desc = '[D]elete All Other Buffers', silent = true })

-- Better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })

-- Quickfix
map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- Git
map('n', '<leader>gd', '<cmd>Gdiffsplit<cr>', { desc = 'Open File [d]iff' })
map('n', '<leader>gD', '<cmd>:tab Git<cr>', { desc = 'Open [D]iff View' })
map('n', '<leader>gm', '<cmd>Git mergetool<cr>', { desc = 'Open [m]ergetool' })
map('n', '<leader>gM', "<cmd>:exec 'norm O' | Gvdiffsplit!<cr>", { desc = 'Open [M]erge View' })
map('n', '<leader>gl', '<cmd>:0GcLog<cr>', { desc = 'Open file [l]og' })
map('n', '<leader>gL', '<cmd>:tab Git log<cr>', { desc = 'Open repository [L]og' })

-- Terminal
map({ 'n', 't' }, '<C-\\>', '<cmd>TermToggleVertical<cr>', { desc = 'Toggle Terminal Vertical', silent = true })
map({ 'n', 't' }, '<C-/>', '<cmd>TermToggleHorizontal<cr>', { desc = 'Toggle Terminal Horizontal', silent = true })

-- Tabs
map('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'Close [o]ther Tabs' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = '[d]elete (Close) Tab' })
map('n', ']<tab>', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '[<tab>', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- UI toggles
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  map('n', '<leader>uh', function()
    toggle_inlay_hints()
  end, { desc = 'Toggle Inlay [h]ints' })
end

map('n', '<leader>ud', function()
  toggle_diagnostics()
end, { desc = 'Toggle [d]iagnostics' })

map('n', '<leader>ub', '<cmd>Gitsigns toggle_current_line_blame<cr>', { desc = 'Toggle Git Line [b]lame' })
map('n', '<leader>uD', '<cmd>Gitsigns toggle_deleted<cr>', { desc = 'Toggle Git Show [D]eleted' })
map('n', '<leader>uf', function()
  toggle_format_on_save()
end, { desc = 'Toggle [f]ormat on Save' })
