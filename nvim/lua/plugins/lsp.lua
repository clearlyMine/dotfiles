return {
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       opts = {} },

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
          local map = function(modes, keys, func, opts)
            vim.keymap.set(modes, keys, func, opts)
          end
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

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. They will be passed to
      --  the `settings` field of the server config. You must look up that documentation yourself.
      --
      --  If you want to override the default filetypes that your language server will attach to you can
      --  define the property 'filetypes' to the map in question.
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        rust_analyzer = {},
        -- tsserver = {},
        -- html = { filetypes = { 'html', 'twig', 'hbs'} },

        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      -- This is done to make sure lazy-loading works correctly
      require('mason').setup()

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require 'lspconfig'.solidity_ls_nomicfoundation.setup {}

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            -- on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          }
        end,
      }
    end,
  },
}
