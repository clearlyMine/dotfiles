return {
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    lazy = false,   -- This plugin is already lazy
    ft = { 'rust' },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          -- register which-key mappings
          local wk = require 'which-key'
          wk.register({
            ['K'] = {
              function()
                vim.cmd.RustLsp { 'hover', 'actions' }
              end,
              'Rust: Hover Actions',
            },
            ['<leader>cR'] = {
              function()
                vim.cmd.RustLsp 'codeAction'
              end,
              'Rust: Code Action',
            },
            ['<leader>cr'] = {
              function()
                vim.cmd.RustLsp 'codeAction'
              end,
              'Rust: Code Action',
            },
            ['<leader>dr'] = {
              function()
                vim.cmd.RustLsp 'debuggables'
              end,
              'Rust: Rust debuggables',
            },
            ['<leader>de'] = {
              function()
                vim.cmd.RustLsp 'explainError'
              end,
              'Rust: Explain error',
            },
            ['<leader>rgo'] = {
              function()
                vim.cmd.RustLsp 'openCargo'
              end,
              'Rust: Open Cargo.toml',
            },
          }, { mode = 'n', buffer = bufnr })
          wk.register({
            ['K'] = {
              function()
                vim.cmd.RustLsp { 'hover', 'range' }
              end,
              'Rust: Hover Actions (Range)',
            },
          }, { mode = 'v', buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = 'clippy',
              extraArgs = { '--no-deps' },
            },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend('force', {}, opts or {})
    end,
  },

  -- Extend auto completion
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    -- dependencies = { 'nvim-lua/plenary.nvim' },
    tag = 'stable',
    config = function()
      require('crates').setup {
        null_ls = {
          enabled = true,
          name = 'crates.nvim',
        },
      }
    end,
  },

  -- Add Rust & related to treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'ron', 'rust', 'toml' })
    end,
  },

  {
    'nvim-neotest/neotest',
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.adapters or {}, {
        require 'rustaceanvim.neotest',
      })
    end,
  },
}
