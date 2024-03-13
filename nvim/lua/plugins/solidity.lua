return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'
      local lsp_configs = require 'lspconfig.configs'
      local util = require 'lspconfig.util'
      local root_files = {
        'hardhat.config.js',
        'hardhat.config.ts',
        'foundry.toml',
        'remappings.txt',
        'truffle.js',
        'truffle-config.js',
        'ape-config.yaml',
      }
      local default_config = {
        cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
        filetypes = { 'solidity' },
        root_dir = lspconfig.util.find_git_ancestor,
        -- root_dir = util.root_pattern(unpack(root_files)) or util.root_pattern('.git', 'package.json'),
        single_file_support = true,
      }

      local map = function(modes, keys, func, opts)
        vim.keymap.set(modes, keys, func, opts)
      end
      local attach = function()
        map('n', '<leader>cf', function()
          os.execute 'forge fmt'
        end, { desc = 'Forge [f]mt [c]ode [f]ormat' })
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = { '*.sol' },
          callback = formatter,
        })
        local formatter = function()
          local is_v10 = vim.fn.has 'nvim-0.10'
          if is_v10 == 0 then
            return
          end
          -- location of foundry.toml from the current buffer's path
          local foundry = vim.fs.find('foundry.toml', {
            upward = true,
            stop = vim.uv.os_homedir(),
            path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
          })
          if foundry then
            os.execute 'forge fmt <afile>'
          end
        end
      end

      local lsp_flags = {
        debounce_text_changes = 150,
      }

      lsp_configs.solidity = {
        default_config = default_config,
      }
      lspconfig.solidity.setup {
        on_attach = attach,
        flags = lsp_flags,
      }
    end,
  },
}
