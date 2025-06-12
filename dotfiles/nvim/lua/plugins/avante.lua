return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "azure", -- Explicitly set the provider to Azure
      azure = {
        endpoint = "https://patri-m6ksneq8-swedencentral.openai.azure.com",
        deployment = "gpt-4o-mini",
        temperature = 0,
        max_tokens = 4096,
      },
      openai = {}, --  Empty OpenAI config to ensure it doesn't interfere
      claude = {}, -- Empty claude config to ensure it doesn't interfere
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
    },
  },
}
