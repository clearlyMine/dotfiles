vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('AutoOpenQuickfix', { clear = true }),
  pattern = { '[^l]*' },
  command = 'cwindow',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'go', 'rust' },
  command = 'setlocal textwidth=100',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'solidity' },
  command = 'setlocal textwidth=120',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.mdx' },
  command = 'set filetype=markdown',
})

-- vim.api.nvim_create_autocmd('ColorScheme', {
--   pattern = '*',
--   callback = function()
--     -- vim.cmd("highlight BufDimText guibg='NONE' guifg=darkgrey guisp=darkgrey gui='NONE'")
--
--     -- vim-illuminate (highlights every instance of word under the cursor)
--     -- vim.api.nvim_set_hl(0, 'illuminatedWord', { fg = '#063970', bg = '#76b5c5' })
--     -- vim.api.nvim_set_hl(0, 'LspReferenceText', { fg = '#063970', bg = '#76b5c5' })
--     -- vim.api.nvim_set_hl(0, 'LspReferenceWrite', { fg = '#063970', bg = '#76b5c5' })
--     -- vim.api.nvim_set_hl(0, 'LspReferenceRead', { fg = '#063970', bg = '#76b5c5' })
--   end,
-- })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('WrapLineInMarkdown', { clear = true }),
  pattern = { 'markdown' },
  command = 'setlocal wrap',
})

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  group = vim.api.nvim_create_augroup('ScrollbarHandleHighlight', { clear = true }),
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'ScrollbarHandle', { fg = '#ff0000', bg = '#8ec07c' })
  end,
})

local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup 'highlight_yank',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup 'last_loc',
  callback = function()
    local exclude = { 'gitcommit' }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'wrap_spell',
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup 'auto_create_dir',
  callback = function(event)
    if event.match:match '^%w%w+://' then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})
