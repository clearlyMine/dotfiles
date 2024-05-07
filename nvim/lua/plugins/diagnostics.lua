return {
  {
    -- LSP DIAGNOSTICS
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
    keys = {
      { '<leader>xc', '<Cmd>TroubleClose<CR>',                        desc = 'Trouble Close' },
      { '<leader>xx', '<Cmd>TroubleToggle document_diagnostics<CR>',  desc = 'Document Diagnostics (Trouble)' },
      { '<leader>xw', '<Cmd>TroubleToggle workspace_diagnostics<CR>', desc = 'Workspace Diagnostics (Trouble)' },
      { '<leader>xr', '<Cmd>TroubleToggle lsp_references<CR>',        desc = 'LSP References (Trouble)' },
      { '<leader>xq', '<Cmd>TroubleToggle quickfix<CR>',              desc = 'Quickfix List (Trouble)' },
      { '<leader>xl', '<Cmd>TroubleToggle loclist<CR>',               desc = 'Location List (Trouble)' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').previous { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous trouble/quickfix item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next { skip_groups = true, jump = true }
            -- else
            --   local ok, err = pcall(vim.cmd.cnext)
            --   -- if not ok then
            --   vim.notify(err, vim.log.levels.ERROR)
            -- end
          end
        end,
        desc = 'Next trouble/quickfix item',
      },
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
