return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require 'lualine_require'
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = 'auto',
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
        refresh = {
          statusline = 300,
          tabline = 300,
          winbar = 300,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          {
            'diff',
            colored = true,
            -- symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
            symbols = {
              added = '+',
              modified = '~',
              removed = '-',
              -- removed = '–'
            }, -- changes diff symbols
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            'diagnostics',
            -- symbols = { error = ' ', warn = ' ', hint = ' ', info = ' ' },
            symbols = { error = 'E:', warn = 'W:', hint = 'H:', info = 'I:' },
          },
          -- stylua: ignore
          {
            'filename', path = 1,
          },
        },

        lualine_x = {
          -- 'encoding',
          -- 'fileformat',
          'filetype',
        },
        lualine_y = {
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
          },
        },
        lualine_z = {
          -- stylua: ignore
          { 'progress', separator = '',                   padding = { left = 1, right = 1 } },
          { 'location', padding = { left = 0, right = 1 } },
        },
      },
      extensions = { 'neo-tree', 'lazy' },
    }

    return opts
  end,
}
