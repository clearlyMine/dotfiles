return {
  -- indent guides for Neovim
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    -- event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require("ibl").setup({
        enabled = true,
        debounce = 200,
        indent = {
          char = "┊",
          tab_char = "┊",
          smart_indent_cap = true,
          priority = 2,
        },
        whitespace = { remove_blankline_trail = true },
        -- Note: Scope requires treesitter to be set up
        scope = {
          enabled = true,
          char = "┃",
          show_start = false,
          show_end = false,
          injected_languages = true,
          priority = 1000,
          include = {
            node_type = {
              ["*"] = {
                "argument_list",
                "arguments",
                "assignment_statement",
                "Block",
                "chunk",
                "class",
                "ContainerDecl",
                "dictionary",
                "do_block",
                "do_statement",
                "element",
                "except",
                "FnCallArguments",
                "for",
                "for_statement",
                "function",
                "function_declaration",
                "function_definition",
                "if_statement",
                "IfExpr",
                "IfStatement",
                "import",
                "InitList",
                "list_literal",
                "method",
                "object",
                "ParamDeclList",
                "repeat_statement",
                "selector",
                "SwitchExpr",
                "table",
                "table_constructor",
                "try",
                "tuple",
                "type",
                "var",
                "while",
                "while_statement",
                "with",
              },
            },
          },
        },
        exclude = {
          filetypes = {
            "", -- for all buffers without a file type
            "alpha",
            "big_file_disabled_ft",
            "dashboard",
            "dotooagenda",
            "flutterToolsOutline",
            "fugitive",
            "git",
            "gitcommit",
            "help",
            "json",
            "log",
            "markdown",
            "NvimTree",
            "Outline",
            "peekaboo",
            "startify",
            "TelescopePrompt",
            "todoist",
            "txt",
            "undotree",
            "vimwiki",
            "vista",
          },
          buftypes = { "terminal", "nofile", "quickfix", "prompt" },
        },
      })
    end,
    opts = {
      -- -- char = "▏",
      -- char = '┊',
      -- filetype_exclude = {
      --   'help',
      --   'alpha',
      --   'dashboard',
      --   'neo-tree',
      --   'Trouble',
      --   'lazy',
      --   'mason',
      --   'notify',
      --   'toggleterm',
      --   'lazyterm',
      -- },
      -- show_trailing_blankline_indent = false,
      -- show_current_context = false,
    },
  },

  -- -- Active indent guide and indent text objects. When you're browsing
  -- -- code, this highlights the current level of indentation, and animates
  -- -- the highlighting.
  -- {
  --   'echasnovski/mini.indentscope',
  --   version = false, -- wait till new 0.7.0 release to put it back on semver
  --   event = { 'BufReadPre', 'BufNewFile' },
  --   opts = {
  --     -- symbol = "▏",
  --     symbol = '│',
  --     options = { try_as_border = true },
  --   },
  --   init = function()
  --     vim.api.nvim_create_autocmd('FileType', {
  --       pattern = {
  --         'help',
  --         'alpha',
  --         'dashboard',
  --         'neo-tree',
  --         'Trouble',
  --         'lazy',
  --         'mason',
  --         'notify',
  --         'toggleterm',
  --         'lazyterm',
  --       },
  --       callback = function()
  --         vim.b.miniindentscope_disable = true
  --       end,
  --     })
  --   end,
  -- },
}
