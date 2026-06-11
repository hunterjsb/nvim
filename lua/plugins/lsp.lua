-- LSP stack: mason (binary installer) + mason-lspconfig (bridge) + nvim-lspconfig (server defaults).
-- Requires Neovim 0.11+ (uses vim.lsp.config / vim.lsp.enable).

return {
  -- Mason: downloads & manages LSP / formatter / linter binaries
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  -- Bridges Mason ↔ nvim-lspconfig. With automatic_enable (default),
  -- it calls vim.lsp.enable() for each installed server — no handlers loop needed.
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- basedpyright + ruff are installed via brew (Mason's pip install fails against
      -- the Gnosis private CodeArtifact pip index). nvim-lspconfig picks them up from PATH.
      ensure_installed = {
        "vtsls",   -- TypeScript / JavaScript (faster ts_ls)
        "eslint",  -- JS/TS linter
        "gopls",   -- Go
        "lua_ls",  -- Lua (your nvim config itself)
      },
    },
  },

  -- LSP server configs + keymaps fired on attach
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Hand off Python hover: ruff stays silent on hover, basedpyright owns it.
      vim.lsp.config("ruff", {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })

      -- basedpyright + ruff aren't Mason-installed (see ensure_installed comment),
      -- so mason-lspconfig won't auto-enable them. Enable them explicitly from PATH.
      vim.lsp.enable({ "basedpyright", "ruff" })

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gr", vim.lsp.buf.references, "Find references")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "K", vim.lsp.buf.hover, "Hover docs")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")
        end,
      })
    end,
  },
}
