-- Autocomplete popup. Pinned to v1 — v2 is under active development with breaking changes
-- and requires the separate blink.lib package.
return {
  "saghen/blink.cmp",
  version = "1.*",
  opts = {
    keymap = {
      preset = "default", -- <Tab>/<S-Tab> navigate, <CR> accept, <C-Space> open
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
