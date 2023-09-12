return {
  -- DEBUGGING
  {
    'mfussenegger/nvim-dap',

    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      -- Add your own debuggers here
      -- 'leoluz/nvim-dap-go',
    },

    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_setup = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          -- 'delve',
          'codelldb',
          'cpptools',
          'rust',
        },
        -- NOTE: this is left here for future porting in case needed
        -- Whether adapters that are set up (via dap) should be automatically installed if they're not already installed.
        -- This setting has no relation with the `ensure_installed` setting.
        -- Can either be:
        --   - false: Daps are not automatically installed.
        --   - true: All adapters set up via dap are automatically installed.
        --   - { exclude: string[] }: All adapters set up via mason-nvim-dap, except the ones provided in the list, are automatically installed.
        --       Example: automatic_installation = { exclude = { "python", "delve" } }
        automatic_installation = false,
      }
      local map = function(modes, keys, func, opts)
        vim.keymap.set(modes, keys, func, opts)
      end
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'DEBUG: ' .. desc
        end

        map('n', keys, func, { desc = desc })
      end

      -- Basic debugging keymaps, feel free to change to your liking!
      -- nmap('<leader>dx', "<Cmd>lua require('dap').close()<CR>", 'stop debugging' )
      -- -- nmap('<leader>do', "<Cmd>lua require('dap').step_over()<CR>", 'step over' )
      -- -- nmap('<leader>di', "<Cmd>lua require('dap').step_into()<CR>", 'step into' )
      -- nmap('<leader>dt', "<Cmd>lua require('dap').step_out()<CR>", 'step out' )
      -- nmap('<leader>db', "<Cmd>lua require('dap').toggle_breakpoint()<CR>", 'toggle breakpoint' )
      -- nmap('<leader>dv', "<Cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", 'toggle breakpoint' )
      -- nmap('<leader>dr', "<Cmd>lua require('dap').repl.open()<CR>", 'open repl' )
      -- nmap('<leader>du', "<Cmd>lua require('dapui').toggle()<CR>", 'toggle dap ui' )
      nmap('<F5>', dap.continue, 'Start/Continue')
      nmap('<leader>dc', dap.continue, 'Start/Continue [F5]')

      nmap('<F1>', dap.step_into, 'Step Into')
      nmap('<leader>di', dap.step_into, 'Step Into [F1]')

      nmap('<F2>', dap.step_over, 'Step Over')
      nmap('<leader>do', dap.step_over, 'Step Over [F2]')

      nmap('<F3>', dap.step_out, 'Step Out')
      nmap('<leader>dt', dap.step_out, 'Step Out [F3]')

      nmap('<leader>dx', dap.close, 'Stop Debugging [dx]')

      nmap('<leader>dR', function()
        dap.close()
        dap.continue()
      end, 'Restart Debugging [Shift+<F5>]')
      nmap('<S-F5>', function()
        dap.close()
        dap.continue()
      end, 'Restart Debugging [Shift+<F5>]')

      nmap('<leader>db', dap.toggle_breakpoint, 'Toggle Breakpoint')
      nmap('<leader>dB', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, 'Set Breakpoint')

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Install golang specific config
      -- require('dap-go').setup()
    end,
  },

  -- {
  --   'ldelossa/nvim-dap-projects',
  --   config = function()
  --     require('nvim-dap-projects').search_project_config()
  --   end,
  -- },

  {
    -- Refer to the following help file for REPL commands.
    -- :h dap.repl.open()
    --
    -- REPL Examples:
    -- .n == next
    -- .c == continue
    -- .into == step in
    -- .out == step out
    -- .scopes == print variables
    --
    -- Just typing an expression (e.g. typing a variable name) should evaluate its value.
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = true,
  },

  -- {
  --   'leoluz/nvim-dap-go',
  --   dependencies = { 'mfussenegger/nvim-dap' },
  --   build = 'go install github.com/go-delve/delve/cmd/dlv@latest',
  --   config = true,
  -- },

  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = true,
  },

  -- {
  --   'mfussenegger/nvim-dap-python',
  --   dependencies = { 'mfussenegger/nvim-dap' },
  --   config = function()
  --     -- source ~/.local/share/nvim/mason/packages/debugpy/venv/bin/activate
  --     -- python3 -m pip install -r requirements.txt
  --     local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')
  --     require('dap-python').setup(mason_path .. 'packages/debugpy/venv/bin/python')
  --     -- https://github.com/mfussenegger/nvim-dap-python/issues/46#issuecomment-1124175484
  --     require('dap').configurations.python[1].justMyCode = false
  --   end,
  -- },
}
