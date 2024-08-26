local function get_visual_selection()
  -- Yank current visual selection into the 'v' register
  vim.cmd 'noau normal! "vy"'
  return vim.fn.getreg 'v'
end

return {
  'nvim-pack/nvim-spectre',
  build = false,
  cmd = 'Spectre',
  opts = {
    open_cmd = 'noswapfile vnew',
    replace_engine = {
      ['sed'] = {
        cmd = 'sed',
        args = {
          '-i',
          '',
          '-E',
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>sR", function() require("spectre").open() end, desc = "Search & [R]eplace in Files (Spectre)" },
    { "<leader>r", function() require("spectre").open({ path = vim.fn.expand('%') }) end, desc = "[r]eplace in Buffer (Spectre)", mode = 'n' },
    { "<leader>r", function() require("spectre").open({ path = vim.fn.expand('%'), search_text=get_visual_selection() }) end, desc = "[r]eplace in Buffer (Spectre)", mode = 'v' },
    { "<leader>R", function() require("spectre").open() end, desc = "[R]eplace in Files (Spectre)", mode = 'n' },
    { "<leader>R", function() require("spectre").open({ search_text=get_visual_selection() }) end, desc = "[R]eplace in Files (Spectre)", mode = 'v' },
  },
}
