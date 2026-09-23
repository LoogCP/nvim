local map = vim.keymap.set

-- general mappings
map("n", "<C-s>", "<cmd> w <CR>", { desc = "保存文件" })
map("i", "jk", "<ESC>", { desc = "退出插入" })
map("n", "<C-c>", "<cmd> %y+ <CR>", { desc = "复制全文" })

-- nvimtree
map("n", "<C-n>", "<cmd> NvimTreeToggle <CR>", { desc = "切换文件树" })
map("n", "<C-h>", "<cmd> NvimTreeFocus <CR>", { desc = "聚焦文件树" })

-- telescope
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>", { desc = "查找文件" })
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>", { desc = "最近文件" })
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>", { desc = "搜索文本" })
map("n", "<leader>gt", "<cmd> Telescope git_status <CR>", { desc = "Git状态" })

-- bufferline, cycle buffers
map("n", "<Tab>", "<cmd> BufferLineCycleNext <CR>", { desc = "下个缓冲区" })
map("n", "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>", { desc = "上个缓冲区" })
map("n", "<C-q>", "<cmd> bd <CR>", { desc = "关闭缓冲区" })

-- comment.nvim
map("n", "<leader>/", "gcc", {
  remap = true,
  desc = "切换注释",
})
map("v", "<leader>/", "gc", {
  remap = true,
  desc = "切换注释",
})

-- format
map("n", "<leader>fm", function()
  require("conform").format()
end, { desc = "格式化代码" })
