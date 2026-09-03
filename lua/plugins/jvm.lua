local function gradle_root()
  local file = vim.api.nvim_buf_get_name(0)
  local start = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
  return vim.fs.root(start, "gradlew")
end

local spotless_cache = {}

local function valid_java_home(path)
  if not path or path == "" then
    return nil
  end

  local resolved = vim.uv.fs_realpath(vim.fn.expand(path))
  if resolved and vim.fn.executable(resolved .. "/bin/java") == 1 then
    return resolved
  end
end

local function add_java_home(candidates, seen, path)
  local resolved = valid_java_home(path)
  if resolved and not seen[resolved] then
    seen[resolved] = true
    table.insert(candidates, resolved)
  end
end

local function asdf_java_home()
  if vim.fn.executable("asdf") ~= 1 then
    return
  end

  local output = vim.fn.systemlist({ "asdf", "where", "java" })
  if vim.v.shell_error == 0 then
    return output[1]
  end
end

local function java_homes()
  local candidates = {}
  local seen = {}
  local sdkman = vim.env.SDKMAN_CANDIDATES_DIR or vim.fn.expand("~/.sdkman/candidates")
  local asdf = vim.env.ASDF_DATA_DIR or vim.fn.expand("~/.asdf")

  add_java_home(candidates, seen, vim.env.JDTLS_JAVA_HOME)
  add_java_home(candidates, seen, vim.env.JAVA_HOME)
  add_java_home(candidates, seen, asdf_java_home())
  add_java_home(candidates, seen, sdkman .. "/java/current")

  for _, path in ipairs(vim.fn.glob(sdkman .. "/java/*", false, true)) do
    add_java_home(candidates, seen, path)
  end
  for _, path in ipairs(vim.fn.glob(asdf .. "/installs/java/*", false, true)) do
    add_java_home(candidates, seen, path)
  end

  return candidates
end

local function jdtls_java()
  local configured = valid_java_home(vim.env.JDTLS_JAVA_HOME)
  if configured then
    return configured .. "/bin/java"
  end

  local candidates = {}
  for _, path in ipairs(java_homes()) do
    if vim.fs.basename(path):match("21") then
      table.insert(candidates, path)
    end
  end
  table.sort(candidates)
  for i = #candidates, 1, -1 do
    return candidates[i] .. "/bin/java"
  end
end

local function project_java_home()
  return valid_java_home(vim.env.JAVA_HOME)
    or valid_java_home(asdf_java_home())
    or valid_java_home((vim.env.SDKMAN_CANDIDATES_DIR or vim.fn.expand("~/.sdkman/candidates")) .. "/java/current")
end

local function jdtls_runtimes()
  local runtimes = {}
  local seen = {}

  for _, path in ipairs(java_homes()) do
    local resolved = vim.uv.fs_realpath(path)
    local version = vim.fs.basename(path):match("^(%d+)")
      or vim.fs.basename(path):match("[^%d](%d+)")
    if resolved and version and not seen[resolved] and vim.fn.executable(resolved .. "/bin/java") == 1 then
      seen[resolved] = true
      table.insert(runtimes, {
        name = version == "8" and "JavaSE-1.8" or "JavaSE-" .. version,
        path = resolved,
      })
    end
  end

  return runtimes
end

local function open_kotlin_virtual_document(args)
  local client = vim.lsp.get_clients({ name = "kotlin_lsp" })[1]
  if not client then
    return
  end

  local response = client:request_sync("workspace/executeCommand", {
    command = "decompile",
    arguments = { args.match },
  }, 10000, args.buf)

  local result = response and response.result
  local lines
  local filetype = "java"
  if result and type(result.code) == "string" then
    lines = vim.split(result.code, "\n", { plain = true })
    filetype = result.language or filetype
  else
    local message = response and response.err and response.err.message or "Kotlin LSP returned no decompiled source"
    message = tostring(message)
    lines = { "// Failed to decompile this library class.", "// " .. message }
    vim.notify(message, vim.log.levels.ERROR, { title = "Kotlin LSP" })
  end

  vim.bo[args.buf].modifiable = true
  vim.bo[args.buf].swapfile = false
  vim.bo[args.buf].buftype = "nofile"
  vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
  vim.bo[args.buf].filetype = filetype
  vim.bo[args.buf].readonly = true
  vim.bo[args.buf].modifiable = false
  vim.bo[args.buf].modified = false
  vim.lsp.buf_attach_client(args.buf, client.id)
end

local function setup_kotlin_virtual_documents()
  vim.api.nvim_create_autocmd("BufReadCmd", {
    group = vim.api.nvim_create_augroup("kotlin-lsp-virtual-documents", { clear = true }),
    pattern = { "jar:/*", "jrt:/*" },
    callback = open_kotlin_virtual_document,
    desc = "Decompile Kotlin LSP library classes",
  })
end

