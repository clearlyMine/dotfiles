return {
  -- windows.nvim is more like the traditional <Ctrl-w>_ and <Ctrl-w>|
  {
    'anuvyklack/windows.nvim',
    dependencies = { 'anuvyklack/middleclass', 'anuvyklack/animation.nvim' },
    config = function()
      vim.o.winwidth = 1
      vim.o.winminwidth = 0
      vim.o.equalalways = false
      require('windows').setup {
        autowidth = {
          enable = false, -- prevents messing up simrat39/symbols-outline.nvim (e.g. relative width of side-bar was being made larger)
        },
      }

      local function cmd(command)
        return table.concat { '<Cmd>', command, '<CR>' }
      end

      vim.keymap.set('n', '<C-w>\\', cmd 'WindowsMaximize')
      vim.keymap.set('n', '<C-w>_', cmd 'WindowsMaximizeVertically')
      vim.keymap.set('n', '<C-w>|', cmd 'WindowsMaximizeHorizontally')
      vim.keymap.set('n', '<C-w>=', cmd 'WindowsEqualize')
    end,
  },
}
