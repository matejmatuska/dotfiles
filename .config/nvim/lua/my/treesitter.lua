require'nvim-treesitter.configs'.setup {
  -- one of "all", "maintained" or a list of languages
  ensure_installed = { 'c', 'cpp', 'lua', 'rust', 'python', 'vimdoc', 'vim', 'bash' },
  autoinstall = false,
  ignore_install = { 'latex' },
  additional_vim_regex_highlighting = false,

  highlight = {
    enable = true,
    disable = { "latex" },
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
    disable = { "cpp", "latex" }
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
    disable = { "cpp" }
  },

  textobjects = {
    select = {
      enable = true,
      --disable = { "cpp" },
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
       }
    }
  },

  move = {
    enable = true,
    disable = { "cpp" },
    set_jumps = true, -- whether to set jumps in the jumplist
    goto_next_start = {
      [']m'] = '@function.outer',
      [']]'] = '@class.outer',
    },
    goto_next_end = {
      [']M'] = '@function.outer',
      [']['] = '@class.outer',
    },
    goto_previous_start = {
      ['[m'] = '@function.outer',
      ['[['] = '@class.outer',
    },
    goto_previous_end = {
      ['[M'] = '@function.outer',
      ['[]'] = '@class.outer',
    },
  },
}
