return {
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
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      cmp.setup {
        experimental = { ghost_text = true },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-k>'] = cmp.mapping.scroll_docs(-4),
          ['<C-j>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-f>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources {
          -- ordered by priority
          { name = 'nvim_lsp',               keyword_length = 1 },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
          { name = 'nvim_lua' },
          { name = 'crates' },
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = require('tailwindcss-colorizer-cmp').formatter,
        },
      }

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
        sources = { { name = 'buffer' } },
      })

      cmp.setup.cmdline({ ':' }, {
        mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
        sources = { { name = 'cmdline' }, { name = 'path' } },
      })
    end,
  },

  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-path',

  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets", },
    keys = {
      {
        '<C-;>',
        function()
          require('luasnip').jump(1)
        end,
        desc = 'Jump forward a snippet placement',
        mode = 'i',
        noremap = true,
        silent = true,
      },
      {
        '<C-,>',
        function()
          require('luasnip').jump(-1)
        end,
        desc = 'Jump backward a snippet placement',
        mode = 'i',
        noremap = true,
        silent = true,
      },
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    'Exafunction/codeium.vim',
    event = 'BufEnter',
    config = function()
      vim.keymap.set('i', '<C-a>', function()
        return vim.fn['codeium#Accept']()
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-;>', function()
        return vim.fn['codeium#CycleCompletions'](1)
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-,>', function()
        return vim.fn['codeium#CycleCompletions'](-1)
      end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-x>', function()
        return vim.fn['codeium#Clear']()
      end, { expr = true, silent = true })
    end,
  },
}
