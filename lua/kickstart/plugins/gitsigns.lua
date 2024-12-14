-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufEnter' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      -- signs = {
      --   add = { text = "▎" },
      --   change = { text = "▎" },
      --   delete = { text = "" },
      --   topdelete = { text = "" },
      --   changedelete = { text = "▎" },
      --   untracked = { text = "▎" },
      -- },
      -- signs_staged = {
      --   add = { text = "▎" },
      --   change = { text = "▎" },
      --   delete = { text = "" },
      --   topdelete = { text = "" },
      --   changedelete = { text = "▎" },
      -- },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 400,
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Next git [h]unk' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Prev git [h]unk' })

        -- Actions
        map({ 'n', 'v' }, '<leader>gs', gitsigns.stage_hunk, { desc = 'Git [s]tage hunk' })
        map({ 'n', 'v' }, '<leader>gr', gitsigns.reset_hunk, { desc = 'Git [r]eset hunk' })
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Git [S]tage buffer' })
        map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Git [u]ndo stage hunk' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Git [R]eset buffer' })
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Git [p]review hunk' })
        map('n', '<leader>gb', gitsigns.blame_line, { desc = 'Git [b]lame line' })
        -- text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'GitSigns Select Hunk' })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
