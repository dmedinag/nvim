return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        keys = {
          { "<leader>t", "", desc = "+test" },
          { "<leader>ta", "<cmd>GoTest<CR>", desc = "Run all tests" },
          { "<leader>tf", "<cmd>GoTest -v<CR>", desc = "Run tests for file" },
          { "<leader>tF", "<cmd>GoTest -v -F<CR>", desc = "Run tests for file (floating term)" },
          { "<leader>tp", "<cmd>GoTest -p<CR>", desc = "Run tests for package" },
          { "<leader>tP", "<cmd>GoTest -p -F<CR>", desc = "Run tests for package (floating term)" },
          { "<leader>tc", "<cmd>GoCoverage -p<CR>", desc = "Run tests for file (w/coverage)" },
          { "<leader>a", "<cmd>lua require('go.alternate').switch(true, 'vsplit')<CR>", desc = "Open test file" },

          { "<leader>ce", "<cmd>GoRun<CR>", desc = "Execute" },

          { "<leader>cb", "", desc = "+build" },
          { "<leader>cba", "<cmd>GoBuild<CR>", desc = "Build all" },
          { "<leader>cbf", "<cmd>GoBuild %<CR>", desc = "Build (current file)" },
          { "<leader>cbp", "<cmd>GoBuild %:h<CR>", desc = "Build (current package)" },
        },
      },
    },
  },
}
