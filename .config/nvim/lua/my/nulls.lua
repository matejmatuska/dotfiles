local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.diagnostics.rstcheck,
        -- moved to none-ls extras null_ls.builtins.formatting.jq,

        -- Codespell
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.formatting.codespell,

        -- C/C++
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.diagnostics.cppcheck,

        -- Python
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.formatting.isort,
        --null_ls.builtins.formatting.black,
    },
})
