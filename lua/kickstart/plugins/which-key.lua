-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      icons = {
        rules = false,
      },
      spec = {
        {
          mode = { 'n', 'v' },
          { '<leader><tab>', group = 'tab' },
          { '<leader>a', group = '[a]i' },
          { '<leader>b', group = '[b]uffer' },
          { '<leader>c', group = '[c]ode' },
          { '<leader>e', group = 'Tree [e]xplorer' },
          { '<leader>f', group = '[f]ile' },
          { '<leader>g', group = '[g]it' },
          { '<leader>s', group = '[s]earch' },
          { '<leader>u', group = '[u]i' },
        },
      },
      replace = {
        key = {
          { '<Space>', '<space>' },
          { '<Tab>', '<tab>' },
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
