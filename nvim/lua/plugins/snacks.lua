return {
  "folke/snacks.nvim",
  opts = {
    -- Ensure the explorer is enabled
    explorer = {
      enabled = true,
      -- You might have other explorer-specific settings here
    },
    picker = {
      -- This 'hidden' option applies to the *global* picker if not overridden by sources.
      -- However, for the explorer, it's better to configure it specifically in its source.
      -- hidden = true, -- You might see this recommended, but the source-specific one is more precise for the explorer.
      sources = {
        explorer = {
          hidden = true,
          no_ignore = true,
          -- Other explorer picker source options
          -- layout = { preset = "default", preview = false },
          -- follow_file = true,
          -- tree = true,
        },
        -- You might have other picker sources configured here (e.g., 'files', 'live_grep')
        -- For example, for the general 'files' picker (often bound to <leader>ff):
        files = {
          hidden = true, -- Also show hidden files in the general file picker
        },
      },
    },
    -- Other snacks options (dashboard, bigfile, etc.) can go here
  },
}
