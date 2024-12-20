local colorscheme = 'nord'

local priority = 1000 -- Make sure to load this before all the other start plugins.

local nordBackground = '#2D303C'
local nord3 = '#4c566a'

-- You can configure highlights by doing something like:
vim.cmd.hi 'Comment gui=none'

local all_colorschemes = {
  nordbones = {
    'zenbones-theme/zenbones.nvim',
    dependencies = {
      'rktjmp/lush.nvim',
    },
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'nordbones'
      vim.o.background = 'dark' -- or light
      vim.cmd('highlight Normal guibg=' .. nordBackground)
    end,
  },
  nord = {
    'gbprod/nord.nvim',
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'nord'
    end,
    opts = {
      diff = { mode = 'fg' },
      on_highlights = function(highlights, _)
        highlights.Normal.bg = nordBackground
        highlights.DiffAdd.bg = 'NONE'
        highlights.DiffDelete.bg = 'NONE'
        highlights.NvimTreeIndentMarker.fg = nord3
      end,
    },
  },
  ['zenbones-dim'] = {
    'zenbones-theme/zenbones.nvim',
    dependencies = {
      'rktjmp/lush.nvim',
    },
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'zenbones'
      vim.o.background = 'light'
    end,
  },
}

return {
  all_colorschemes[colorscheme],
}

-- vim: ts=2 sts=2 sw=2 et
