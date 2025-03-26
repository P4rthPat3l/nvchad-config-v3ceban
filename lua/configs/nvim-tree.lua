local opts = {
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  view = {
    adaptive_size = true,  -- This will make the width adapt to the content
    width = {
      min = 25,  -- Minimum width
      max = 50,  -- Maximum width
    },
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        folder_arrow = false,  -- Cleaner look without arrows
      },
    },
  },
}

return opts
