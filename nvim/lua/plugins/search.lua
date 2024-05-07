local function nmap(lhs, rhs, opts)
  vim.keymap.set('n', lhs, rhs, opts)
end

return {
  {
    -- SEARCH
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      --[[
          Opening multiple files doesn't work by default.

          You can either following the implementation detailed here:
          https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1220846367

          Or you can have a more complex workflow:
          - Select multiple files using <Tab>
          - Send the selected files to the quickfix window using <C-o>
          - Search the quickfix window (using either :copen or <leader>q)

          NOTE: Scroll the preview window using <C-d> and <C-u>.
        ]]
      local actions = require 'telescope.actions'
      local ts = require 'telescope'

      ts.setup {
        defaults = {
          -- layout_strategy = 'vertical',
          -- layout_config = { height = 0.75, preview_height = 0.7 },
          mappings = {
            i = {
              ['<esc>'] = actions.close,
              ['<C-o>'] = actions.send_selected_to_qflist,
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
          scroll_strategy = 'limit',
        },
        extensions = { heading = { treesitter = true } },
      }

      ts.load_extension 'changed_files'
      ts.load_extension 'emoji'
      ts.load_extension 'fzf'
      ts.load_extension 'heading'
      ts.load_extension 'ui-select'
      ts.load_extension 'windows'

      vim.g.telescope_changed_files_base_branch = 'main'

      local tel_built_in = require 'telescope.builtin'

      nmap('<leader>xss', tel_built_in.diagnostics, { desc = '[S]earch [D]iagnostics' })
      nmap('<leader>xsq', '<Cmd>Telescope quickfix<CR>', { desc = 'search quickfix list' })

      nmap('<leader><leader>', tel_built_in.find_files, { desc = 'Search File[s]' })
      -- nmap('<leader>f', '<Cmd>Telescope find_files hidden=true<CR>', { desc = 'search files' })
      nmap('<leader>s?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
      nmap('<leader>s/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      nmap('<leader>sfg', tel_built_in.git_files, { desc = '[S]earch [G]it Files' })
      nmap('<leader>sb', '<Cmd>Telescope buffers<CR>', { desc = '[S]earch [B]uffers' })
      -- nmap('<leader>sc', '<Cmd>Telescope colorscheme<CR>', { desc = 'search colorschemes' })
      nmap('<leader>scf', '<Cmd>Telescope changed_files<CR>', { desc = '[S]earch [C]hanged [F]iles' })
      nmap('<leader>sg', tel_built_in.live_grep, { desc = '[S]earch by [G]rep' })
      nmap('<leader>sw', tel_built_in.grep_string, { desc = '[S]earch current [W]ord' })

      nmap('<leader>scta', '<Cmd>TodoTelescope<CR>', { desc = '[S]ear[C]h [T]ODOs across [A]ll files' })
      nmap('<leader>sctc', "<Cmd>exe ':TodoQuickFix cwd=' .. fnameescape(expand('%:p'))<CR>", { desc = '[S]ear[C]h [T]ODOs in [C]urrent file' })

      nmap('<leader>se', '<Cmd>Telescope commands<CR>', { desc = '[S]earch [E]x commands' })
      nmap('<leader>sh', tel_built_in.help_tags, { desc = '[S]earch [H]elp' })
      nmap('<leader>si', '<Cmd>Telescope builtin<CR>', { desc = '[S]earch bu[I]ltins' })
      nmap('<leader>sj', '<Cmd>Telescope emoji<CR>', { desc = '[S]earch emo[J]is' })
      nmap('<leader>sk', '<Cmd>Telescope keymaps<CR>', { desc = '[S]earch [K]ey mappings' })

      nmap('<leader>sli', '<Cmd>Telescope lsp_incoming_calls<CR>', { desc = '[S]earch [L]sp [I]ncoming calls' })
      nmap('<leader>slo', '<Cmd>Telescope lsp_outgoing_calls<CR>', { desc = '[S]earch [L]sp [O]utgoing calls' })
      nmap('<leader>slr', '<Cmd>Telescope lsp_references<CR>', { desc = '[S]earch [L]sp code [R]eference' })
      nmap('<leader>sls', "<Cmd>lua require('telescope.builtin').lsp_document_symbols({show_line = true})<CR>", { desc = '[S]earch [L][S]p document tree' })

      nmap('<leader>sm', '<Cmd>Telescope heading<CR>', { desc = '[S]earch [M]arkdown headings' })
      nmap('<leader>sr', '<Cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = '[S]earch cu[R]rent buffer text' })
      nmap('<leader>ss', '<Cmd>Telescope treesitter<CR>', { desc = '[S]earch treesitter [S]ymbols' }) -- similar to lsp_document_symbols but treesitter doesn't know what a 'struct' is, just that it's a 'type'.
      nmap('<leader>su', '<Cmd>Noice telescope<CR>', { desc = '[S]earch messages handled by Noice pl[U]gin' })

      -- Remove the Vim builtin colorschemes so they don't show in Telescope.
      vim.cmd 'silent !rm $VIMRUNTIME/colors/*.vim &> /dev/null'
    end,
  },

  {
    -- FZF SORTER FOR TELESCOPE WRITTEN IN C
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },

  {
    -- USE TELESCOPE FOR UI ELEMENTS
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require('telescope').setup {}
    end,
  },

  {
    -- SEARCH WINDOWS IN TELESCOPE
    'kyoh86/telescope-windows.nvim',
  },

  {
    -- SEARCH MARKDOWN HEADINGS IN TELESCOPE
    'crispgm/telescope-heading.nvim',
  },

  {
    -- SEARCH EMOJIS IN TELESCOPE
    'xiyaowong/telescope-emoji.nvim',
  },

  {
    -- SEARCH CHANGED GIT FILES IN TELESCOPE
    'axkirillov/telescope-changed-files',
  },

  {
    -- SEARCH TABS IN TELESCOPE
    'LukasPietzschmann/telescope-tabs',
    config = function()
      nmap('<leader>t', "<Cmd>lua require('telescope-tabs').list_tabs()<CR>", { desc = 'search tabs' })
    end,
  },

  -- {
  --   -- SEARCH INDEXER
  --   'kevinhwang91/nvim-hlslens',
  --   config = true,
  -- },
  --
  -- {
  --   -- IMPROVES ASTERISK BEHAVIOR
  --   'haya14busa/vim-asterisk',
  --   config = function()
  --     nmap('*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
  --     nmap('#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
  --     nmap('g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
  --     nmap('g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
  --
  --     vim.keymap.set('x', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
  --     vim.keymap.set('x', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
  --     vim.keymap.set('x', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
  --     vim.keymap.set('x', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
  --   end,
  -- },

  -- {
  --   -- SEARCH AND REPLACE
  --   'nvim-pack/nvim-spectre',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('spectre').setup {
  --       replace_engine = { ['sed'] = { cmd = 'gsed' } },
  --     }
  --     nmap('<leader>H', "<Cmd>lua require('spectre').open()<CR>", { desc = 'search and replace' })
  --   end,
  -- },
}
