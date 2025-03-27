vim.g.mapleader = ' '
--vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        "projekt0n/github-nvim-theme",
        name = 'github-theme',
        lazy = false,
        priority = 1000,
        config = function()
            require("github-theme").setup({
                options = {
                    hide_end_of_buffer = false,
                    hide_nc_statusline = false,
                },
            })

            vim.cmd.colorscheme('github_dark_dimmed')
        end,
    },
    {
        "github/copilot.vim",
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
        end,
    },
    {
        'lervag/vimtex',
        enabled = true,
        lazy = true,
        ft = 'tex',
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_complete_enabled = true

            vim.g.vimtex_fold_enabled = true
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "vimtex#fold#level(v:lnum)"
            vim.opt_local.foldtext = "vimtex#fold#text()"
            vim.opt_local.foldlevel = 2

            vim.opt_local.conceallevel = 2
        end
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            require("my/lsp")
        end
    },
    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        enabled = true,
        lazy = true,
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                dependencies = { 'rafamadriz/friendly-snippets' },
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end
            },
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-omni',
        },
        config = function()
            require("my/cmp")
        end
    },
    {
        'nvimtools/none-ls.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() require("my/nulls") end
    },
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            --'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        config = function()
            require("my/treesitter")
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
    },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                -- add = { text = '+' },
                -- change = { text = '~' },
                -- delete = { text = '_' },
                -- topdelete = { text = '‾' },
                -- changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gph', require('gitsigns').prev_hunk, {
                    buffer = bufnr, desc = '[G]o to [P]revious Hunk' }
                )
                vim.keymap.set('n', '<leader>gnh', require('gitsigns').next_hunk, {
                    buffer = bufnr, desc = '[G]o to [N]ext Hunk' }
                )
                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = '[P]review [H]unk' }
                )
                vim.cmd('redrawstatus!')
            end,
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup {
                defaults = {
                    layout_strategy = 'flex',
                    --path_display = {"truncate"},
                    wrap_results = true,
                    -- use vertical setup in small windows
                    layout_config = {
                        flex = {
                            flip_columns = 150,
                            width = 0.9,
                        },
                        horizontal = {
                            width = 0.9,
                        },
                        vertical = {
                            width = 0.9,
                        },
                    },
                },
            }
            -- Enable telescope fzf native, if installed
            pcall(require('telescope').load_extension, 'fzf')

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
            vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>/', function()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    -- winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            local function telescope_live_grep_open_files()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end
            vim.keymap.set('n', '<leader>so', telescope_live_grep_open_files, {
                desc = '[S]earch [/] in Open Files' }
            )
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 400
        end,
        opts = {
            preset = 'helix',
            icons = {
                breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
                separator = "➜", -- symbol used between a key and it's label
                group = "+", -- symbol prepended to a group
                ellipsis = "…",
                -- set to false to disable all mapping icons,
                -- both those explicitly added in a mapping
                -- and those from rules
                mappings = false,
                rules = false,
                keys = {
                    Up = " ",
                    Down = " ",
                    Left = " ",
                    Right = " ",
                    C = "Ctrl ",
                    M = "Alt ",
                    D = "D",
                    S = "Shift",
                    CR = "CR",
                    Esc = "ESC",
                    ScrollWheelDown = "󱕐 ",
                    ScrollWheelUp = "󱕑 ",
                    NL = "NL",
                    BS = "BS",
                    Space = "Space",
                    Tab = "Tab",
                    F1 = "F1",
                    F2 = "F2",
                    F3 = "F3",
                    F4 = "F4",
                    F5 = "F5",
                    F6 = "F6",
                    F7 = "F7",
                    F8 = "F8",
                    F9 = "F9",
                    F10 = "F10",
                    F11 = "F11",
                    F12 = "F12",
                }
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        'sainnhe/gruvbox-material',
        name = 'gruvbox-material',
        lazy = false,
        priority = 1000,
        init = function()
            vim.g.gruvbox_material_better_performance = 1
            -- Fonts
            vim.g.gruvbox_material_disable_italic_comment = 0
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_enable_bold = 0
            vim.g.gruvbox_material_transparent_background = 0
            -- Themes
            vim.g.gruvbox_material_foreground = 'mix'
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_ui_contrast = 'high' -- The contrast of line numbers, indent lines, etc.
            vim.g.gruvbox_material_float_style = 'bright' -- Background of floating windows
            vim.g.gruvbox_material_diagnostic_virtual_text = 'highlited'
            --vim.g.gruvbox_material_sign_column_background = 'grey'
        end
    },
    {
        "zenbones-theme/zenbones.nvim",
        priority = 1000,
        -- Optionally install Lush. Allows for more configuration or extending the colorscheme
        -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
        -- In Vim, compat mode is turned on as Lush only works in Neovim.
        dependencies = { "rktjmp/lush.nvim" }
    },
    'Yazeed1s/oh-lucy.nvim',
    -- 'Shatur/neovim-ayu',
    {
        "neanias/everforest-nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("everforest").setup({
                --sign_column_background = "grey",
                background = "hard",
                transparent_background_level = 1,
            })
        end,
    },
})

