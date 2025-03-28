local opts = {
  ensure_installed = {
    -- Web development
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "php",
    
    -- Config files
    "json",
    "yaml",
    "toml",
    "dockerfile",
    
    -- Programming languages
    "lua",
    "python",
    "c",
    "cpp",
    "go",
    
    -- Markup
    "markdown",
    "markdown_inline",
    
    -- Git
    "git_config",
    "git_rebase",
    "gitcommit",
    "gitignore",
    
    -- Others
    "vim",
    "query",
    "regex",
    "bash"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

return opts
