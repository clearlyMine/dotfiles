return {
  -- automatically display the color column
  {
    'm4xshen/smartcolumn.nvim',
    opts = {
      colorcolumn = '80',
      custom_colorcolumn = { rust = '100', solidity = '119' }, --some bug prevents 120 and above for solidity
      disabled_filetypes = { 'help', 'text', 'markdown' },
      scope = 'file',
    },
  },
}
