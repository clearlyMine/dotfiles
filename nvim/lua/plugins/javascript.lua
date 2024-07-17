return {

  {
    'windwp/nvim-ts-autotag',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  -- Package version checking
  {
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function()
      require('package-info').setup()
    end,
  },

  -- Tailwind CSS
  {
    'roobert/tailwindcss-colorizer-cmp.nvim',
    -- optionally, override the default options:
    config = function()
      require('tailwindcss-colorizer-cmp').setup {
        color_square_width = 2,
      }
    end,
    -- config = true,
  },

  -- Tailwind CSS Values
  {
    'MaximilianLloyd/tw-values.nvim',
    keys = {
      { '<leader>sv', '<cmd>TWValues<cr>', desc = 'Show tailwind CSS values' },
    },
    opts = {
      border = 'rounded', -- Valid window border style,
      show_unknown_classes = true, -- Shows the unknown classes popup
      focus_preview = true, -- Sets the preview as the current window
      copy_register = '', -- The register to copy values to,
      keymaps = {
        copy = '<C-y>', -- Normal mode keymap to copy the CSS values between {}
      },
    },
  },

  -- Colors
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
}
