return {
  "nvim-mini/mini.clue",
  version = false,
  event = "VeryLazy",
  config = function()
    local miniclue = require "mini.clue"

    miniclue.setup {
      triggers = {
        -- Leader
        { mode = { "n", "x" }, keys = "<Leader>" },

        -- 常用 Vim 按键提示
        { mode = { "n", "x" }, keys = "g" },
        { mode = { "n", "x" }, keys = "z" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = "n", keys = "<C-w>" },
      },

      clues = {
        miniclue.gen_clues.g(),
        miniclue.gen_clues.z(),
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.windows(),
      },

      window = {
        delay = 500,
      },
    }
  end,
}
