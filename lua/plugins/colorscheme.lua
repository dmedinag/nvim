return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
      invert_selection = true,
      contrast = "",
      overrides = {
        Operator = { link = "Normal" },
        SpecialKey = { link = "GruvboxBg2" },
        Todo = { fg = "#ebdbb2", bg = "#282828", bold = true, italic = false },
        DiffDelete = { fg = "#282828", bg = "#fb4934" },
        DiffAdd = { fg = "#282828", bg = "#b8bb26" },
        DiffChange = { fg = "#282828", bg = "#8ec07c" },
        DiffText = { fg = "#282828", bg = "#fabd2f" },
        GitSignsAdd = { link = "GruvboxGreenSign" },
        GitSignsChange = { link = "GruvboxOrangeSign" },
        GitSignsDelete = { link = "GruvboxRedSign" },
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
