-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

-- escape with kj
map({ "n", "v", "i" }, "kj", "<Esc>", { remap = false, desc = "kj for escape" })

-- BUFFER MOTIONS
-- Move to previous/next
map("n", "≤", "<Cmd>BufferPrevious<CR>", { remap = false, desc = "Focus previous buffer" })
map("n", "≥", "<Cmd>BufferNext<CR>", { remap = false, desc = "Focus next buffer" })
-- Re-order to previous/next
map("n", "¯", "<Cmd>BufferMovePrevious<CR>", { remap = false, desc = "Reorder buffer to the left" })
map("n", "˘", "<Cmd>BufferMoveNext<CR>", { remap = false, desc = "Reorder buffer to the right" })
-- Magic buffer-picking mode
map("n", "<leader>bc", "<Cmd>BufferPick<CR>", { remap = false, desc = "Magic buffer chooser" })
-- Goto buffer in position...
map("n", "¡", "<Cmd>BufferGoto 1<CR>", { remap = false, desc = "Focus buffer in position 1" })
map("n", "™", "<Cmd>BufferGoto 2<CR>", { remap = false, desc = "Focus buffer in position 2" })
map("n", "£", "<Cmd>BufferGoto 3<CR>", { remap = false, desc = "Focus buffer in position 3" })
map("n", "¢", "<Cmd>BufferGoto 4<CR>", { remap = false, desc = "Focus buffer in position 4" })
map("n", "∞", "<Cmd>BufferGoto 5<CR>", { remap = false, desc = "Focus buffer in position 5" })
map("n", "§", "<Cmd>BufferGoto 6<CR>", { remap = false, desc = "Focus buffer in position 6" })
map("n", "¶", "<Cmd>BufferGoto 7<CR>", { remap = false, desc = "Focus buffer in position 7" })
map("n", "•", "<Cmd>BufferGoto 8<CR>", { remap = false, desc = "Focus buffer in position 8" })
map("n", "ª", "<Cmd>BufferGoto 9<CR>", { remap = false, desc = "Focus buffer in position 9" })
map("n", "º", "<Cmd>BufferLast<CR>", { remap = false, desc = "Focus buffer in position 9" })

-- GO CONFIG
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  callback = function(ev)
    -- CTRL/control keymaps
    vim.api.nvim_buf_set_keymap(0, "n", "<C-i>", ":GoImports<CR>", {})
    vim.api.nvim_buf_set_keymap(0, "n", "<C-b>", ":GoBuild %:h<CR>", {}) -- build current package
    vim.api.nvim_buf_set_keymap(0, "n", "<C-t>", ":GoTest -v -F<CR>", {}) -- go test -v current file
    vim.api.nvim_buf_set_keymap(0, "n", "<C-c>", ":GoCoverage -p<CR>", {}) -- test current file with coverage

    -- Opens test files
    vim.api.nvim_buf_set_keymap(0, "n", "A", ":lua require('go.alternate').switch(true, '')<CR>", {}) -- Test
    vim.api.nvim_buf_set_keymap(0, "n", "V", ":lua require('go.alternate').switch(true, 'vsplit')<CR>", {}) -- Test Vertical
  end,
  group = vim.api.nvim_create_augroup("go_autocommands", { clear = true }),
})
