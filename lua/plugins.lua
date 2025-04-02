return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional: for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      require("scrollbar").setup({
        show = true,
        handle = {
          text = " ",
          color = "#a1b1c1",
          hide_if_all_visible = true,
        },
        marks = {
          Search = { color = "#ff0000" },
          Error = { color = "#ff0000" },
          Warn = { color = "#ffaa00" },
          Info = { color = "#00ff00" },
          Hint = { color = "#0000ff" },
          Misc = { color = "#888888" },
        },
      })
    end,
  },
  {
    "tpope/vim-abolish",
    cmd = { "Abolish", "Subvert" },
    keys = { "cr" },
  },
  {
    "yetone/avante.nvim",
    event = "User",
    build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = require "configs.avante",
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      return require "configs.cmp"
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    build = function()
      -- For Windows, download and extract manually
      if vim.fn.has('win32') == 1 then
        local install_path = vim.fn.stdpath("data") .. "/codeium"
        local version = "1.6.3"  -- Update this version as needed
        local binary_path = install_path .. "/codeium_language_server.exe"
        
        -- Create directory if it doesn't exist
        vim.fn.mkdir(install_path, "p")
        
        -- Download URL for Windows
        local url = string.format(
          "https://github.com/Exafunction/codeium/releases/download/language-server-v%s/language_server_windows_x64.exe",
          version
        )
        
        -- Download the binary
        if not vim.loop.fs_stat(binary_path) then
          vim.fn.system({
            "powershell",
            "-Command",
            string.format(
              "Invoke-WebRequest -Uri '%s' -OutFile '%s'",
              url,
              binary_path
            )
          })
        end
      end
    end,
    cmd = "Codeium",
    config = function()
      -- Create required directories
      local data_path = vim.fn.stdpath("data")
      local codeium_path = data_path .. "/codeium"
      local config_path = codeium_path .. "/config.json"

      -- Create directories if they don't exist
      vim.fn.mkdir(codeium_path, "p")

      -- Override the gunzip function
      local io = require("codeium.io")
      io.gunzip = function(gz_path, out_path)
        local cmd = string.format([["%ProgramFiles%\7-Zip\7z.exe" e -y -o"%s" "%s"]], 
          vim.fn.fnamemodify(out_path, ":h"), 
          gz_path)
        local handle = io.popen(cmd)
        if handle then
          handle:close()
        end
        return true
      end

      local codeium = require("codeium")
      codeium.setup({
        bin_path = codeium_path,
        config_path = config_path,
        config = {
          tools = {
            language_server = {
              command = "codeium_language_server.cmd",
            },
          },
        },
      })

      -- Register the command properly
      vim.api.nvim_create_user_command("Codeium", function(opts)
        local args = opts.fargs
        if args[1] == "Auth" then
          -- Ensure plugin is loaded before authentication
          require("lazy").load({ plugins = { "codeium.nvim" } })
          local Server = require("codeium.api")
          Server.authenticate()
        end
      end, {
        nargs = 1,
        complete = function()
          return { "Auth" }
        end,
      })
    end,
  },
  {
    "stevearc/dressing.nvim",
    init = function() -- lazy load on vim.ui.select call only
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
    end,
    opts = require "configs.dressing",
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = require "configs.flash",
  },
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    version = "*",
    config = require "configs.git-conflict",
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = require "configs.nvim-tree",
  },
  {
    "airblade/vim-matchquote",
    keys = { "%" },
  },
  {
    "antonk52/markdowny.nvim",
    ft = { "markdown", "copilot-chat", "Avante" },
    config = function()
      require("markdowny").setup()
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "copilot-chat", "Avante" },
    opts = require "configs.render-markdown",
  },
  {
    "christoomey/vim-sort-motion",
    keys = {
      { "gs", mode = { "n", "v", "x" } },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    keys = {
      { "cs", mode = { "n" } },
      { "ds", mode = { "n" } },
      { "ys", mode = { "n" } },
      { "s",  mode = { "v", "x" } },
    },
    config = function()
      return require("configs.surround").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = require "configs.telescope",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "configs.treesitter",
  },
  {
    "windwp/nvim-ts-autotag",
    ft = require("configs.ts-autotag").ft,
    config = function()
      require("configs.ts-autotag").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = require "configs.which-key",
  },
}
