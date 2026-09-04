-- Global keymaps. Plugin-specific keymaps are declared in each plugin spec so
-- that they also drive lazy-loading.

local map = vim.keymap.set

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Move by screen line when a long line is soft-wrapped, but keep counted
-- motions (3j) operating on real lines.
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Down (screen line)' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Up (screen line)' })

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus window left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus window right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus window below' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus window above' })

-- Window resizing
map('n', '<M-j>', '<cmd>resize -2<CR>', { desc = 'Shrink window height' })
map('n', '<M-k>', '<cmd>resize +2<CR>', { desc = 'Grow window height' })
map('n', '<M-h>', '<cmd>vertical resize -2<CR>', { desc = 'Shrink window width' })
map('n', '<M-l>', '<cmd>vertical resize +2<CR>', { desc = 'Grow window width' })

-- Move the visual selection up and down
map('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
map('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })

-- Keep the cursor centred while jumping through search matches
map('n', 'n', 'nzzzv', { desc = 'Next match (centred)' })
map('n', 'N', 'Nzzzv', { desc = 'Previous match (centred)' })

-- Terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Open this configuration
map('n', '<leader>C', '<cmd>tabedit ' .. vim.fn.stdpath 'config' .. '/init.lua<CR>', { desc = 'Edit Neovim config' })

-- Toggle spell checking for the current buffer
map('n', '<leader>ts', function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
  vim.notify('spell: ' .. tostring(vim.opt_local.spell:get()))
end, { desc = 'Toggle spell check' })

-- vim: ts=2 sts=2 sw=2 et
