# LazyVim

<!--toc:start-->
- [LazyVim](#lazyvim)
  - [Quick tips](#quick-tips)
    - [Functional](#functional)
    - [Java, Kotlin, and Gradle](#java-kotlin-and-gradle)
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

### Java, Kotlin, and Gradle

Java uses [jdtls](https://github.com/eclipse-jdtls/eclipse.jdt.ls) through
[nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls). Kotlin uses JetBrains'
official, IntelliJ-based [Kotlin LSP](https://github.com/Kotlin/kotlin-lsp), which
is currently alpha. The first project import can take a while, especially for a
large multi-module build.

Launch Neovim from a shell where SDKMAN has selected the desired JDK. Language
servers and Gradle tasks inherit that shell's `JAVA_HOME`. `jdtls` itself uses an
installed SDKMAN Java 21 because newer JDKs can be incompatible with its Eclipse
runtime, while its Gradle importer still uses the project JDK selected by SDKMAN.
All installed SDKMAN JDKs are registered with `jdtls`, allowing Gradle toolchains
to resolve their standard libraries. JDT's Gradle Kotlin support is enabled so
Java sources can resolve Kotlin classes in mixed-language modules. Set
`JDTLS_JAVA_HOME` to override the Java 21 runtime lookup. Gradle commands always
use the project's `./gradlew`; a global Gradle installation is not required. The
Gradle 9.4 wrapper used by current projects is explicitly trusted so `jdtls` can
import them without an interactive checksum prompt.

#### Gradle and tasks

| Shortcut | Action |
| --- | --- |
| `<leader>og` | Prompt for any Gradle task and arguments, then run it with `./gradlew` |
| `<leader>ob` | Run `./gradlew build` |
| `<leader>oT` | Run `./gradlew test` |
| `<leader>oo` | Choose and run an Overseer task |
| `<leader>ow` | Toggle the Overseer task list |
| `<leader>ot` | Choose an action for an existing task |

The free-form Gradle prompt accepts project-specific commands such as
`componentTest`, `integrationTest --tests '*SomeTest'`, or `spotlessApply`.

#### Tests and debugging

| Shortcut | Action |
| --- | --- |
| `<leader>tt` | Java: run the current test class; other supported languages: run the current test file |
| `<leader>tr` | Run the nearest test |
| `<leader>tT` | Java: pick a test; other supported languages: run all tests |
| `<leader>td` | Debug the nearest Neotest-supported test through DAP |
| `<leader>tl` | Run the last Neotest test again |
| `<leader>ts` | Toggle the Neotest summary |
| `<leader>to` | Show test output |
| `<leader>tO` | Toggle the test output panel |
| `<leader>tS` | Stop the running test |

Java's test mappings are supplied by `nvim-jdtls` and support JUnit tests.
Gradle remains the reliable common test runner for mixed Java/Kotlin projects.

#### JVM editing

| Shortcut | Action |
| --- | --- |
| `<leader>co` | Organize imports |
| `<leader>ca` | Show code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cxm` | Java: extract selected code to a method |
| `<leader>cxv` | Java: extract selected code to a variable |
| `<leader>cxc` | Java: extract selected code to a constant |
| `<leader>cgs` | Java: go to the super implementation |
| `<leader>cgS` | Java: go to test subjects |
| `<leader>cl` | Show attached language servers |
| `gd` | Go to definition |
| `gr` | Find references |
| `gI` | Go to implementation |
| `K` | Show hover documentation |

Navigation into dependencies first uses attached source JARs when available.
When source is unavailable, `gd` opens a read-only decompiled buffer: Java
navigation uses CFR through `jdtls`, while Kotlin navigation uses JetBrains
Kotlin LSP's built-in decompiler for its `jar:/` and `jrt:/` virtual documents.

For Gradle builds that declare Spotless in a build script, settings file, or
version catalog, Java and Kotlin formatting use the project's `spotlessApply`
task. Standalone `ktlint` diagnostics are disabled in those projects to avoid
conflicting Kotlin rules. Kotlin projects without Spotless fall back to `ktlint`;
Java projects without Spotless fall back to JDTLS formatting.

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
