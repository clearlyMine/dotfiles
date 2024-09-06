local map = function(modes, keys, func, opts)
  vim.keymap.set(modes, keys, func, opts)
end

return {
  {
    'WhoIsSethDaniel/mason-tool-installer',
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = {
          'codelldb',
          'delve',
          'eslint-lsp',
          'gofumpt',
          'gomodifytags',
          'gopls',
          'impl',
          'lua-language-server',
          'prettierd',
          'tailwindcss-language-server',
          'typescript-language-server',
        },
      }
    end,
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufEnter', 'BufReadPre', 'BufNewFile', 'BufWritePre' },
    -- event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      {
        'folke/neodev.nvim',
        -- Setup neovim lua configuration
        config = function()
          require('neodev').setup()
        end,
      },
    },
    config = function()
      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end

            map('n', keys, func, { buffer = ev.buf, desc = desc })
          end
          local nvmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end

            map({ 'n', 'v' }, keys, func, { buffer = ev.buf, desc = desc })
          end

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          nvmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
          nvmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')

          nvmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
          nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')

          nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
          nvmap('gi', vim.lsp.buf.implementation, '[g]oto [i]mplementation')

          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove Folder')
          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[w]orkspace [l]ist Folders')

          nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
          nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')
          nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')
          nmap('<leader>cf', function()
            vim.lsp.buf.format { async = true }
          end, '[c]ode [f]ormat')

          -- See `:help K` for why this keymap
          nvmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
        end,
      })

      local servers = {
        -- clangd = {},
        eslint = {},
        gopls = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        -- pyright = {},
        solidity_ls_nomicfoundation = {},
        tailwindcss = {
          settings = {
            -- exclude a filetype from the default_config
            filetypes_exclude = { 'markdown' },
            -- add additional filetypes to the default_config
            filetypes_include = {},
            -- to fully override the default_config, change the below
            -- filetypes = {}

            -- setup = function(_, opts)
            --   local tw = require 'lspconfig.server_configurations.tailwindcss'
            --   opts.filetypes = opts.filetypes or {}
            --
            --   -- Add default filetypes
            --   vim.list_extend(opts.filetypes, tw.default_config.filetypes)
            --
            --   -- Remove excluded filetypes
            --   --- @param ft string
            --   opts.filetypes = vim.tbl_filter(function(ft)
            --     return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
            --   end, opts.filetypes)
            --
            --   -- Add additional filetypes
            --   vim.list_extend(opts.filetypes, opts.filetypes_include or {})
            -- end,
          },
        },
        tsserver = {},
        -- zls = {},
      }
      local solidity_root_files = {
        'hardhat.config.js',
        'hardhat.config.ts',
        'foundry.toml',
        'remappings.txt',
        'truffle.js',
        'truffle-config.js',
        'ape-config.yaml',
      }

      -- This is done to make sure lazy-loading works correctly
      require('mason').setup()

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      local lspconfig = require 'lspconfig'
      mason_lspconfig.setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = capabilities,
            filetypes = (servers[server_name] or {}).filetypes,
            settings = (servers[server_name] or {}).settings,
          }
        end,

        ['eslint'] = function()
          lspconfig['eslint'].setup {
            capabilities = capabilities,
            on_attach = function(_, bufnr)
              vim.api.nvim_create_autocmd('BufWritePre', {
                buffer = bufnr,
                command = 'EslintFixAll',
              })
            end,
            settings = { workingDirectories = { mode = 'auto' } },
          }
        end,

        ['gopls'] = function()
          lspconfig['gopls'].setup {
            capabilities = capabilities,
            keys = {
              -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
              { '<leader>td', "<cmd>lua require('dap-go').debug_test()<CR>", desc = 'Debug Nearest (Go)' },
            },
            on_attach = function(client, _)
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end,
            settings = {
              gopls = {
                gofumpt = true,
                codelenses = {
                  gc_details = false,
                  generate = true,
                  regenerate_cgo = true,
                  run_govulncheck = true,
                  test = true,
                  tidy = true,
                  upgrade_dependency = true,
                  vendor = true,
                },
                analyses = {
                  fieldalignment = true,
                  nilness = true,
                  unusedparams = true,
                  unusedwrite = true,
                  useany = true,
                },
                hints = {
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  constantValues = true,
                  functionTypeParameters = true,
                  parameterNames = true,
                  rangeVariableTypes = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
                semanticTokens = true,
              },
            },
          }
        end,

        ['rust_analyzer'] = function() end,

        ['solidity_ls_nomicfoundation'] = function()
          lspconfig['solidity_ls_nomicfoundation'].setup {
            capabilities = capabilities,
            cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
            filetypes = { 'solidity' },
            flags = {
              debounce_text_changes = 150,
            },
            root_dir = function()
              local util = require 'lspconfig.util'
              return util.root_pattern(unpack(solidity_root_files)) or util.root_pattern('.git', 'package.json')
            end,
            settings = {},
            single_file_support = true,
          }
        end,

        ['tailwindcss'] = function()
          lspconfig['tailwindcss'].setup {
            capabilities = capabilities,
            root_dir = function(...)
              return require('lspconfig.util').root_pattern '.git'(...)
            end,
          }
        end,

        ['tsserver'] = function()
          lspconfig['ts_ls'].setup {
            capabilities = capabilities,
            filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
            init_options = {
              preferences = {
                disableSuggestions = true,
              },
            },
            keys = {
              {
                '<leader>co',
                function()
                  vim.lsp.buf.code_action {
                    apply = true,
                    context = {
                      only = { 'source.organizeImports.ts' },
                      diagnostics = {},
                    },
                  }
                end,
                desc = 'Organize Imports',
              },
              {
                '<leader>cR',
                function()
                  vim.lsp.buf.code_action {
                    apply = true,
                    context = {
                      only = { 'source.removeUnused.ts' },
                      diagnostics = {},
                    },
                  }
                end,
                desc = 'Remove Unused Imports',
              },
            },
            root_dir = function(...)
              return require('lspconfig.util').root_pattern '.git'(...)
            end,
            ---@diagnostic disable-next-line: missing-fields
            settings = {
              completions = {
                completeFunctionCalls = true,
              },
              -- typescript = {
              --   inlayHints = {
              --     includeInlayParameterNameHints = 'literal',
              --     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              --     includeInlayFunctionParameterTypeHints = true,
              --     includeInlayVariableTypeHints = false,
              --     includeInlayPropertyDeclarationTypeHints = true,
              --     includeInlayFunctionLikeReturnTypeHints = true,
              --     includeInlayEnumMemberValueHints = true,
              --   },
              -- },
              -- javascript = {
              --   inlayHints = {
              --     includeInlayParameterNameHints = 'all',
              --     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              --     includeInlayFunctionParameterTypeHints = true,
              --     includeInlayVariableTypeHints = true,
              --     includeInlayPropertyDeclarationTypeHints = true,
              --     includeInlayFunctionLikeReturnTypeHints = true,
              --     includeInlayEnumMemberValueHints = true,
              --   },
              -- },
            },
          }
        end,
      }
    end,
    opts = {
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },

  {
    'nvimtools/none-ls.nvim',
    -- event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- opts = function(_, opts)
    opts = function()
      -- return require "custom.configs.null-ls"
      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      local nls = require 'null-ls'

      -- opts.sources = vim.list_extend(opts.sources or {}, {
      local opts = {
        sources = {
          -- nls.builtins.code_actions.refactoring,
          --------------
          -- Solidity --
          nls.builtins.diagnostics.solhint,
          --------------
          ----- Go -----
          nls.builtins.code_actions.gomodifytags,
          nls.builtins.code_actions.impl,
          nls.builtins.formatting.goimports,
          nls.builtins.formatting.gofumpt,
          --------------
          -- Tailwind --
          nls.builtins.formatting.rustywind,
          --------------
          ----- Lua ----
          nls.builtins.formatting.stylua,
          --------------
          nls.builtins.formatting.prettierd,
        },
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds {
              group = augroup,
              buffer = bufnr,
            }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
              end,
            })
          end
        end,
      }

      return opts
    end,
  },

  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'nvimtools/none-ls.nvim',
    },
    config = function()
      require('mason-null-ls').setup {
        ensure_installed = { 'goimports', 'prettierd', 'rustywind', 'stylua' },
        automatic_installation = true,
      }
    end,
  },
}
