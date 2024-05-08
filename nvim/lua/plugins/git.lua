local function nmap(l, r, opts, bufnr)
  opts = opts or {}
  opts.buffer = bufnr
  vim.keymap.set('n', l, r, opts)
end

return {
  'tpope/vim-fugitive',

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- local icon = require('config').icons.git

      require('gitsigns').setup {
        -- See `:help gitsigns.txt`
        signs = {
          add = { hl = 'GitSignsAdd', text = '┃' },
          change = { hl = 'GitSignsChange', text = '┃' },
          delete = { hl = 'GitSignsDelete', text = '▁' },
          topdelete = { hl = 'GitSignsDelete', text = '▔' },
          changedelete = { hl = 'GitSignsChangeDelete', text = '┃' },
          untracked = { hl = 'GitSignsUntracked', text = '┃' },
          -- add = { hl = icon.added, text = '▎' },
          -- change = { hl = icon.change, text = '▎' },
          -- delete = { hl = icon.removed, text = '' },
          -- topdelete = { text = '' },
          -- changedelete = { text = '▎' },
          -- untracked = { text = '▎' },
        },
        signcolumn = true,
        current_line_blame = true,
        on_attach = function(bufnr)
          -- local gs = require 'gitsigns'
          local gs = package.loaded.gitsigns

          nmap('[h', gs.prev_hunk, { desc = '[G]o to [P]revious Hunk' }, bufnr)
          nmap(']h', gs.next_hunk, { desc = '[G]o to [N]ext Hunk' }, bufnr)
          nmap('<leader>ggb', function()
            gs.blame_line { full = true }
          end, { desc = 'Git blame' }, bufnr)

          nmap('<leader>ggs', function()
            gs.blame_line {}
          end, { desc = 'Git blame short' }, bufnr)

          nmap('<leader>ggd', gs.diffthis, { desc = 'git diff (:q to close)' }, bufnr)
        end,
      }
    end,
  },

  {
    -- GIT HISTORY
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('diffview').setup()
      nmap('<leader>ggh', '<Cmd>DiffviewFileHistory<CR>', { desc = 'Git diff history' }, nil)
      nmap('<leader>ggo', '<Cmd>DiffviewOpen<CR>', { desc = 'Git diff open' }, nil)
      nmap('<leader>ggc', '<Cmd>DiffviewClose<CR>', { desc = 'Git diff close' }, nil)
    end,
  },
}
