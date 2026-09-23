return {
  "rachartier/tiny-cmdline.nvim",

  -- 必须在插件加载前设置
  init = function()
    vim.o.cmdheight = 0
    require("vim._core.ui2").enable({})
  end,

  opts = {
    -- 只让 : 使用浮动窗口
    -- / 和 ? 保持 Neovim 原生搜索
    native_types = { "/", "?" },

    -- 命令窗口位置
    position = {
      x = "50%",
      y = "50%",
    },

    -- 命令窗口宽度
    width = {
      value = "60%",
      min = 40,
      max = 80,
    },

    border = "rounded",
  },
}
