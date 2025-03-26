require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"
local init = nvlsp.on_init
local attach = nvlsp.on_attach
local capabilities = nvlsp.capabilities

local function documentHighlight(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local servers = {
  "bashls",
  "docker_compose_language_service",
  "dockerls",
  "html",
  "prismals",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_init = init,
    on_attach = function(client, bufnr)
      attach(client, bufnr)
      documentHighlight(client, bufnr)
    end,
    capabilities = capabilities,
  }
end

lspconfig.clangd.setup {
  on_init = init,
  on_attach = function(client, bufnr)
    attach(client, bufnr)
    documentHighlight(client, bufnr)
  end,
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
}

lspconfig.emmet_language_server.setup {
  on_init = init,
  on_attach = function(client, bufnr)
    attach(client, bufnr)
    documentHighlight(client, bufnr)
  end,
  capabilities = capabilities,
  filetypes = {
    "css",
    "eruby",
    "html",
    "htmlangular",
    "htmldjango",
    "javascriptreact",
    "less",
    "php",
    "pug",
    "sass",
    "scss",
    "typescriptreact",
  },
}

lspconfig.ts_ls.setup {
  on_init = init,
  on_attach = function(client, bufnr)
    attach(client, bufnr)
    documentHighlight(client, bufnr)
  end,
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
}

lspconfig.intelephense.setup {
  on_init = init,
  on_attach = function(client, bufnr)
    attach(client, bufnr)
    documentHighlight(client, bufnr)
  end,
  capabilities = capabilities,
  init_options = {
    globalStoragePath = ".intelephense",
  },
  settings = {
    intelephense = {
      telemerty = {
        enabled = false,
      },
    },
  },
}

lspconfig.gopls.setup {
  on_init = init,
  on_attach = function(client, bufnr)
    attach(client, bufnr)
    documentHighlight(client, bufnr)
  end,
  capabilities = capabilities,
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

lspconfig.cssls.setup {
  on_init = init,
  on_attach = function(client, bufnr)
    attach(client, bufnr)
    documentHighlight(client, bufnr)
  end,
  capabilities = capabilities,
  settings = {
    css = {
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
}

lspconfig.pylsp.setup {
  on_init = init,
  on_attach = function(client, bufnr)
    attach(client, bufnr)
    documentHighlight(client, bufnr)
  end,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        mccabe = {
          threshold = 50,
        },
        pycodestyle = {
          ignore = { "E501", "W503" },
          maxLineLength = 120,
        },
      },
    },
  },
}

lspconfig.tailwindcss.setup {
  on_init = init,
  on_attach = function(client, bufnr)
    attach(client, bufnr)
    documentHighlight(client, bufnr)
  end,
  capabilities = capabilities,
  filetypes = {
    "aspnetcorerazor",
    "astro",
    "astro-markdown",
    "blade",
    "clojure",
    "css",
    "django-html",
    "edge",
    "eelixir",
    "ejs",
    "elixir",
    "erb",
    "eruby",
    "gohtml",
    "gohtmltmpl",
    "haml",
    "handlebars",
    "hbs",
    "heex",
    "html",
    "html-eex",
    "htmlangular",
    "htmldjango",
    "jade",
    "javascript",
    "javascriptreact",
    "leaf",
    "less",
    "liquid",
    "mdx",
    "mustache",
    "njk",
    "nunjucks",
    "php",
    "postcss",
    "razor",
    "reason",
    "rescript",
    "sass",
    "scss",
    "slim",
    "stylus",
    "sugarss",
    "svelte",
    "templ",
    "twig",
    "typescript",
    "typescriptreact",
    "vue",
  },
}
