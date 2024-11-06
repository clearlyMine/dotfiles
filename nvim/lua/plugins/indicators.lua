return {
  -- automatically display the color column
  {
    'm4xshen/smartcolumn.nvim',
    opts = {
      colorcolumn = '100',
      custom_colorcolumn = { go = '120', rust = '100', solidity = '119' }, --some bug prevents 120 and above for solidity
      disabled_filetypes = { 'help', 'text', 'markdown' },
      scope = 'file',
    },
  },
}
