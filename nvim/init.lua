-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  {
    -- Theme
    'EdenEast/nightfox.nvim',
    lazy = false, -- make sure we load this during startup as it is our main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('nightfox').setup {
        options = {
          styles = { strings = 'italic' },
        },
        palettes = {
          carbonfox = {
            bg3 = '#121820',
          },
        },
        specs = {
          -- all = { syntax = { operator = 'orange' } },
        },
        groups = {
          all = {
            -- ['@field'] = { fg = 'palette.yellow' },
            -- LineNr = { fg = 'palette.red' },
          },
        },
      }
      vim.cmd 'colorscheme carbonfox'
    end,
  },
  'xiyaowong/transparent.nvim',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  { import = 'plugins' },
  { import = 'plugins/ui' },
}, {})
require 'config.init'
require 'config.autocommands'
require 'config.mappings'
require 'config.settings'

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- Disable nvim providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
