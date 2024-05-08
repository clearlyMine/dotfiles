return {

  -- MEASURE STARTUPTIME
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- SESSION MANAGEMENT.
  -- This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp' } },
    keys = {
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = 'Restore Session',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Restore Last Session',
      },
      {
        '<leader>qd',
        function()
          require('persistence').stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },

  -- UNDOTREE
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle)
    end,
  },

  -- LIBRARY USED BY OTHER PLUGINS
  { 'nvim-lua/plenary.nvim', lazy = true },

  -- MAKE DOT OPERATOR WORK IN A SENSIBLE WAY
  { 'tpope/vim-repeat' },

  -- ADD PROMISE AND ASYNC TO LUA
  { 'kevinhwang91/promise-async' },

  -- USAGE TRACKER
  {
    'gaborvecsei/usage-tracker.nvim',
    config = function()
      require('usage-tracker').setup {
        keep_eventlog_days = 365,
        cleanup_freq_days = 365,
        event_wait_period_in_sec = 5,
        inactivity_threshold_in_min = 5,
        inactivity_check_freq_in_sec = 5,
        verbose = 0,
        telemetry_endpoint = '', -- you'll need to start the restapi for this feature
      }
    end,
  },

  -- BETTER ESCAPE
  {
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup {
        mapping = { 'jj', 'jk', 'kk', 'kj' }, -- a table with mappings to use
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = '<Esc>', -- keys used for escaping, if it is a function will use the result everytime
        -- example(recommended)
        -- keys = function()
        --   return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
        -- end,
      }
    end,
  },
}
