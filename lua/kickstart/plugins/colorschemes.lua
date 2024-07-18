local colorscheme = 'nordbones'

local priority = 1000 -- Make sure to load this before all the other start plugins.

-- You can configure highlights by doing something like:
vim.cmd.hi 'Comment gui=none'

local all_colorschemes = {
  tokyonight = { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = priority,
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- Default: 'tokyonight-night'
      vim.cmd.colorscheme 'tokyonight-moon'
    end,
  },
  nordic = {
    'AlexvZyl/nordic.nvim',
    priority = priority,
    config = function()
      vim.cmd.colorscheme 'nordic'
    end,
  },
  iceberg = {
    'cocopon/iceberg.vim',
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'iceberg'
    end,
  },
  base16 = {
    'tinted-theming/base16-vim',
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'base16-classic-dark'
    end,
  },
  poimandres = {
    'olivercederborg/poimandres.nvim',
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'poimandres'
    end,
  },
  forestbones = {
    'zenbones-theme/zenbones.nvim',
    dependencies = {
      'rktjmp/lush.nvim',
    },
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'forestbones'
      vim.o.background = 'dark' -- or light
    end,
  },
  nordbones = {
    'zenbones-theme/zenbones.nvim',
    dependencies = {
      'rktjmp/lush.nvim',
    },
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'nordbones'
      vim.o.background = 'light' -- or light
      vim.cmd 'highlight Normal guibg=#2D303C'
    end,
  },
  nightfox = {
    'EdenEast/nightfox.nvim',
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'nightfox'
    end,
  },
  nordfox = {
    'EdenEast/nightfox.nvim',
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'nordfox'
    end,
  },
  dawnfox = {
    'EdenEast/nightfox.nvim',
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'dawnfox'
    end,
  },
  ['no-clown-fiesta'] = {
    'aktersnurra/no-clown-fiesta.nvim',
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'no-clown-fiesta'
    end,
  },
  nord1 = {
    'shaunsingh/nord.nvim',
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'nord'
    end,
  },
  nord2 = {
    'gbprod/nord.nvim',
    priority = priority,
    init = function()
      vim.cmd.colorscheme 'nord'
    end,
  },
}

return {
  all_colorschemes[colorscheme],
}

-- vim: ts=2 sts=2 sw=2 et
