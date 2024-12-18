return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons', { 'junegunn/fzf', build = './install --bin' } },
    config = function()
      local actions = require 'fzf-lua.actions'
      require('fzf-lua').setup {
        'telescope',
        winopts = {
          height = 0.95,
          width = 0.95,
          preview = {
            delay = 50,
          },
        },
        grep = {
          actions = {
            -- actions inherit from 'actions.files' and merge
            -- this action toggles between 'grep' and 'live_grep'
            ['ctrl-g'] = { actions.grep_lgrep },
            -- uncomment to enable '.gitignore' toggle for grep
            ['ctrl-r'] = { actions.toggle_ignore },
          },
        },
        lsp = {
          code_actions = {
            previewer = 'codeaction_native',
            preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
          },
        },
        previewers = {
          codeaction = {
            -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
            diff_opts = { ctxlen = 3 },
          },
          codeaction_native = {
            diff_opts = { ctxlen = 3 },
            -- git-delta is automatically detected as pager, set `pager=false`
            -- to disable, can also be set under 'lsp.code_actions.preview_pager'
            -- recommended styling for delta
            --pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
          },
        },

        -- Buffers
        vim.keymap.set('n', '<leader>bb', '<cmd>FzfLua buffers<cr>', { desc = 'Search [b]uffers' }),

        -- Files
        vim.keymap.set('n', '<leader><leader>', '<cmd>FzfLua files<cr>', { desc = 'Find [f]iles' }),
        vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Find [f]iles' }),
        vim.keymap.set(
          'n',
          '<leader>fa',
          '<cmd>FzfLua files rg_opts=[[--color=never --files --ignore-case --hidden --no-ignore -g "!.git"]]<cr>',
          { desc = 'Find [a]ll Files (hidden/gitignore)' }
        ),
        vim.keymap.set('n', '<leader>f.', '<cmd>FzfLua oldfiles cwd_only=true<cr>', { desc = 'Find Recent Files ("." for repeat)' }),

        -- Search - git
        vim.keymap.set('n', '<leader>gg', '<cmd>FzfLua git_status<cr>', { desc = 'Search [g]it status' }),
        vim.keymap.set('n', '<leader>gh', '<cmd>FzfLua git_commits<cr>', { desc = 'Search git [h]istory' }),

        -- Search - vim
        vim.keymap.set('n', '<leader>s:', '<cmd>FzfLua commands<cr>', { desc = 'Search Nvim commands [:]' }),
        vim.keymap.set('n', '<leader>sh', '<cmd>FzfLua helptags<cr>', { desc = 'Search Nvim [h]elp' }),
        vim.keymap.set('n', '<leader>sk', '<cmd>FzfLua keymaps<cr>', { desc = 'Search Nvim [k]eymaps' }),
        vim.keymap.set('n', '<leader>sm', '<cmd>FzfLua marks<cr>', { desc = 'Search Nvim [m]arks' }),
        vim.keymap.set('n', '<leader>sq', '<cmd>FzfLua quickfix<cr>', { desc = 'Search Nvim [q]uickfix' }),

        -- search - text
        vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep_native<cr>', { desc = 'Search Text [/]' }),
        vim.keymap.set('n', '<leader>sf', '<cmd>FzfLua live_grep_glob<cr>', { desc = 'Search Text [f]uzzy (Args)' }),
        vim.keymap.set('n', '<leader>sg', '<cmd>FzfLua live_grep_native<cr>', { desc = 'Search Text by [g]rep' }),

        -- Search - FzfLua
        vim.keymap.set('n', '<leader>ss', '<cmd>FzfLua<cr>', { desc = 'Search [s]elect FzfLua' }),

        -- Search - diagnostics
        vim.keymap.set('n', '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', { desc = 'Search [D]iagnostics (Workspace)' }),

        -- Search - resume
        vim.keymap.set('n', '<leader>sr', '<cmd>FzfLua resume<cr>', { desc = 'Search [r]esume' }),

        -- Search - Neovim configuration files
        vim.keymap.set('n', '<leader>sc', function()
          require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
        end, { desc = 'Search Neovim [c]onfig' }),
      }
    end,
  },
}
