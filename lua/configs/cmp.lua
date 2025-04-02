local config = require "nvchad.configs.cmp"
local cmp = require "cmp"

config.mapping["<CR>"] = cmp.mapping.confirm {
  behavior = cmp.ConfirmBehavior.Insert,
  select = false,
}

config.completion = {
  completeopt = "menu,menuone,noselect,popup",
}

config.preselect = cmp.PreselectMode.None

-- Add Codeium as a source
table.insert(config.sources, {
  name = "codeium",
  priority = 1000, -- High priority to show suggestions first
})

return config
