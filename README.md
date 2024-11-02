# LazyVim

<!--toc:start-->
- [LazyVim](#lazyvim)
  - [Quick tips](#quick-tips)
    - [Functional](#functional)
    - [Appearance](#appearance)
<!--toc:end-->

`dmedinag`'s LazyVim config.

## Quick tips

### Functional

- Leader = space for me
- Search keymaps with `<leader>sk` (Search Key maps)
- Picker wired up with ~telescope~[fzf-lua](https://github.com/ibhagwan/fzf-lua)
- Buffer navigation configured with with [barbar](https://github.com/romgrk/barbar.nvim), classic key maps on on other editors but with Option instead of cmd
- File tree with [neotree](https://github.com/nvim-neo-tree/neo-tree.nvim), use `?` when inside to see how to do things like find, add, remove files.
- Surround enabled with [mini surround](https://github.com/echasnovski/mini.surround), default config
- Find docs on any referred plugin with `<leader>sh` (Search Help)
- When in doubt, type slowly. [which-key](https://github.com/folke/which-key.nvim) will load up on incomplete commands when typing slowly.

### Appearance

- [morhetz variance for `gruvbox`](https://github.com/morhetz/gruvbox) as theme, no further overrides
- [mini.animate](https://github.com/echasnovski/mini.animate) enabled, I find it useful for `<C-d>` and `<C-u>`. Easily disable with `<leader>ua`
- preview color schemes with `<leader>uC`, inspect other UI-related shortcuts with which-key halting on `<leader>u`
