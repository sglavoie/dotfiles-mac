-- Markdown-local settings. This runs after $VIMRUNTIME/ftplugin/markdown.vim,
-- so it can override the defaults that file sets.

vim.opt_local.spell = true

-- Required for render-markdown.nvim to hide the raw syntax it replaces.
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = ''

-- Two trailing spaces are a hard line break in Markdown, so do not flag them
-- as stray whitespace here.
vim.opt_local.listchars:remove 'trail'

-- Continue list items when pressing <CR> in Insert mode and o/O in Normal
-- mode. The runtime ftplugin removes 'r' and 'o' on purpose; for note-taking
-- the continuation is worth more than the occasional unwanted bullet.
--   r: continue the comment leader after <CR>
--   o: continue it after o/O
--   n: recognise numbered lists when reflowing with gq
--   j: remove the comment leader when joining lines
vim.opt_local.formatoptions:append 'ronj'

-- The runtime 'comments' value omits ordered lists, which is why numbered
-- items are not continued. Add them, and treat blockquotes as continuable.
vim.opt_local.comments = 'fb:*,fb:-,fb:+,fb:1.,b:>'

-- No hard wrapping: lines stay long in the file and are soft-wrapped on
-- screen. `gq` still reflows to this width when asked explicitly.
vim.opt_local.textwidth = 0

-- Two-space indentation for nested lists rather than the runtime default of
-- four, which is what prettier and most Markdown renderers expect.
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

-- Jump between headings. [[ and ]] are already mapped by the runtime
-- ftplugin; these add fold-based navigation over sections.
local map = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

map('<leader>mt', 'mzI- [ ] <Esc>`z', 'Make line a task')
map('<leader>mx', function()
  local line = vim.api.nvim_get_current_line()
  if line:match '%[ %]' then
    line = line:gsub('%[ %]', '[x]', 1)
  elseif line:match '%[[xX]%]' then
    line = line:gsub('%[[xX]%]', '[ ]', 1)
  end
  vim.api.nvim_set_current_line(line)
end, 'Toggle task checkbox')

-- vim: ts=2 sts=2 sw=2 et
