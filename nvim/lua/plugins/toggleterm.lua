return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal (Horizontal)" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Terminal (Float)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle Terminal (Vertical)" },
    },
    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      shade_terminals = false,
      highlights = {
        Normal = {
          guibg = "NONE",
        },
        NormalFloat = {
          link = "Normal",
        },
        FloatBorder = {
          guibg = "NONE",
        },
      },
    },
  },
}