local function uses_spotless(filename)
  local root = vim.fs.root(filename, "gradlew")
  if not root then
    return false
  elseif spotless_cache[root] ~= nil then
    return spotless_cache[root]
  end

  local patterns = {
    "**/build.gradle",
    "**/build.gradle.kts",
    "**/settings.gradle",
    "**/settings.gradle.kts",
    "**/libs.versions.toml",
  }
  for _, pattern in ipairs(patterns) do
    for _, path in ipairs(vim.fn.globpath(root, pattern, false, true)) do
      local ok, lines = pcall(vim.fn.readfile, path)
      if ok and table.concat(lines, "\n"):lower():find("spotless", 1, true) then
        spotless_cache[root] = true
        return true
      end
    end
  end

  spotless_cache[root] = false
  return false
end

local function run_gradle(args, raw)
  local root = gradle_root()
  if not root or vim.fn.filereadable(root .. "/gradlew") == 0 then
    vim.notify("No Gradle wrapper found for the current project", vim.log.levels.ERROR)
    return
  end

  local overseer = require("overseer")
  local command = raw and "./gradlew " .. args or vim.list_extend({ "./gradlew" }, args)
  local description = raw and args or table.concat(args, " ")
  local task = overseer.new_task({
    name = "Gradle " .. description,
    cmd = command,
    cwd = root,
    components = {
      { "on_output_quickfix", open = false },
      "default",
    },
  })
  task:start()
  overseer.open({ enter = false })
end

return {
  {
    "neovim/nvim-lspconfig",
    init = setup_kotlin_virtual_documents,
    opts = {
      servers = {
        -- LazyVim's Kotlin extra still defaults to the deprecated fwcd server.
        kotlin_language_server = { enabled = false },
        kotlin_lsp = { single_file_support = false },
        gradle_ls = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "kotlin-lsp",
        "kotlin-debug-adapter",
        "gradle-language-server",
        "vscode-java-decompiler",
      },
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      local java = jdtls_java()
      if java then
        vim.list_extend(opts.cmd, { "--java-executable=" .. java })
      end

      local mason = vim.fn.stdpath("data") .. "/mason"
      local homebrew_jdtls = "/opt/homebrew/bin/jdtls"
      opts.cmd[1] = vim.fn.executable(homebrew_jdtls) == 1 and homebrew_jdtls or mason .. "/bin/jdtls"
      opts.cmd[2] = "--jvm-arg=-javaagent:" .. mason .. "/share/jdtls/lombok.jar"

      -- Keep the language server on Java 21, but import Gradle with the selected project JDK.
      local project_java = project_java_home()
      if project_java then
        opts.settings.java.import = {
          gradle = { java = { home = project_java } },
        }
      end
      opts.settings.java.configuration = {
        runtimes = jdtls_runtimes(),
        updateBuildConfiguration = "automatic",
      }
      opts.settings.java.jdt = {
        ls = { kotlinSupport = { enabled = true } },
      }
      opts.settings.java.imports = {
        gradle = {
          wrapper = {
            checksums = {
              { sha256 = "7d3a4ac4de1c32b59bc6a4eb8ecb8e612ccd0cf1ae1e99f66902da64df296172", allowed = true },
            },
          },
        },
      }

      -- Basenames alone collide when two checked-out projects share a directory name.
      opts.project_name = function(root_dir)
        return root_dir and vim.fs.basename(root_dir) .. "-" .. vim.fn.sha256(root_dir):sub(1, 8) .. "-v2"
      end
      opts.settings.java.contentProvider = { preferred = "cfr" }
      opts.settings.java.eclipse = { downloadSources = true }
      opts.settings.java.maven = { downloadSources = true }
      opts.jdtls = function(config)
        local decompiler_bundles = vim.fn.glob(mason .. "/share/vscode-java-decompiler/bundles/*.jar", false, true)
        vim.list_extend(config.init_options.bundles, decompiler_bundles)
        config.init_options.settings = config.settings
        return config
      end
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ktlint = {
          condition = function(ctx)
            if uses_spotless(ctx.filename) then
              vim.diagnostic.reset(require("lint").get_namespace("ktlint"), 0)
              return false
            end
            return true
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        java = function(bufnr)
          local filename = vim.api.nvim_buf_get_name(bufnr)
          return uses_spotless(filename) and { "spotless_gradle" } or {}
        end,
        kotlin = function(bufnr)
          local filename = vim.api.nvim_buf_get_name(bufnr)
          return uses_spotless(filename) and { "spotless_gradle" } or { "ktlint" }
        end,
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    keys = {
      {
        "<leader>og",
        function()
          vim.ui.input({ prompt = "Gradle task and arguments: " }, function(input)
            if input and input ~= "" then
              run_gradle(input, true)
            end
          end)
        end,
        desc = "Gradle Task",
      },
      {
        "<leader>ob",
        function()
          run_gradle({ "build" })
        end,
        desc = "Gradle Build",
      },
      {
        "<leader>oT",
        function()
          run_gradle({ "test" })
        end,
        desc = "Gradle Test",
      },
    },
  },
}
