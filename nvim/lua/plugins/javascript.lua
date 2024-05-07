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
}
