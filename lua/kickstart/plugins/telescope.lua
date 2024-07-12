-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      {
        'nvim-telescope/telescope-live-grep-args.nvim',
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = '^1.0.0',
        config = function()
          local ok, err = pcall(require('telescope').load_extension, 'live_grep_args')
          if not ok then
            print('Failed to load `telescope-live-grep-args.nvim`:\n' .. err)
          end
        end,
      },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        defaults = {
          mappings = {
            i = {
              ['<c-enter>'] = 'to_fuzzy_refine',
              ['<S-Down>'] = require('telescope.actions').cycle_history_next,
              ['<S-Up>'] = require('telescope.actions').cycle_history_prev,
              ['<C-f>'] = require('telescope.actions').preview_scrolling_down,
              ['<C-b>'] = require('telescope.actions').preview_scrolling_up,
            },
          },
          layout_config = { horizontal = { width = 0.95, height = 0.95 } },
          wrap_results = true,
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      -- git
      vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Search git [c]ommits history' })
      vim.keymap.set('n', '<leader>gs', builtin.git_commits, { desc = 'Search git [s]tatus' })
      vim.keymap.set('n', '<leader>:', builtin.commands, { desc = 'Search [c]ommands' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search [h]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search [k]eymaps' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find [f]iles' })
      vim.keymap.set(
        'n',
        '<leader>fa',
        "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--ignore-case', '--hidden', '--no-ignore', '-g', '!.git'} })<cr>",
        { desc = 'Find [a]ll Files (hidden/gitignore)' }
      )
      vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Find Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search [f]iles' })
      vim.keymap.set(
        'n',
        '<leader>sa',
        "<cmd>lua require'telescope.builtin'.live_grep({ additional_args = { '--hidden' } })<cr>",
        { desc = 'Search [a]ll (hidden)' }
      )
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Search [s]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current [w]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search by [g]rep' })
      vim.keymap.set('n', '<leader>s/', "<cmd>lua require'telescope.builtin'.grep_string({ search = '' })<cr>", { desc = 'Search all [/]' })
      vim.keymap.set(
        'n',
        '<leader>st',
        "<cmd>lua require'telescope.builtin'.grep_string({ search = '', only_sort_text = true })<cr>",
        { desc = 'Search [t]ext' }
      )
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { buffer = true, desc = 'Search [d]iagnostics' })
      vim.keymap.set('n', '<leader>sD', builtin.diagnostics, { desc = 'Search [D]iagnostics' })
      vim.keymap.set('n', '<leader>sm', builtin.diagnostics, { desc = 'Search [m]arks' })
      vim.keymap.set('n', '<leader>so', builtin.diagnostics, { desc = 'Search [o]ptions' })
      vim.keymap.set('n', '<leader>sq', builtin.diagnostics, { desc = 'Search [q]uickfix' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Search [r]esume' })
      vim.keymap.set('n', '<leader><leader>', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Search [/]' })

      -- Slightly advanced example of overriding default behavior and theme
      -- vim.keymap.set('n', '<leader>/', function()
      --   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      --   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      --     winblend = 10,
      --     previewer = false,
      --   })
      -- end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sc', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Search Neovim [c]onfig' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
