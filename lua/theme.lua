local M = {}

local theme_file = vim.fn.stdpath("state") .. "/theme"

-- 扫描 lazy.nvim 已安装的插件，自动发现 colorscheme
function M.get_themes()
  local themes = {}

  local ok, lazy_config = pcall(require, "lazy.core.config")

  if not ok or not lazy_config.plugins then
    return themes
  end

  for _, plugin in pairs(lazy_config.plugins) do
    if plugin.dir and vim.fn.isdirectory(plugin.dir) == 1 then
      local colors_dir = plugin.dir .. "/colors"

      if vim.fn.isdirectory(colors_dir) == 1 then
        local files = vim.fn.glob(
          colors_dir .. "/*.{vim,lua}",
          false,
          true
        )

        for _, file in ipairs(files) do
          local name = vim.fn.fnamemodify(file, ":t:r")

          if name ~= "" then
            themes[name] = true
          end
        end
      end
    end
  end

  local result = vim.tbl_keys(themes)

  table.sort(result)

  return result
end

-- 检查主题是否存在
local function is_available(theme)
  for _, name in ipairs(M.get_themes()) do
    if name == theme then
      return true
    end
  end

  return false
end

-- 应用主题
local function apply(theme)
  if not theme or not is_available(theme) then
    return false
  end

  -- lazy.nvim 会根据 colorscheme 自动加载对应插件
  local ok = pcall(vim.cmd.colorscheme, theme)

  if not ok then
    vim.notify(
      "无法加载主题: " .. theme,
      vim.log.levels.ERROR
    )

    return false
  end

  return true
end

-- 保存主题
local function save(theme)
  vim.fn.mkdir(vim.fn.stdpath("state"), "p")

  local file = io.open(theme_file, "w")

  if not file then
    vim.notify("无法保存主题设置", vim.log.levels.WARN)
    return
  end

  file:write(theme)
  file:close()
end

-- 读取上次主题
local function load()
  local file = io.open(theme_file, "r")

  if not file then
    return nil
  end

  local theme = file:read("*l")

  file:close()

  if is_available(theme) then
    return theme
  end

  return nil
end

-- 启动时恢复主题
function M.setup()
  local theme = load()

  if theme and apply(theme) then
    return
  end

  -- 如果没有保存过主题，则使用 nightfox
  if is_available("nightfox") then
    apply("nightfox")
  else
    -- 找不到 nightfox 时使用第一个发现的主题
    local themes = M.get_themes()

    if #themes > 0 then
      apply(themes[1])
    end
  end
end

function M.pick()
  -- Telescope 是 lazy-loaded 的
  require("lazy").load {
    plugins = { "telescope.nvim" },
  }

  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local sorters = require "telescope.sorters"

  local themes = M.get_themes()

  if #themes == 0 then
    vim.notify("没有发现可用主题", vim.log.levels.WARN)
    return
  end

  local original = vim.g.colors_name
  local current = original

  local picker = pickers.new({}, {
    prompt_title = "Themes",

    finder = finders.new_table {
      results = themes,

      entry_maker = function(theme)
        local marker = theme == original and "● " or "  "

        return {
          value = theme,
          display = marker .. theme,
          ordinal = theme,
        }
      end,
    },

    sorter = sorters.get_generic_fuzzy_sorter(),

    -- 我们需要的是整个 Neovim 实时换主题，
    -- 而不是 Telescope 的文件 previewer
    previewer = false,

    sorting_strategy = "ascending",

    layout_strategy = "center",

    layout_config = {
      width = 0.45,
      height = 0.55,
    },

    attach_mappings = function(prompt_bufnr, map)
      -- 实时预览
      local function preview()
        local selection = action_state.get_selected_entry()

        if not selection then
          return
        end

        local theme = selection.value

        if theme ~= current then
          if apply(theme) then
            current = theme
          end
        end
      end

      local function next_theme()
        actions.move_selection_next(prompt_bufnr)

        vim.schedule(preview)
      end

      local function previous_theme()
        actions.move_selection_previous(prompt_bufnr)

        vim.schedule(preview)
      end

      -- 确认
      local function confirm()
        local selection = action_state.get_selected_entry()

        if selection then
          local theme = selection.value

          if apply(theme) then
            save(theme)
            current = theme
          end
        end

        actions.close(prompt_bufnr)
      end

      -- 取消
      local function cancel()
        if original then
          apply(original)
        end

        actions.close(prompt_bufnr)
      end

      -- 上下移动
      map("i", "<Down>", next_theme)
      map("i", "<Up>", previous_theme)

      map("n", "<Down>", next_theme)
      map("n", "<Up>", previous_theme)

      -- Ctrl-j / Ctrl-k
      map("i", "<C-j>", next_theme)
      map("i", "<C-k>", previous_theme)

      -- 确认
      map("i", "<CR>", confirm)
      map("n", "<CR>", confirm)

      -- 取消
      map("i", "<Esc>", cancel)
      map("n", "<Esc>", cancel)

      map("i", "<C-c>", cancel)
      map("n", "q", cancel)

      return true
    end,
  })

  picker:find()
end

return M
