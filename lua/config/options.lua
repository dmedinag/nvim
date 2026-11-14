-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.winbar = "%=%m %F" -- absolute path in the top right of the buffer

-- Python editing uses LSP, not the optional pynvim remote-plugin host.
-- Avoid probing stale Python installations when loading Python's ftplugin.
vim.g.loaded_python3_provider = 0
