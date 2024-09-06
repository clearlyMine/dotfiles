return {
  -- CAMEL CASE MOTION SUPPORT
  {
    'bkad/CamelCaseMotion',
    config = function()
      vim.keymap.set('', 'w', '<Plug>CamelCaseMotion_w', { silent = true })
      vim.keymap.set('', 'b', '<Plug>CamelCaseMotion_b', { silent = true })
      vim.keymap.set('', 'e', '<Plug>CamelCaseMotion_e', { silent = true })
      vim.keymap.set('', 'ge', '<Plug>CamelCaseMotion_ge', { silent = true })
    end,
  },

  -- MOVE LINES AROUND
  {
    'fedepujol/move.nvim',
    config = function()
      require('move').setup {
        char = { enable = true },
      }
    end,
  },

  -- USE TAB TO GET OUT OF BLOCKS
  {
    'abecodes/tabout.nvim',
    config = function()
      require('tabout').setup {
        tabkey = '<Tab>',             -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true,            -- shift content if tab out is not possible
        act_as_shift_tab = false,     -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = '<C-t>',        -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = '<C-d>',  -- reverse shift default action,
        enable_backwards = true,      -- well ...
        completion = true,            -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = '`', close = '`' },
          { open = '(', close = ')' },
          { open = '[', close = ']' },
          { open = '{', close = '}' },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
        opt = true,   -- Set this to true if the plugin is optional
      }
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'L3MON4D3/LuaSnip',
      'hrsh7th/nvim-cmp',
    },
    event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
    priority = 1000,
  },
}
