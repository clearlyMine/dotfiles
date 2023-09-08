return {
  {
    -- NOTE: `:Noice` to open message history + `:Noice telescope` to open message history in Telescope.
    'folke/noice.nvim',
    event = 'VimEnter',
    keys = {
      {
        '<leader>un',
        function()
          vim.cmd 'Noice dismiss'
        end,
        desc = 'Dismiss visible messages',
        mode = 'n',
        noremap = true,
        silent = true,
      },
    },
    config = function()
      require('noice').setup {
        views = {
          cmdline_popup = {
            size = { width = '40%', height = 'auto' },
            win_options = {
              winhighlight = {
                Normal = 'Normal',
                FloatBorder = 'DiagnosticSignInfo',
                IncSearch = '',
                Search = '',
              },
            },
          },
          popupmenu = {
            relative = 'editor',
            position = { row = 8, col = '50%' },
            size = { width = 100, height = 10 },
            border = { style = 'rounded', padding = { 0, 0.5 } },
            win_options = {
              winhighlight = {
                Normal = 'Normal',
                FloatBorder = 'DiagnosticSignInfo',
              },
            },
          },
        },
        routes = {
          -- skip displaying message that file was written to.
          {
            filter = {
              event = 'msg_show',
              kind = '',
              find = 'written',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'msg_show',
              kind = '',
              find = 'more lines',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'msg_show',
              kind = '',
              find = 'fewer lines',
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = 'msg_show',
              kind = '',
              find = 'lines yanked',
            },
            opts = { skip = true },
          },
          {
            view = 'split',
            filter = { event = 'msg_show', min_height = 10 },
          },
        },
        presets = { long_message_to_split = true, lsp_doc_border = true },
        documentation = {
          opts = {
            win_options = {
              winhighlight = { FloatBorder = 'DiagnosticSignInfo' },
            },
          },
        },
        lsp = {
          progress = {
            enabled = false, -- I already use fidget configured in ./lsp.lua
          },
        },
      }
    end,
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
  },
}
