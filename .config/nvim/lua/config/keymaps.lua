-- Key mappings configuration
local opts = { noremap = true, silent = true }

-- System clipboard copy and paste
vim.api.nvim_set_keymap('v', '<Leader>y', '"+y', opts)
vim.api.nvim_set_keymap('n', '<Leader>p', '"+p', opts)
vim.api.nvim_set_keymap('v', '<Leader>p', '"+p', opts)

-- quickbuffer
vim.api.nvim_set_keymap('n', '<Leader>b',":Qb<CR>" ,opts)

-- Toggle NvimTree
vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<CR>', opts)

-- Nav
vim.keymap.set('n', '<C-m>', '<C-d>', opts)

vim.keymap.set("n", "<C-p>", "<cmd>Picker<CR>", { desc = "Open Picker" })

