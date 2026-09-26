return {
  "OXY2DEV/markview.nvim",

  ft = {
    "markdown",
    "quarto",
  },

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },

  opts = function()
    local presets = require("markview.presets")

    return {
      preview = {
        enable = true,
        icon_provider = "mini",
      },

      markdown = {
        enable = true,

        headings = presets.headings.glow,

        block_quotes = presets.block_quotes.obsidian,

        tables = presets.tables.rounded,

        horizontal_rules = presets.horizontal_rules.thin,

        code_blocks = {
          enable = true,
        },

        list_items = {
          enable = true,
        },
      },

      markdown_inline = {
        enable = true,

        checkboxes = {
          enable = true,
        },

        inline_codes = {
          enable = true,
        },

        hyperlinks = {
          enable = true,
        },

        images = {
          enable = true,
        },

        internal_links = {
          enable = true,
        },

        highlights = {
          enable = true,
        },
      },

      latex = {
        enable = true,
      },

      yaml = {
        enable = true,
      },
    }
  end,

  keys = {
    {
      "<leader>mp",
      "<cmd>Markview<cr>",
      ft = { "markdown", "quarto" },
      desc = "Markdown Preview",
    },

    {
      "<leader>ms",
      "<cmd>Markview splitToggle<cr>",
      ft = { "markdown", "quarto" },
      desc = "Markdown Split View",
    },
  },
}

