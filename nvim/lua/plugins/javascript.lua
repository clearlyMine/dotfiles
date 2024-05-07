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
    -- config = function()
    --   require('tailwindcss-colorizer-cmp').setup {
    --     color_square_width = 2,
    --   }
    -- end,
    config = true,
  },
}
