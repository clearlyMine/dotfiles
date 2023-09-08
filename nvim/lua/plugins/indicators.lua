return {
  -- automatically display the color column
  {
    'm4xshen/smartcolumn.nvim',
    opts = {
      colorcolumn = '80',
      custom_colorcolumn = { rust = '100' },
      disabled_filetypes = { 'help', 'text', 'markdown' },
      scope = 'file',
    },
  },
}
