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
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      -- normal mode
      require('which-key').register {
        ['<leader>b'] = { name = '[b]uffer', _ = 'which_key_ignore' },
        ['<leader>c'] = { name = '[c]ode', _ = 'which_key_ignore' },
        ['<leader>f'] = { name = '[f]ile', _ = 'which_key_ignore' },
        ['<leader>e'] = { name = 'Tree [e]xplorer', _ = 'which_key_ignore' },
        ['<leader>g'] = {
          name = '[g]it',
          _ = 'which_key_ignore',
          ['h'] = { name = '[h]unk', _ = 'which_key_ignore' },
        },
        ['<leader>s'] = { name = '[s]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[w]indow', _ = 'which_key_ignore' },
        ['<leader><tab>'] = { name = '+tab', _ = 'which_key_ignore' },
        ['<leader>u'] = { name = '[u]i', _ = 'which_key_ignore' },
      }
      -- visual mode
      require('which-key').register({
        ['<leader>g'] = {
          name = '[g]it',
          ['h'] = { name = '[h]unk' },
        },
      }, { mode = 'v' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
