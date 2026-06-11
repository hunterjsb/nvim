-- Syntax highlighting & smart indentation.
-- On the "main" branch (required for Neovim 0.12+). The API differs from master:
-- parsers are installed via require("nvim-treesitter").install({...}), and highlight
-- is started per-buffer via an autocmd.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local ensure = {
      "lua", "vim", "vimdoc", "query",
      "python", "javascript", "typescript", "tsx",
      "go", "gomod", "gosum",
      "json", "yaml", "toml", "markdown", "markdown_inline",
      "bash", "html", "css",
    }
    require("nvim-treesitter").install(ensure)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and pcall(vim.treesitter.start, args.buf, lang) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