vim.opt.number = true
vim.opt.signcolumn = 'number'
vim.opt.title = true
vim.opt.termguicolors = true

vim.opt.showmode = false
vim.opt.cmdheight = 1
--vim.opt.showcmdloc = 'statusline'

function mode_highlight()
    local mode = vim.fn.mode()
    if mode == "i" then
        return "%#@comment.note#"
    else
        return "%#@comment.todo#"
    end
end

vim.opt.statusline = '%{%luaeval("mode_highlight()")%} %{toupper(mode())} %* %f %h%w%m%r'
vim.opt.statusline:append('%=')
vim.opt.statusline:append(' on: %{get(g:, "gitsigns_head", "none")} %=')
vim.opt.statusline:append('%3.s %8.(%l,%c%V%)')
vim.opt.statusline:append(' %{&fileencoding?&fileencoding:&encoding} [%{&fileformat}]')

vim.opt.autowrite = true

vim.opt.fileencoding = 'utf-8'

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4 -- when indenting with '>', use 4 spaces width
vim.opt.shiftround = true
vim.opt.expandtab = true -- On pressing tab, insert spaces

vim.opt.breakindent = true

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = '> '

vim.opt.smoothscroll = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

vim.opt.lazyredraw = true
vim.opt.updatetime = 100

vim.opt.undofile = true

-- search
vim.opt.smartcase = true -- Enable smart-case search
vim.opt.ignorecase = true -- Always case-insensitive

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.list = true
vim.opt.listchars = { tab = '• ', trail = '•', extends = '>', precedes = '<' }

-- netrw
vim.g.netrw_fastbrowse = 2
vim.g.netrw_keepj = "" -- do not disable jumplist modifications
vim.g.netrw_liststyle = 3 -- enable tree view
vim.g.netrw_banner = 0 -- hide banner

local highlight_yank_augroup = vim.api.nvim_create_augroup('highlight_yank', {clear = true})
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = '*',
    group = highlight_yank_augroup,
    callback=function() vim.highlight.on_yank({higroup='Visual', timeout=200}) end,
})

local textwidth_augroup = vim.api.nvim_create_augroup('textwidth', {clear = true})
vim.api.nvim_create_autocmd("FileType", {
    pattern = 'markdown,tex',
    group = textwidth_augroup,
    command = 'setlocal textwidth=80',
    command = 'setlocal formatexpr='
})

-- change terminal background to that of nvim
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then return end
    io.write(string.format("\027Ptmux;\027\027]11;#%06x\007\027\\", normal.bg))
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function()
    io.write("\027Ptmux;\027\027]111;\007\027\\")
    io.write("\027]111\027\\")
  end,
})


-- Terminal --------------------------------------------------------------------
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

local term_augroup = vim.api.nvim_create_augroup('terminal', {clear = true})
vim.api.nvim_create_autocmd("TermOpen", {
    group = term_augroup,
    callback = function(event)
        vim.opt_local.statusline = [[%{%luaeval("vim.api.nvim_buf_get_var(0, 'term_title')")%}]]
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end
})

vim.keymap.set({'n', 'v'}, '<leader>y', '"+y')

vim.api.nvim_create_user_command('Vterm', 'vsplit <Bar> term',
    {desc='Open terminal in new vertical split'}
)
vim.api.nvim_create_user_command('Sterm', 'split <Bar> term',
    {desc='Open terminal in new horizontal split'}
)
vim.api.nvim_create_user_command('Tterm', 'tabnew <Bar> term',
    {desc='Open terminal in new tab'}
)
-- Completion -----------------------------------------------------------------
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
--vim.opt.shortmess:remove('S')
--vim.opt.shortmess:append('c')

--vim.keymap.set('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
--vim.keymap.set('i', '<Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})

-- Diagnostics ----------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = { current_line = true }
})
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- LSP ------------------------------------------------------------------------
require("my/lsp")
