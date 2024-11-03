return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        keys = {
          { "<leader>ctA", "<cmd>GoTest<CR>", desc = "Run all tests" },
          { "<leader>ctf", "<cmd>GoTest -v<CR>", desc = "Run tests for file" },
          { "<leader>ctF", "<cmd>GoTest -v -F<CR>", desc = "Run tests for file (floating term)" },
          { "<leader>ctf", "<cmd>GoTest -p<CR>", desc = "Run tests for package" },
          { "<leader>ctF", "<cmd>GoTest -p -F<CR>", desc = "Run tests for package (floating term)" },
          { "<leader>cta", "<cmd>lua require('go.alternate').switch(true, 'vsplit')<CR>", desc = "Open test file" },

          { "<leader>ctcf", "<cmd>GoCoverage -p<CR>", desc = "Run tests for file (w/coverage)" },

          { "<leader>ce", "<cmd>GoRun<CR>", desc = "Execute" },

          { "<leader>cbp", "<cmd>GoBuild %:h<CR>", desc = "Build package (w/coverage)" },
        },
      },
    },
  },
}
