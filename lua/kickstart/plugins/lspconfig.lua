local servers = {
  'vtsls',
  'lua_ls',
  'html',
  'cssls',
  'omnisharp',
  'gopls',
}

local formatters = {
  'stylua', -- Used to format Lua code
  'prettierd',
  'csharpier',
}

local ensure_installed = {}
vim.list_extend(ensure_installed, servers)
vim.list_extend(ensure_installed, formatters)

return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', event = 'LspAttach', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      -- TODO: remove or migrate to lazydev
      { 'folke/neodev.nvim', opts = {} },

      -- csharp
      { 'Hoffs/omnisharp-extended-lsp.nvim', lazy = true },
    },
    opts = function()
      return {
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { 'vue' }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- Enable lsp cursor word highlighting
        document_highlight = {
          enabled = true,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
      }
    end,
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, opts)
            vim.keymap.set(opts and opts.modes or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          -- map('gd', require('telescope.builtin').lsp_definitions, 'Goto [d]efinition')
          map('gd', require('fzf-lua').lsp_definitions, 'Goto [d]efinition')

          -- Find references for the word under your cursor.
          -- map('gr', require('telescope.builtin').lsp_references, 'Goto [r]eferences')
          map('gr', require('fzf-lua').lsp_references, 'Goto [r]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          -- map('gI', require('telescope.builtin').lsp_implementations, 'Goto [I]mplementation')
          map('gI', require('fzf-lua').lsp_implementations, 'Goto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          -- TODO: Maybe change this to gt
          -- map('gD', require('telescope.builtin').lsp_type_definitions, 'Goto Type [D]efinition')
          map('gD', require('fzf-lua').lsp_typedefs, 'Goto Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          -- map('<leader>cs', require('telescope.builtin').lsp_document_symbols, 'Document [s]ymbols')
          map('<leader>cs', require('fzf-lua').lsp_document_symbols, 'Document [s]ymbols')

          -- map('<leader>cO', function()
          --   require('neo-tree.command').execute { source = 'document_symbols', toggle = true }
          -- end, 'Document Symbols [O]utline')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          -- map('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>cr', vim.lsp.buf.rename, '[r]ename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, 'Code [a]ction', { modes = { 'n', 'v' } })
          map('<leader>ca', function()
            require('fzf-lua').lsp_code_actions {
              winopts = {
                relative = 'cursor',
                width = 0.95,
                height = 0.95,
                row = 1,
                preview = { horizontal = 'up:75%', layout = 'horizontal' },
              },
            }
          end, 'Code [a]ction', { modes = { 'n', 'v' } })

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, 'Goto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(detach_event)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = detach_event.buf }
              end,
            })
          end

          -- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint and not vim.lsp.inlay_hint.is_enabled() then
          --   vim.lsp.inlay_hint.enable()
          -- end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      -- local servers = {
      --   -- clangd = {},
      --   -- gopls = {},
      --   -- pyright = {},
      --   -- rust_analyzer = {},
      --   -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --   --
      --   -- Some languages (like typescript) have entire language plugins that can be useful:
      --   --    https://github.com/pmizio/typescript-tools.nvim
      --   --
      --   -- But for many setups, the LSP (`tsserver`) will work just fine
      --   tsserver = {},
      --   --
      --
      --   lua_ls = {
      --     -- cmd = {...},
      --     -- filetypes = { ...},
      --     -- capabilities = {},
      --     settings = {
      --       Lua = {
      --         completion = {
      --           callSnippet = 'Replace',
      --         },
      --         -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      --         -- diagnostics = { disable = { 'missing-fields' } },
      --       },
      --     },
      --   },
      -- }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.

      require('mason').setup()

      require('mason-lspconfig').setup { ensure_installed = servers }

      require('mason-lspconfig').setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
          }
        end,
        ['lua_ls'] = require('kickstart.plugins.lsp.lua_ls').setup,
        ['vtsls'] = require('kickstart.plugins.lsp.vtsls').setup, -- typescript
        ['html'] = require('kickstart.plugins.lsp.html').setup,
        ['cssls'] = require('kickstart.plugins.lsp.cssls').setup,
        ['omnisharp'] = require('kickstart.plugins.lsp.omnisharp').setup,
        ['gopls'] = require('kickstart.plugins.lsp.gopls').setup,
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
