return {
  'nvim-pack/nvim-spectre',
  build = false,
  cmd = 'Spectre',
  opts = { open_cmd = 'noswapfile vnew' },
  -- stylua: ignore
  keys = {
    { "<leader>sR", function() require("spectre").open() end, desc = "Search & [R]eplace in Files (Spectre)" },
    { "<leader>r", function() require("spectre").open({ path = vim.fn.expand('%') }) end, desc = "[r]eplace in Buffer (Spectre)" },
    { "<leader>R", function() require("spectre").open() end, desc = "[R]eplace in Files (Spectre)" },
  },
}
