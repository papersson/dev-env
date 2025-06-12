return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                -- Disable import checks to avoid duplicate with ruff
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "none",
                },
              },
            },
          },
        },
        tsserver = {}, -- Language server for TypeScript/JavaScript
        lua_ls = {}, -- Language server for Lua
        dockerls = {}, -- Language server for Docker
        rust_analyzer = {},
      },
      on_attach = function(client, bufnr)
        -- Define keymaps for LSP functions
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Hover documentation
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- Go to definition
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        -- Code action
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end,
    },
  },
}
