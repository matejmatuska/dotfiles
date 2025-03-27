local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

vim.api.nvim_create_autocmd('LspAttach', {
  -- group = vim.api.nvim_create_augroup('UserLspConfig', { clear = True }),
  callback = function(event)
    --vim.lsp.completion.enable(true, event.data.client_id, event.buf, { autotrigger = true })

    -- Enable completion triggered by <c-x><c-o>
    -- vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    local opts = { buffer = event.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [d]eclaration' })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Type [D]efinition'})
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = '[G]oto [I]mplementation' })
    -- should work ootb now, vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[N]ame'})
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]action' })
    vim.keymap.set({'n', 'v'}, '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, { desc = '[F]ormat'})

    -- workspace stuff
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = '[W]orkspace [A]dd folder' })
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = '[W]orkspace [R]emove folder'})
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = '[W]orkspace [L]ist folders' })


    local client = vim.lsp.get_client_by_id(event.data.client_id)
    -- inlay hints
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true) -- inlay hints on by default
        vim.keymap.set('n', '<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { desc = '[T]oggle Inlay [H]ints'})
    end

    -- symbol highlight
    -- TODO different highlight group for writes (underscore?)
    if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
        })
    end
  end
})

-- default capabilities - these get extended by LS specific ones
vim.lsp.config('*', {
    capabilities = capabilities,
})

vim.lsp.enable({ 'basedpyright', 'bashls' })
