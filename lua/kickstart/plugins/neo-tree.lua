-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>e', ':Neotree toggle<CR>', { desc = 'NeoTree toggle' } },
    {
      '<leader>ge',
      function()
        require('neo-tree.command').execute { source = 'git_status', toggle = true }
      end,
      desc = 'Git [e]xplorer',
    },
    {
      '<leader>be',
      function()
        require('neo-tree.command').execute { source = 'buffers', toggle = true }
      end,
      desc = 'Buffer [e]xplorer',
    },
  },
  opts = {
    sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
    open_files_do_not_replace_types = { 'terminal', 'qf', 'Outline' },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ['<leader>e'] = 'close_window',
          ['<space>'] = 'none',
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['Y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'Copy Path to Clipboard',
          },
          ['P'] = { 'toggle_preview', config = { use_float = false, use_image_nvim = true } },
          ['O'] = {
            function(state)
              local uri = state.tree:get_node().path
              local cmd
              if vim.fn.has 'win32' == 1 then
                cmd = { 'explorer', uri }
              elseif vim.fn.has 'macunix' == 1 then
                cmd = { 'open', uri }
              else
                if vim.fn.executable 'xdg-open' == 1 then
                  cmd = { 'xdg-open', uri }
                elseif vim.fn.executable 'wslview' == 1 then
                  cmd = { 'wslview', uri }
                else
                  cmd = { 'open', uri }
                end
              end

              local ret = vim.fn.jobstart(cmd, { detach = true })
              if ret <= 0 then
                local msg = {
                  'Failed to open uri',
                  ret,
                  vim.inspect(cmd),
                }
                vim.notify(table.concat(msg, '\n'), vim.log.levels.ERROR)
              end
            end,
            desc = 'Open with System File Brower',
          },
          ['Z'] = 'expand_all_nodes',
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
      },
    },
    document_symbols = {
      window = {
        mappings = {
          ['<cr>'] = 'jump_to_symbol',
          ['o'] = 'toggle_node',
          ['l'] = 'toggle_node',
          ['h'] = 'close_node',
          ['/'] = 'filter',
          ['z'] = 'close_all_nodes',
          ['Z'] = 'expand_all_nodes',
        },
      },
    },
  },
}
