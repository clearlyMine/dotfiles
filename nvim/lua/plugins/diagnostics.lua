return {
  {
    -- LSP DIAGNOSTICS
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',                        desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',           desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>',                desc = 'Symbols (Trouble)' },
      { '<leader>xr', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>',                            desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>',                             desc = 'Quickfix List (Trouble)' },
    },
  },

  {
    -- QUICKFIX IMPROVEMENTS
    --
    -- <Tab> to select items.
    -- zn to keep selected items.
    -- zN to filter selected items.
    -- zf to fuzzy search items.
    --
    -- <Ctrl-f> scroll down
    -- <Ctrl-b> scroll up
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  },

  -- {
  --   -- LSP VIRTUAL TEXT
  --   'https://git.sr.ht/~whynothugo/lsp_lines.nvim', -- See also: https://github.com/Maan2003/lsp_lines.nvim
  --   config = function()
  --     require('lsp_lines').setup()
  --
  --     -- disable virtual_text since it's redundant due to lsp_lines.
  --     vim.diagnostic.config { virtual_text = false }
  --   end,
  -- },

  {
    -- ADD MISSING DIAGNOSTICS HIGHLIGHT GROUPS
    'folke/lsp-colors.nvim',
    config = true,
  },

  {
    -- CODE ACTION LIGHTBULB
    'kosayoda/nvim-lightbulb',
    config = function()
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        pattern = '*',
        command = "lua require('nvim-lightbulb').update_lightbulb()",
      })
    end,
  },
}
