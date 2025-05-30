return {
  {
    "catppuccin/nvim",
    name = "catppuccin", -- LazyVim uses this name to find the theme specified in its main `opts.colorscheme`.
    -- Alternatively, if you set `opts.colorscheme = "catppuccin-mocha"`,
    -- LazyVim might correctly infer it. Using a consistent `name` is safer.
    lazy = true,
    priority = 1000, -- Ensures it loads early
    opts = {
      flavour = "mocha", -- Should match the 'catppuccin-mocha' if that's what you used elsewhere
      -- All your theme-specific customizations go here:
      custom_highlights = function()
        return {
          -- For docstrings (e.g., /** docstring */)
          ["@comment.documentation"] = {
            italic = true,
            bold = true,
            -- fg = colors.sky, -- Optional: specific color
          },

          -- For keywords (to make them NOT italic)
          -- ["@keyword"] = { italic = false },
          -- ["@keyword.function"] = { italic = false },
          -- ["@keyword.operator"] = { italic = false },
          -- ["@conditional"] = { italic = false },
          -- ["@repeat"] = { italic = false },
          -- ["@storageclass"] = { italic = false },
          -- ["@type.definition"] = { italic = false },
          -- ["@include"] = { italic = false },
          -- ["Keyword"] = { italic = false }, -- Fallback traditional group
        }
      end,
      -- Add any other Catppuccin options you need
    },
    -- No `config` function is usually needed here if LazyVim's `opts.colorscheme`
    -- handles the `vim.cmd.colorscheme` call. If you find the theme isn't applying,
    -- you might add one, but try without it first.
    -- config = function(_, opts)
    --   require("catppuccin").setup(opts)
    --   vim.cmd.colorscheme(opts.flavour)
    -- end,
  },
  {
    "Shatur/neovim-ayu",
    lazy = true, -- Lazy-load the plugin
    priority = 1000, -- Ensure it loads early
    config = function()
      -- Optional: Configure Ayu theme options here
      -- You can use `require('ayu').setup()` to set options.
      -- Refer to the plugin's GitHub page for all available options:
      -- https://github.com/Shatur/neovim-ayu#configuration

      require("ayu").setup({
        -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
        mirage = true,
        -- Set to `false` to let terminal manage its own colors.
        -- terminal = true,
        -- Example of overriding colors (uncomment and modify as needed):
        -- overrides = {
        --   Normal = { bg = "none" }, -- For a transparent background
        --   NormalFloat = { bg = "none" },
        --   -- You can also use functions for dynamic overrides based on background:
        --   -- overrides = function()
        --   --   if vim.o.background == 'dark' then
        --   --     return { NormalNC = {bg = '#0f151e', fg = '#808080'} }
        --   --   else
        --   --     return { NormalNC = {bg = '#f0f0f0', fg = '#808080'} }
        --   --   end
        --   -- end
        -- },
      })

      -- Ensure termguicolors is enabled for true colors
      vim.opt.termguicolors = true
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ayu", -- Set Ayu as the default colorscheme for LazyVim
    },
  },
}
