local M = {}

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@param opts LspCommand
function M.executeCommand(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  return vim.lsp.buf_request(0, 'workspace/executeCommand', params, opts.handler)
end

function M.executeAction(action)
  vim.lsp.buf.code_action {
    apply = true,
    context = {
      only = { action },
      diagnostics = {},
    },
  }
end

return M
