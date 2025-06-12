-- bootstrap lazy.nvim, LazyVim and your plugins

require("config.lazy")

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.treesitter.language.register("dockerfile", "Dockerfile")

-- Keymaps for Telescope
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>gr", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
