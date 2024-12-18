return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    opts = {
      debug = true,
      auto_insert_mode = false,
      chat_autocomplete = true,
      show_help = true,
      selection = function(source)
        local select = require 'CopilotChat.select'
        return select.visual(source) or select.buffer(source)
      end,
      -- window = {
      --   layout = 'float',
      --   relative = 'cursor',
      --   width = 0.9,
      --   height = 0.9,
      --   row = 1,
      -- },
    },
    keys = {
      {
        '<leader>aa',
        '<cmd>CopilotChatToggle<cr>',
        desc = 'Toggle Copilot Ch[a]t',
        mode = { 'n', 'v' },
      },
      {
        '<leader>aR',
        '<cmd>CopilotChatReset<cr>',
        desc = '[R]eset Copilot Chat',
        mode = { 'n', 'v' },
      },
      {
        '<leader>aq',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input)
          end
        end,
        desc = '[q]uick Copilot Chat',
        mode = { 'n', 'v' },
      },
      {
        '<leader>as',
        '<cmd>CopilotChatStop<cr>',
        desc = '[s]top Copilot Chat',
        mode = { 'n', 'v' },
      },
      -- Show prompts actions with telescope
      {
        '<leader>ap',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = '[p]rompt Copilot Chat Actions',
        mode = { 'n', 'v' },
      },
      -- Show help actions with telescope
      {
        '<leader>ad',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.help_actions())
        end,
        desc = '[d]iagnostic Copilot Chat Actions',
        mode = { 'n', 'v' },
      },
    },
  },
}
