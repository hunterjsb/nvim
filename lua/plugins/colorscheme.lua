-- Colorscheme. lazy=false + priority=1000 → loads before other plugins
-- so their UIs render with the right palette from the start.
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",        -- swap for "storm" | "moon" | "day"  (day = light theme)
    transparent = false,    -- true to let the terminal bg show through
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
