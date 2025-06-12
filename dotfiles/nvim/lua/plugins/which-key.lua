return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- or "BufWinEnter" etc., depending on how/when you want which-key to load
  opts = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>r", name = "Refactor" },
      { "<leader>rn", vim.lsp.buf.rename, desc = "Rename Symbol" },
    })
  end,
}
