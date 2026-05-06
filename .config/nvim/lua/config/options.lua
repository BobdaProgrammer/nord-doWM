-- Options configuration
vim.wo.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.g.mapleader = " "
vim.opt.tabstop = 4        -- A tab character is 4 spaces wide
vim.opt.shiftwidth = 4     -- Indentation amount for < and >
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.softtabstop = 4    -- How many spaces a <Tab> counts for while editing
vim.o.ignorecase = true
vim.o.smartcase = true
-- Run gofmt/goimports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
