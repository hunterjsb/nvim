-- Format on save. Conform calls the right binary per filetype, falls back to LSP formatter if missing.
-- Non-LSP binaries (prettier, stylua, goimports, gofumpt) install via :Mason — see install list below.
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      python          = { "ruff_format", "ruff_organize_imports" },
      javascript      = { "prettier" },
      typescript      = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json            = { "prettier" },
      yaml            = { "prettier" },
      markdown        = { "prettier" },
      go              = { "goimports", "gofmt" },
      lua             = { "stylua" },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  },
  -- After first launch, run inside nvim:
  --   :Mason  → then install: prettier, stylua, goimports, gofumpt
}
