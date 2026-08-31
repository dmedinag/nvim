-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- escape with kj
map("i", "kj", "<Esc>", { desc = "Escape" })

map("n", "<leader>fd", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Current buffer has no file", vim.log.levels.WARN)
    return
  end

  Snacks.terminal(nil, { cwd = vim.fs.dirname(file) })
end, { desc = "Terminal (File Dir)" })

-- BUFFER MOTIONS
-- Move to previous/next
map("n", "<M-,>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Focus previous buffer" })
map("n", "<M-.>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Focus next buffer" })
map("n", "≤", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Focus previous buffer" })
map("n", "≥", "<Cmd>BufferLineCycleNext<CR>", { desc = "Focus next buffer" })
-- Re-order to previous/next
map("n", "<M-S-,>", "<Cmd>BufferLineMovePrev<CR>", { desc = "Reorder buffer to the left" })
map("n", "<M-S-.>", "<Cmd>BufferLineMoveNext<CR>", { desc = "Reorder buffer to the right" })
map("n", "¯", "<Cmd>BufferLineMovePrev<CR>", { desc = "Reorder buffer to the left" })
map("n", "˘", "<Cmd>BufferLineMoveNext<CR>", { desc = "Reorder buffer to the right" })
-- Magic buffer-picking mode
map("n", "<leader>bc", "<Cmd>BufferLinePick<CR>", { desc = "Magic buffer chooser" })
-- Goto buffer in position...
map("n", "<M-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", { desc = "Focus buffer in position 1" })
map("n", "<M-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", { desc = "Focus buffer in position 2" })
map("n", "<M-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", { desc = "Focus buffer in position 3" })
map("n", "<M-4>", "<Cmd>BufferLineGoToBuffer 4<CR>", { desc = "Focus buffer in position 4" })
map("n", "<M-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", { desc = "Focus buffer in position 5" })
map("n", "<M-6>", "<Cmd>BufferLineGoToBuffer 6<CR>", { desc = "Focus buffer in position 6" })
map("n", "<M-7>", "<Cmd>BufferLineGoToBuffer 7<CR>", { desc = "Focus buffer in position 7" })
map("n", "<M-8>", "<Cmd>BufferLineGoToBuffer 8<CR>", { desc = "Focus buffer in position 8" })
map("n", "<M-9>", "<Cmd>BufferLineGoToBuffer 9<CR>", { desc = "Focus buffer in position 9" })
map("n", "<M-0>", "<Cmd>BufferLineGoToBuffer -1<CR>", { desc = "Focus last buffer" })
map("n", "¡", "<Cmd>BufferLineGoToBuffer 1<CR>", { desc = "Focus buffer in position 1" })
map("n", "™", "<Cmd>BufferLineGoToBuffer 2<CR>", { desc = "Focus buffer in position 2" })
map("n", "£", "<Cmd>BufferLineGoToBuffer 3<CR>", { desc = "Focus buffer in position 3" })
map("n", "¢", "<Cmd>BufferLineGoToBuffer 4<CR>", { desc = "Focus buffer in position 4" })
map("n", "∞", "<Cmd>BufferLineGoToBuffer 5<CR>", { desc = "Focus buffer in position 5" })
map("n", "§", "<Cmd>BufferLineGoToBuffer 6<CR>", { desc = "Focus buffer in position 6" })
map("n", "¶", "<Cmd>BufferLineGoToBuffer 7<CR>", { desc = "Focus buffer in position 7" })
map("n", "•", "<Cmd>BufferLineGoToBuffer 8<CR>", { desc = "Focus buffer in position 8" })
map("n", "ª", "<Cmd>BufferLineGoToBuffer 9<CR>", { desc = "Focus buffer in position 9" })
map("n", "º", "<Cmd>BufferLineGoToBuffer -1<CR>", { desc = "Focus last buffer" })

-- GO
map("n", "<leader>cg", function()
  Snacks.terminal({ "go", "run", "." }, { cwd = LazyVim.root() })
end, { desc = "Go Run" })

map("n", "<leader>cb", function()
  local cwd = vim.fn.getcwd()
  local root = LazyVim.root()
  local ok, err = xpcall(function()
    vim.fn.chdir(root)
    vim.cmd.compiler("go")
    vim.cmd.make({ args = { "./..." }, bang = true })
  end, debug.traceback)
  vim.fn.chdir(cwd)

  if not ok then
    error(err)
  elseif vim.v.shell_error == 0 then
    vim.notify("Go build succeeded", vim.log.levels.INFO)
  elseif #vim.fn.getqflist() > 0 then
    vim.cmd.copen()
  else
    vim.notify("Go build failed without parsed errors", vim.log.levels.ERROR)
  end
end, { desc = "Go Build" })

-- UNDOTREE
map("n", "<F5>", "<Cmd>UndotreeToggle<CR>", { desc = "Toggle undo tree" })
