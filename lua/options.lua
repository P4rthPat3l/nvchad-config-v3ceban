require "nvchad.options"

vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.incsearch = true
-- Set shell based on OS
if vim.fn.has('win32') == 1 then
  vim.opt.shell = "powershell"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellxquote = ""
else
  vim.opt.shell = "/bin/zsh"
end
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.g.markdown_recommended_style = 0
vim.g.copilot_no_tab_map = true
vim.opt.completeopt = "menu,menuone,noselect,popup"
vim.opt.scrolloff = 15
vim.opt.laststatus = 3

-- Add spacing on the right side of line numbers
vim.opt.numberwidth = 4  -- Keep numbers close to the left
vim.opt.statuscolumn = '%=%{v:relnum?v:relnum:v:lnum}  '  -- The spaces after %{} create right padding

-- buffer tabs
-- vim.opt.winwidth = 50    -- Further increases the width of window splits
-- vim.opt.winminwidth = 30 -- Increases the minimum width of windows
-- vim.opt.winheight = 30   -- Increases window height (optional)

vim.api.nvim_set_hl(0, "RenderMarkdownHeader", { fg = "#89b4fa" })
vim.api.nvim_set_hl(0, "RenderMarkdownTodo", { fg = "#f38ba8" })
vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { fg = "#fab387" })
-- higlight groups for avante and git-conflict
vim.api.nvim_set_hl(0, "DiffAddGroup", { bg = "#272a3f" })
vim.api.nvim_set_hl(0, "DiffTextGroup", { bg = "#1e2030" })

-- for better syntax highlighting in .env files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    ".env.*",
  },
  callback = function()
    vim.bo.filetype = "bash"
  end,
})

-- for docker-compose lsp
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "docker-compose*.yml",
    "docker-compose*.yaml",
    "*docker-compose.yml",
    "*docker-compose.yaml",
  },
  callback = function()
    vim.bo.filetype = "yaml.docker-compose"
  end,
})

-- close quickfix window after pressing enter
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>:cclose<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "o", "<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":cclose<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":cclose<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "d",
      ":call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}))<CR>:redraw!<CR>",
      { noremap = true, silent = true }
    )
  end,
})
