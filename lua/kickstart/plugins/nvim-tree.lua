-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Tree [E]xplorer Toggle' } },
  },
  opts = {},
  config = function()
    require('nvim-tree').setup {
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        width = 40,
      },
      renderer = {
        group_empty = true,
        icons = {
          git_placement = 'after',
          diagnostics_placement = 'after',
          glyphs = {
            git = {
              unstaged = '~',
              unmerged = 'M',
              renamed = 'R',
              untracked = '+',
              deleted = 'D',
              ignored = 'I',
            },
          },
          show = {
            file = true,
            folder = true,
            folder_arrow = false,
            git = true,
            modified = true,
            hidden = true,
            diagnostics = true,
            bookmarks = true,
          },
        },
        indent_markers = {
          enable = true,
        },
        highlight_git = 'name',
        highlight_hidden = 'name',
        hidden_display = 'all',
      },
      filters = {
        dotfiles = true,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
          hint = 'H',
          info = 'I',
          warning = 'W',
          error = 'E',
        },
      },
    }
  end,
}
