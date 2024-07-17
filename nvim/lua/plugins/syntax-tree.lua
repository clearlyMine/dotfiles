return {
  -- MINIMAP
  {
    'gorbit99/codewindow.nvim',
    config = function()
      require('codewindow').setup {
        auto_enable = false,
        use_treesitter = true, -- disable to lose colours
        exclude_filetypes = {
          'Outline',
          'neo-tree',
          'qf',
          'packer',
          'help',
          'noice',
          'Trouble',
        },
      }
      vim.api.nvim_set_keymap('n', '<leader>um', "<cmd>lua require('codewindow').toggle_minimap()<CR>", {
        noremap = true,
        silent = true,
        desc = 'Toggle minimap',
      })
    end,
  },
}
