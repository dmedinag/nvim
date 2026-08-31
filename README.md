# LazyVim

<!--toc:start-->
- [LazyVim](#lazyvim)
  - [Quick tips](#quick-tips)
    - [Functional](#functional)
    - [Appearance](#appearance)
  - [Arch Linux prerequisites](#arch-linux-prerequisites)
<!--toc:end-->

`dmedinag`'s LazyVim config.

## Quick tips

### Functional

- Leader = space for me
- Search keymaps with `<leader>sk` (Search Key maps)
- Picker wired up with ~telescope~[fzf-lua](https://github.com/ibhagwan/fzf-lua)
- Buffer navigation uses [bufferline.nvim](https://github.com/akinsho/bufferline.nvim): `Alt-,`/`Alt-.` on Linux or `Option-,`/`Option-.` on macOS move between buffers; the corresponding Shift combinations reorder them; and modifier + `1` through `0` selects a position or the last buffer
- Run the current Go project with `<leader>cg` (`go run .` at the project root)
- Build all Go packages with `<leader>cb` (`go build ./...`); failures open in the quickfix list
- File tree with [neotree](https://github.com/nvim-neo-tree/neo-tree.nvim), use `?` when inside to see how to do things like find, add, remove files.
- Surround enabled with [mini surround](https://github.com/echasnovski/mini.surround), default config
- Find docs on any referred plugin with `<leader>sh` (Search Help)
- When in doubt, type slowly. [which-key](https://github.com/folke/which-key.nvim) will load up on incomplete commands when typing slowly.

### Appearance

- [`gruvbox.nvim`](https://github.com/ellisonleao/gruvbox.nvim) with overrides that preserve the original dark Gruvbox appearance while adding modern Treesitter and LSP highlights
- [mini.animate](https://github.com/echasnovski/mini.animate) enabled, I find it useful for `<C-d>` and `<C-u>`. Easily disable with `<leader>ua`
- preview color schemes with `<leader>uC`, inspect other UI-related shortcuts with which-key halting on `<leader>u`

## Arch Linux prerequisites

Install the editor's baseline command-line dependencies:

```sh
sudo pacman -S neovim git base-devel ripgrep fd fzf unzip curl wget
```

For the system clipboard, install `wl-clipboard` on Wayland or `xclip`/`xsel` on X11. Configure a Nerd Font in the terminal, and install the language runtimes used by the enabled extras (notably Go, Node.js/npm, Rust, a JDK, Python, and Terraform).

After provisioning a machine, run `:checkhealth`, `:LazyHealth`, and inspect `:Mason` for missing external tools.
