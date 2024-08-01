return {
  {
    'zbirenbaum/copilot-cmp',
    dependencies = {
      {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        build = ':Copilot auth',
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false },
          filetypes = {
            markdown = true,
            help = true,
          },
        },
      },
    },
    config = function()
      require('copilot_cmp').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },
}
