-- ============================================================================
-- Neovim entry point. Loaded automatically on every launch.
-- ============================================================================

-- Leader keys MUST be set before lazy.nvim loads (plugins read them at setup)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Sensible defaults
vim.opt.number = true             -- show line numbers
vim.opt.relativenumber = true     -- relative line numbers (nice for jumps like 5j)
vim.opt.expandtab = true          -- spaces, not tabs
vim.opt.shiftwidth = 4            -- 4-space indent
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.ignorecase = true         -- case-insensitive search...
vim.opt.smartcase = true          -- ...unless query has uppercase
vim.opt.termguicolors = true      -- 24-bit colour
vim.opt.signcolumn = "yes"        -- always show sign column (no jitter on diagnostics)
vim.opt.scrolloff = 8             -- keep 8 lines visible above/below cursor
vim.opt.updatetime = 250          -- faster CursorHold (diagnostic popups)
vim.opt.clipboard = "unnamedplus" -- system clipboard

-- ============================================================================
-- Bootstrap lazy.nvim (auto-installs on first launch)
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load every spec under lua/plugins/
require("lazy").setup({ import = "plugins" })

-- ============================================================================
-- Auto-cd each window to the git root of its current file
-- (window-local, so splits from different repos coexist fine)
-- ============================================================================
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    -- Skip special buffers (terminal, help, telescope picker, etc.)
    if vim.bo[args.buf].buftype ~= "" then return end

    local file = vim.api.nvim_buf_get_name(args.buf)
    if file == "" or not vim.uv.fs_stat(file) then return end

    local dir = vim.fs.dirname(file)
    local git_marker = vim.fs.find(".git", { upward = true, path = dir })[1]
    if not git_marker then return end

    local root = vim.fs.dirname(git_marker)
    -- Only call lcd if we're not already there (avoids redundant E472 noise)
    if vim.fn.getcwd(0) ~= root then
      vim.cmd("silent! lcd " .. vim.fn.fnameescape(root))
    end
  end,
})
