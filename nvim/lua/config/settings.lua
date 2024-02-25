-- OPTIONS
-- To see what an option is set to execute :lua = opt.<name>
-- change default copy command to be recursive by default.
vim.g.netrw_localcopydircmd = 'cp -r'

local opt = vim.o

opt.autowrite = true -- Enable auto write
opt.background = 'dark'
-- opt.backup = false
opt.clipboard = 'unnamedplus'  -- Sync with system clipboard
opt.completeopt = 'menu,menuone,noselect'
opt.conceallevel = 3           -- Hide * markup for bold and italic
opt.confirm = true             -- Confirm to save changes before exiting modified buffer
opt.cursorline = true          -- Enable highlighting of the current line
opt.dictionary = '/usr/share/dict/words'
opt.expandtab = true           -- Use spaces instead of tabs
opt.formatoptions = 'jcroqlnt' -- tcqj
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep --multiline-dotall --hidden --pcre2 --regexp'
opt.hlsearch = true          -- highlight all previous search patterns
opt.ignorecase = true        -- Ignore case
opt.inccommand = 'nosplit'   -- preview incremental substitute
opt.laststatus = 0
opt.list = true              -- Show some invisible characters (tabs...
opt.mouse = 'a'              -- Enable mouse mode
opt.number = true            -- Print line number
opt.pumblend = 10            -- Popup blend
opt.pumheight = 10           -- Maximum number of entries in a popup
opt.relativenumber = true    -- Relative line numbers
opt.scrolloff = 8            -- Lines of context
opt.sessionoptions = 'buffers,curdir,tabpages,winsize'
opt.shiftround = true        -- Round indent
opt.shiftwidth = 2           -- Size of an indent
-- opt.shortmess = "WIc"
opt.shortmess = 'filnxToOFc' -- copied default and removed `t` (long paths were being truncated) while adding `c`
opt.showmode = false         -- Dont show mode since we have a statusline
opt.sidescrolloff = 8        -- Columns of context
opt.signcolumn = 'yes'       -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true         -- Don't ignore case with capitals
opt.smartindent = true       -- Insert indents automatically
opt.softtabstop = 2
opt.spell = true
opt.spelllang = 'en,en_us'
opt.splitbelow = true              -- Put new windows below current
opt.splitright = true              -- Put new windows right of current
opt.tabstop = 2                    -- Number of spaces tabs count for
opt.timeoutlen = 300
opt.updatetime = 200               -- Save swap file and trigger CursorHold and subsequently things like highlighting Code Actions, and the Noice UI popups.
opt.wildmode = 'longest:full,full' -- Command-line completion mode
opt.winwidth = 6                   -- Needs to be set if winminwidth is set
opt.winminwidth = 5                -- Minimum window width
opt.wrap = true                    -- Disable line wrap

vim.opt.numberwidth = 3
vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"

vim.opt.undodir = vim.env.HOME .. '/.undodir'
vim.opt.undofile = true
opt.undolevels = 10000
-- vim.wo.number = true -- Make line numbers default
-- vim.o.breakindent = true -- Enable break indent

-- Keep signcolumn on by default
-- vim.wo.signcolumn = 'yes'

-- opt.lazyredraw = true (disabled as problematic with Noice plugin)
-- opt.shortmess = vim.o.shortmess .. "c" -- .. is equivalent to += in vimscript
opt.showmatch = true
opt.matchtime = 2

if vim.fn.has 'termguicolors' == 1 then
  opt.termguicolors = true
end

--[[
opt allows you to set global vim options, but not local buffer vim options.
optpt has a more expansive API that can handle local and global vim options.
See :h lua-optptions
]]
-- opt.colorcolumn = '100'

-- NETRW
--
-- https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/

-- keep the current directory and the browsing directory synced.
-- this helps avoid the "move files" error.
-- vim.g.netrw_keepdir = 0

-- configure the horizontal split size.
-- vim.g.netrw_winsize = 30

-- hide the banner (`I` will temporarily display it).
-- vim.g.netrw_banner = 0

-- QUICKFIX

vim.cmd 'packadd cfilter'

-- UI

-- LSP UI boxes improvements
--
-- NOTE: Noice plugin will override these settings.
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
vim.diagnostic.config {
  underline = true,
  float = { border = 'rounded', style = 'minimal' },
}

-- Configure the UI aspect of the quickfix window
-- NOTE: See https://github.com/kevinhwang91/nvim-bqf#customize-quickfix-window-easter-egg and ~/.config/nvim/syntax/qf.vim
local fn = vim.fn

-- QUICKFIX RESULTS SORTER
-- :lua _G.qfSort()
function _G.qfSort()
  local items = fn.getqflist()
  table.sort(items, function(a, b)
    if a.bufnr == b.bufnr then
      if a.lnum == b.lnum then
        return a.col < b.col
      else
        return a.lnum < b.lnum
      end
    else
      return a.bufnr < b.bufnr
    end
  end)
  fn.setqflist(items, 'r')
end

vim.keymap.set('', '<leader>xss', '<Cmd>lua _G.qfSort()<CR>', { desc = 'sort quickfix window' })

-- This will align the quickfix window list.
function _G.qftf(info)
  local items
  local ret = {}
  -- The name of item in list is based on the directory of quickfix window.
  -- Change the directory for quickfix window make the name of item shorter.
  -- It's a good opportunity to change current directory in quickfixtextfunc :)
  --
  -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
  -- local root = getRootByAlterBufnr(alterBufnr)
  -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
  --
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 31
  local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local validFmt = '%s │%5d:%-3d│%s %s'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

opt.qftf = '{info -> v:lua._G.qftf(info)}'
