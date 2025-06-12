return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- Ensure `opts.ensure_installed` exists and is a table
    opts.ensure_installed = opts.ensure_installed or {}

    -- Add desired parsers to the `ensure_installed` list
    local languages = {
      "python",
      "dockerfile",
      "lua",
      "javascript",
      "yaml",
      "json",
      "rust",
      "toml",
      "markdown",
      "bash",
      "regex",
      "vim",
      "vimdoc",
    }
    vim.list_extend(opts.ensure_installed, languages)

    -- Enhanced configuration
    opts.highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    }

    -- Enable indentation
    opts.indent = {
      enable = true,
    }

    -- Enable incremental selection
    opts.incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        node_decremental = "<BS>",
        scope_incremental = "<TAB>",
      },
    }

    -- Enable autotagging (w/ nvim-ts-autotag plugin)
    opts.autotag = {
      enable = true,
    }

    -- Enable rainbow delimiters
    opts.rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
    }
  end,
}
