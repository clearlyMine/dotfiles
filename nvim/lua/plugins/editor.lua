return {
  {
    -- FOCUS MODE
    'shortcuts/no-neck-pain.nvim',
    version = '*',
    config = function()
      local nnp = require 'no-neck-pain'
      vim.keymap.set('n', '<leader>zz', nnp.toggle, { desc = 'Toggle NoNeckPain' })
      vim.keymap.set('n', '<leader>zi', '<Cmd>NoNeckPainWidthUp<cr>', { desc = 'Increase Width NoNeckPain' })
      vim.keymap.set('n', '<leader>zd', '<Cmd>NoNeckPainWidthDown<cr>', { desc = 'Decrease Width NoNeckPain' })
      -- vim.keymap.set('n', '<leader>zs', nnp.scratchPad, { desc = 'Focus Scratchpad NoNeckPain' })

      nnp.setup {
        width = 120,
        buffers = {
          right = {
            enabled = false,
          },
        },
      }
    end,
  },

  {
    -- CODE FOLDING
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      vim.o.foldcolumn = '0' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      --
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
      }
      local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
          require('lspconfig')[ls].setup({
              capabilities = capabilities
              -- you can add other fields for setting up lsp server in this table
          })
      end
      require('ufo').setup()
    end,
  },

  {
    -- INDENTATION AUTOPAIRING
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },

  {
    -- SEARCH NOTES/TODOS IN TELESCOPE
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = 'nvim-lua/plenary.nvim',
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },

  {
    -- BETTER COMMENTING
    'numToStr/Comment.nvim',
    opts = {},
  },

  {
    -- CODE ACTIONS POPUP
    'weilbith/nvim-code-action-menu',
    config = function()
      vim.keymap.set('n', '<leader>ca', '<Cmd>CodeActionMenu<CR>', { noremap = true, desc = 'code action menu' })
      vim.g.code_action_menu_window_border = 'single'
    end,
  },

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  {
    'roobert/surround-ui.nvim',
    dependencies = {
      'kylechui/nvim-surround',
      'folke/which-key.nvim',
    },
    config = function()
      require('surround-ui').setup {
        root_key = 'T',
      }
    end,
  },
}
