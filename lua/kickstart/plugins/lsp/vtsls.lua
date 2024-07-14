local commands = require 'kickstart.plugins.lsp.commands'

return {
  setup = function() -- typescript
    require('lspconfig')['vtsls'].setup {
      -- explicitly add default filetypes, so that we can extend
      -- them in related extras
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
      },
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = 'always' },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = 'literals' },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    }

    local keys = {
      {
        'gD',
        function()
          local params = vim.lsp.util.make_position_params()
          commands.executeCommand {
            command = 'typescript.goToSourceDefinition',
            arguments = { params.textDocument.uri, params.position },
            open = true,
          }
        end,
        desc = 'Goto Source [D]efinition',
      },
      {
        'gR',
        function()
          commands.executeCommand {
            command = 'typescript.findAllFileReferences',
            arguments = { vim.uri_from_bufnr(0) },
            open = true,
          }
        end,
        desc = 'File References',
      },
      {
        '<leader>co',
        function()
          commands.executeAction 'source.organizeImports'
        end,
        desc = 'Organize Imports',
      },
      {
        '<leader>cm',
        function()
          commands.executeAction 'source.addMissingImports.ts'
        end,
        desc = 'Add [m]issing imports',
      },
      {
        '<leader>cu',
        function()
          commands.executeAction 'source.removeUnused.ts'
        end,
        desc = 'Remove [u]nused imports',
      },
      {
        '<leader>cD',
        function()
          commands.executeAction 'source.fixAll.ts'
        end,
        desc = 'Fix all [D]iagnostics',
      },
      {
        '<leader>cV',
        function()
          commands.executeCommand { command = 'typescript.selectTypeScriptVersion' }
        end,
        desc = 'Select TS workspace [V]ersion',
      },
      -- TODO: add
      -- refactor.extract.function
      -- refactor.extract.constant
    }

    for _, key in ipairs(keys) do
      vim.keymap.set('n', key[1], key[2], { desc = key.desc })
    end
  end,
}
