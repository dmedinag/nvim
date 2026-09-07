local map = vim.keymap.set

local function is_fence(line)
  return line:match("^%s*```") ~= nil
end

local function markdown_format_options()
  if vim.bo.filetype ~= "markdown" then
    return false
  end

  vim.opt_local.textwidth = 80
  vim.opt_local.formatoptions:append("j")
  vim.opt_local.formatexpr = ""
  return true
end

local function format_markdown(motion)
  if not markdown_format_options() then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local in_fence = false
  for line = 1, cursor_line do
    if is_fence(lines[line]) then
      if line == cursor_line then
        return
      end
      in_fence = not in_fence
    end
  end
  if in_fence then
    return
  end

  vim.cmd("normal! " .. motion)
end

local function table_cells(line)
  local content = line:gsub("^%s*|", ""):gsub("|%s*$", "")
  local cells = {}
  for _, cell in ipairs(vim.split(content, "|", { plain = true })) do
    cells[#cells + 1] = cell:match("^%s*(.-)%s*$")
  end
  return cells
end

local function is_table_delimiter(line)
  local cells = table_cells(line)
  if #cells < 2 then
    return false
  end

  for _, cell in ipairs(cells) do
    if not cell:match("^:?-+:?$") then
      return false
    end
  end
  return true
end

local function is_table_start(lines, line)
  return line < #lines and lines[line]:find("|", 1, true) ~= nil
    and is_table_delimiter(lines[line + 1])
end

local function format_table(lines)
  local rows = vim.tbl_map(table_cells, lines)
  local widths = {}

  for row_index, row in ipairs(rows) do
    if row_index ~= 2 then
      for column, cell in ipairs(row) do
        widths[column] = math.max(widths[column] or 0, vim.fn.strchars(cell))
      end
    end
  end

  local delimiter = rows[2]
  for column, cell in ipairs(delimiter) do
    local left = cell:match("^:") ~= nil
    local right = cell:match(":$") ~= nil
    local markers = (left and 1 or 0) + (right and 1 or 0)
    widths[column] = math.max(widths[column] or 0, 3 + markers)
  end

  local formatted = {}
  for row_index, row in ipairs(rows) do
    local cells = {}
    for column = 1, #widths do
      local cell = row[column] or ""
      if row_index == 2 then
        local left = cell:match("^:") ~= nil
        local right = cell:match(":$") ~= nil
        local hyphens = widths[column] - (left and 1 or 0) - (right and 1 or 0)
        cell = (left and ":" or "") .. string.rep("-", hyphens) .. (right and ":" or "")
      end
      cells[column] = cell .. string.rep(" ", widths[column] - vim.fn.strchars(cell))
    end
    formatted[#formatted + 1] = "| " .. table.concat(cells, " | ") .. " |"
  end
  return formatted
end

local function format_all_markdown()
  if not markdown_format_options() then
    return
  end

  local buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
  local blocks = {}
  local line = 1
  local in_fence = false

  while line <= #lines do
    if is_fence(lines[line]) then
      in_fence = not in_fence
      line = line + 1
    elseif in_fence or lines[line]:match("^%s*$") then
      line = line + 1
    elseif is_table_start(lines, line) then
      local finish = line + 2
      while finish <= #lines and lines[finish]:find("|", 1, true) ~= nil do
        finish = finish + 1
      end
      blocks[#blocks + 1] = { kind = "table", first = line, last = finish - 1 }
      line = finish
    else
      local first = line
      line = line + 1
      while line <= #lines
        and not lines[line]:match("^%s*$")
        and not is_fence(lines[line])
        and not is_table_start(lines, line)
      do
        line = line + 1
      end
      blocks[#blocks + 1] = { kind = "paragraph", first = first, last = line - 1 }
    end
  end

  for block = #blocks, 1, -1 do
    local item = blocks[block]
    if item.kind == "table" then
      local table_lines = vim.list_slice(lines, item.first, item.last)
      vim.api.nvim_buf_set_lines(buffer, item.first - 1, item.last, false, format_table(table_lines))
    else
      vim.cmd(("normal! %dGgq%dG"):format(item.first, item.last))
    end
  end
end

map("n", "<leader>mf", function()
  format_markdown("gqap")
end, { desc = "Format Markdown paragraph at 80 columns" })

map("n", "<leader>mF", format_all_markdown, { desc = "Format all Markdown paragraphs" })
