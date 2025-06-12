-- lua/plugins/neotree.lua
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- for file icons
      "MunifTanjim/nui.nvim",
    },
    -- Optionally, if you want to keep using <leader>fs to toggle:
    keys = {
      { "<leader>fs", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-Tree" },
    },
    opts = {
      -- Close Neo-Tree automatically if it's the last window
      close_if_last_window = true,
      -- Rounded border for popups
      popup_border_style = "rounded",
      -- Show no diagnostics on side panel
      enable_diagnostics = false,

      -- Default component configs for icons, indentation, etc.
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = false,
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "*",
          highlight = "Directory",
        },
        modified = {
          symbol = "[+]", -- Symbol to show when file is modified
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = false,
        },
        git_status = {
          symbols = {
            added = "✚",
            modified = "",
            deleted = "✖",
            renamed = "",
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "S",
            conflict = "",
          },
        },
      },

      -- Window-level configuration
      window = {
        position = "left",
        width = 30,
        mappings = {
          -- Disable space from doing anything in Neo-Tree
          ["<space>"] = false,
          ["<cr>"] = "open", -- Enter opens files
        },
      },

      -- Source definitions (filesystem, buffers, git_status, etc.)
      source_selector = {
        winbar = false, -- or true if you'd like a top tab-like selector
        sources = {
          { source = "filesystem", display_name = "File" },
          { source = "buffers", display_name = "Bufs" },
          { source = "git_status", display_name = "Git" },
        },
      },

      -- File-specific configurations
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { "node_modules" },
        },
        follow_current_file = true,
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      -- If you want to auto-close netrw to avoid conflicts:
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
