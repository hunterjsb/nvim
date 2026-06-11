-- noice.nvim: routes the cmdline, messages, and notifications through a nicer UI.
-- nui.nvim is required; nvim-notify drives the notification popups.
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      -- Use Treesitter to render LSP markdown (hover/signature) instead of the default.
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = true,        -- classic bottom cmdline for / and ?
      command_palette = true,      -- cmdline + popupmenu together, centered
      long_message_to_split = true, -- long :messages open in a split
      lsp_doc_border = true,       -- bordered hover/signature popups
    },
  },
}
