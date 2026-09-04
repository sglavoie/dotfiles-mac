-- Global editor settings. Filetype-specific settings live in after/ftplugin/.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Interface
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes'
vim.opt.mouse = 'a'
vim.opt.showmode = false -- redundant with the mode shown in the command line
vim.opt.scrolloff = 8
vim.opt.confirm = true -- prompt instead of failing when a buffer is unsaved

-- Line wrapping, tuned for prose rather than code
vim.opt.wrap = true
vim.opt.linebreak = true -- break at word boundaries, not mid-word
vim.opt.breakindent = true -- keep the indent on wrapped lines
vim.opt.showbreak = '↳ '

-- Files
vim.opt.undofile = true -- persistent undo history
vim.opt.swapfile = false
vim.opt.clipboard = 'unnamedplus' -- share the system clipboard

-- Searching: case-insensitive unless the pattern contains a capital or \C
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.inccommand = 'split' -- live preview of :substitute

-- Splits open where the eye expects them
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Whitespace made visible. Trailing spaces are deliberately NOT shown in
-- Markdown (two trailing spaces are a hard line break); see after/ftplugin.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Responsiveness
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Spelling. Dictionaries are downloaded on first use; add 'fr' here if you
-- want French checked alongside English.
vim.opt.spelllang = { 'en' }
vim.opt.spellfile = vim.fn.stdpath 'config' .. '/spell/en.utf-8.add'

-- Folding via Treesitter, but start with everything open.
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevelstart = 99
vim.opt.foldtext = ''
vim.opt.fillchars = { fold = ' ' }

-- vim: ts=2 sts=2 sw=2 et
