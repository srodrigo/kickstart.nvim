local prettier_formatters = { { 'prettierd', 'prettier' } }

return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[f]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if not vim.g.format_on_save then
          return
        end
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true, cs = true }
        return {
          timeout_ms = 1000,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        cs = { 'csharpier' },
        css = prettier_formatters,
        go = { 'goimports', 'gofumpt' },
        graphql = prettier_formatters,
        handlebars = prettier_formatters,
        html = prettier_formatters,
        javascript = prettier_formatters,
        javascriptreact = prettier_formatters,
        json = prettier_formatters,
        jsonc = prettier_formatters,
        less = prettier_formatters,
        markdown = prettier_formatters,
        ['markdown.mdx'] = prettier_formatters,
        scss = prettier_formatters,
        typescript = prettier_formatters,
        typescriptreact = prettier_formatters,
        vue = prettier_formatters,
        yaml = prettier_formatters,
      },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
        csharpier = {
          command = 'dotnet-csharpier',
          args = { '--write-stdout' },
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
