local api = vim.api
local devicons_present, devicons = pcall(require, "nvim-web-devicons")
local fn = vim.fn

local function new_hl(group1, group2)
  local fg = fn.synIDattr(fn.synIDtrans(fn.hlID(group1)), "fg#")
  local bg = fn.synIDattr(fn.synIDtrans(fn.hlID(group2)), "bg#")
  api.nvim_set_hl(0, "Tabline" .. group1, { fg = fg, bg = bg })
  return "%#" .. "Tabline" .. group1 .. "#"
end

local function getBufName(bufnr)
  local file = vim.fn.bufname(bufnr)
  local buftype = vim.fn.getbufvar(bufnr, "&buftype")
  local filetype = vim.fn.getbufvar(bufnr, "&filetype")

  if filetype == "TelescopePrompt" then
    return "Telescope"
  end

  if filetype == "dashboard" then
    return "Dashboard"
  end

  if filetype == "nvcheatsheet" then
    return "Cheatsheet"
  end

  if buftype == "terminal" then
    local _, mtch = string.match(file, "term:(.*):(%a+)")
    return mtch ~= nil and mtch or vim.fn.fnamemodify(vim.env.SHELL, ":t")
  end

  local fullname = file == "" and "[No Name]" or file
  -- Return full path instead of just filename
  return fullname == "" and "[No Name]" or fullname
end

local function add_fileInfo(name, bufnr)
  if not devicons_present then return name end
  
  local icon, icon_hl = devicons.get_icon(name, string.match(name, "%a+$"))

  if not icon then
    icon, icon_hl = devicons.get_icon "default_icon"
  end

  -- Format with buffer number if enabled
  local number_prefix = ""
  if vim.g.nvchad_tabufline_show_numbers then
    number_prefix = bufnr .. ". "
  end

  -- Get just the filename for display
  local display_name = vim.fn.fnamemodify(name, ":t")
  
  -- Construct the final name with icon
  local final_name = number_prefix .. (icon and icon .. " " or "") .. display_name

  return new_hl(icon_hl, "TbLineBg") .. final_name
end

local function style_buffer_tab(nr)
  local name = getBufName(nr)
  name = add_fileInfo(name, nr) or name
  local close_btn = "%@TbKillBuf@%X" .. nr .. "󰅖%X"
  
  -- Simple left-aligned format with minimal padding
  return " " .. name .. " " .. close_btn .. " "
end

local M = {}

M.run = function()
  local result = new_hl("TbLineBg", "Normal") .. " "
  local current = api.nvim_get_current_buf()
  local buffers = vim.t.bufs or {}

  if #buffers == 0 then
    return result .. "%#TbLineBg#"
  end

  -- Don't use any centering or special formatting
  for _, nr in ipairs(buffers) do
    if api.nvim_buf_is_valid(nr) then
      if nr == current then
        result = result .. "%#TbLineSel#" .. style_buffer_tab(nr)
      else
        result = result .. "%#TbLine#" .. style_buffer_tab(nr)
      end
    end
  end

  return result
end

vim.api.nvim_create_user_command("TbKillBuf", function(opts)
  local nr = tonumber(opts.args)
  if nr then
    vim.api.nvim_buf_delete(nr, {})
  end
end, { nargs = 1 })

return M


