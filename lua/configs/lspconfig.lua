require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"
local init = nvlsp.on_init
local attach = nvlsp.on_attach
local capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, {
  textDocument = {
    semanticTokens = {
      dynamicRegistration = false,
      multilineTokenSupport = false,
      tokenModifiers = {},
      tokenTypes = {},
    },
  },
})

local diagnostic_signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

-- Set diagnostic signs
for _, sign in ipairs(diagnostic_signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "always",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Add semantic highlighting
vim.api.nvim_set_hl(0, '@lsp.type.variable.unused', { fg = '#6c7086', italic = true })
vim.api.nvim_set_hl(0, '@lsp.type.parameter.unused', { fg = '#6c7086', italic = true })
vim.api.nvim_set_hl(0, '@lsp.mod.unused', { fg = '#6c7086', italic = true })

-- Make used variables more visible
vim.api.nvim_set_hl(0, '@lsp.type.variable', { fg = '#cdd6f4' }) -- Brighter color for used variables
vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg = '#f9e2af' }) -- Bright yellow for parameters

-- Add this to dim unused variables and imports
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens.start(args.buf, client)
    end
  end,
})

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
  settings = {
    typescript = {
      semanticTokens = true,
    },
    javascript = {
      semanticTokens = true,
    },
  },
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
