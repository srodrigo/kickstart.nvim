return {
  setup = function()
    require('lspconfig')['lua_ls'].setup {
      -- cmd = {...},
      -- filetypes = { ...},
      -- capabilities = {},
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
          workspace = {
            library = {
              '${3rd}/love2d/library',
            },
          },
        },
      },
    }
  end,
}
