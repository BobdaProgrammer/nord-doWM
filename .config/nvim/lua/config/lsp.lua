local cmp = require('cmp')

-- Diagnostics
vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
        spacing = 4,
    },
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
})

vim.api.nvim_set_keymap('n', '<C-e>', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

-- Shared on_attach
local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,  opts)
    vim.keymap.set('n', 'K',          vim.lsp.buf.hover,        opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,       opts)
    vim.keymap.set('n', '<C-f>',      vim.lsp.buf.code_action,  opts)
    vim.keymap.set('n', '<C-d>',      vim.lsp.buf.hover,        opts)
    vim.keymap.set('n', '<C-Space>',  vim.lsp.buf.completion,   opts)
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        on_attach(vim.lsp.get_client_by_id(ev.data.client_id), ev.buf)
    end,
})

-- LSP servers
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("lua", true),
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})

vim.lsp.config('ts_ls', {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, bufnr)
    end,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    cmd = { "typescript-language-server", "--stdio" },
})

vim.lsp.config('tailwindcss', {
    filetypes = {
        "html", "css", "scss",
        "javascript", "javascriptreact",
        "typescript", "typescriptreact",
        "svelte", "vue", "astro", "gohtmltmpl",
    },
    init_options = {
        userLanguages = {
            typescript = "javascript",
            typescriptreact = "javascriptreact",
        },
    },
    settings = {
        tailwindCSS = {
            validate = true,
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidScreen = "error",
                invalidVariant = "error",
                invalidConfigPath = "error",
            },
            experimental = {
                classRegex = {
                    "class[:]?\\s*=?\\s*\"([^\"]*)\"",
                    "className[:]?\\s*=?\\s*\"([^\"]*)\"",
                },
            },
        },
    },
})

vim.lsp.config('gopls', {
    flags = { debounce_text_changes = 150 },
})

vim.lsp.config('zls', {
    flags = { debounce_text_changes = 150 },
})

vim.lsp.config('qmlls', {
    cmd = { "qmlls", "-E" },
})

vim.lsp.enable({
    'lua_ls',
    'ts_ls',
    'tailwindcss',
    'pyright',
    'gopls',
    'clangd',
    'zls',
    'qmlls',
})

-- flutter-tools manages its own LSP internally so still needs its own setup
require("flutter-tools").setup({
    lsp = { on_attach = on_attach },
})

-- Completion
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-Up>']    = cmp.mapping.select_prev_item(),
        ['<C-Down>']  = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>']     = cmp.mapping.abort(),
        ['<CR>']      = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    },
    window = {
        completion = {
            border = 'rounded',
            winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:CursorLine,Search:None',
            col_offset = 0,
            side_padding = 0,
        },
        documentation = {
            border = 'rounded',
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
        },
    },
})
