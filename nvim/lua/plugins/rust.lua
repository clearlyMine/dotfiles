return {
  {
    'simrat39/rust-tools.nvim',
    -- lazy = true,
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      -- format on save for rust files
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.rs' },
        command = 'lua vim.lsp.buf.format()',
      })

      -- local ok, mason_registry = pcall(require, 'mason-registry')
      -- if ok then
      local mason_registry = require 'mason-registry'
      -- rust tools configuration for debugging support
      local codelldb = mason_registry.get_package 'codelldb'
      local extension_path = codelldb:get_install_path() .. '/extension/'
      -- local extension_path = '/home/onion/.vscode-server/extensions/vadimcn.vscode-lldb-1.9.2/'
      local codelldb_path = extension_path .. 'adapter/codelldb'
      local liblldb_path = extension_path .. 'lldb/lib/liblldb'
      local this_os = vim.loop.os_uname().sysname

      -- The path in windows is different
      if this_os:find 'Windows' then
        codelldb_path = extension_path .. 'adapter\\codelldb.exe'
        liblldb_path = extension_path .. 'lldb\\bin\\liblldb.dll'
      else
        -- The liblldb extension is .so for linux and .dylib for macOS
        liblldb_path = liblldb_path .. (this_os == 'Linux' and '.so' or '.dylib')
      end
      -- end

      local opts = {
        dap = {
          adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        tools = {
          on_initialized = function()
            vim.cmd [[
                   augroup RustLSP
                     autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                     autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                     autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                   augroup END
                 ]]
          end,
        },
        server = {
          on_attach = function(_, bufnr)
            -- require("shared/lsp")(client, bufnr)
            local nmap = function(keys, func, desc, bufr)
              if desc then
                desc = 'LSP: ' .. desc
              end

              vim.keymap.set('n', keys, func, { buffer = bufr, desc = desc })
            end
            nmap('K', '<cmd>RustHoverActions<cr>', 'Hover Actions (Rust)', bufnr)
            nmap('J', '<cmd>RustJoinLines<cr>', 'Hover Actions (Rust)', bufnr)
            nmap('<leader>cR', '<cmd>RustCodeAction<cr>', 'Code Action (Rust)', bufnr)
            nmap('<leader>cr', '<cmd>RustRunnables<cr>', 'Rust runnables (Rust)', bufnr)
            nmap('<leader>dr', '<cmd>RustDebuggables<cr>', 'Run Debuggables (Rust)', bufnr)
            nmap('<leader>cgo', '<cmd>RustOpenCargo<cr>', 'Open Cargo.toml (Rust)', bufnr)
            nmap('<A-k>', '<cmd>RustMoveItemUp<cr>', 'Move item up (Rust)', bufnr)
            nmap('<A-j>', '<cmd>RustMoveItemDown<cr>', 'Move item down (Rust)', bufnr)
            nmap('J', '<cmd>RustJoinLines<cr>', 'Join lines (Rust)', bufnr)
          end,
        },
      }

      require('rust-tools').setup(opts)
    end,
  },

  -- Extend auto completion
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      require('crates').setup()
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- MANAGE CRATE DEPENDENCIES
      -- {
      'saecki/crates.nvim',
      -- event = { 'BufRead Cargo.toml' },
      -- config = true,
      -- },
    },
    opts = function(_, _)
      local cmp = require 'cmp'
      local config = cmp.get_config()
      table.insert(config.sources, { name = 'crates' })
      cmp.setup(config)
    end,
  },

  -- Add Rust & related to treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'ron', 'rust', 'toml' })
      end
    end,
  },

  -- Ensure Rust debugger is installed
  {
    'williamboman/mason.nvim',
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'codelldb' })
      end
    end,
  },

  -- -- Correctly setup lspconfig for Rust 🚀
  -- {
  --   'neovim/nvim-lspconfig',
  --   opts = {
  --     servers = {
  --       -- Ensure mason installs the server
  --       rust_analyzer = {
  --         settings = {
  --           ['rust-analyzer'] = {
  --             assist = {
  --               importEnforceGranularity = true,
  --               importPrefix = 'create',
  --             },
  --             cargo = {
  --               allFeatures = true,
  --               loadOutDirsFromCheck = true,
  --               runBuildScripts = true,
  --             },
  --             -- Add clippy lints for Rust.
  --             checkOnSave = {
  --               allFeatures = true,
  --               command = 'clippy',
  --               extraArgs = { '--no-deps' },
  --             },
  --             procMacro = {
  --               enable = true,
  --               ignored = {
  --                 ['async-trait'] = { 'async_trait' },
  --                 ['napi-derive'] = { 'napi' },
  --                 ['async-recursion'] = { 'async_recursion' },
  --               },
  --             },
  --           },
  --           inlayHints = {
  --             -- NOT SURE THIS IS VALID/WORKS 😬
  --             lifetimeElisionHints = {
  --               enable = true,
  --               useParameterNames = true,
  --             },
  --           },
  --         },
  --       },
  --       taplo = {
  --         keys = {
  --           {
  --             'K',
  --             function()
  --               if vim.fn.expand '%:t' == 'Cargo.toml' and require('crates').popup_available() then
  --                 require('crates').show_popup()
  --               else
  --                 vim.lsp.buf.hover()
  --               end
  --             end,
  --             desc = 'Show Crate Documentation',
  --           },
  --         },
  --       },
  --     },
  --     setup = {
  --       rust_analyzer = function(_, opts)
  --         local rust_tools_opts = require('lazyvim.util').opts 'rust-tools.nvim'
  --         require('rust-tools').setup(vim.tbl_deep_extend('force', rust_tools_opts or {}, { server = opts }))
  --         return true
  --       end,
  --     },
  --   },
  -- },

  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      'rouge8/neotest-rust',
    },
    opts = {
      adapters = {
        ['neotest-rust'] = {},
      },
    },
  },
}
