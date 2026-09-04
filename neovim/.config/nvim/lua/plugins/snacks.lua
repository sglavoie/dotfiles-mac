-- snacks.nvim provides the file picker, live grep and file explorer. One
-- plugin instead of a telescope/fzf + tree + dressing stack.
--
-- Requires ripgrep (`rg`) for grep and fd (`fd`) for fast file listing.

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true }, -- disable costly features on huge files
    quickfile = { enabled = true }, -- render the file before loading plugins
    explorer = { enabled = true },
    picker = { enabled = true },
    input = { enabled = true }, -- nicer vim.ui.input prompts
    notifier = { enabled = true, timeout = 3000 },
  },
  keys = {
    -- Explorer
    { '<C-n>', function() Snacks.explorer() end, desc = 'File explorer' },

    -- Find
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find files' },
    { '<leader>fg', function() Snacks.picker.grep() end, desc = 'Grep (live)' },
    { '<leader>fw', function() Snacks.picker.grep_word() end, mode = { 'n', 'x' }, desc = 'Grep word under cursor' },
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent files' },
    { '<leader>fl', function() Snacks.picker.lines() end, desc = 'Search in buffer' },
    { '<leader>fh', function() Snacks.picker.help() end, desc = 'Help tags' },
    { '<leader>fs', function() Snacks.picker.spelling() end, desc = 'Spelling suggestions' },
    { '<leader>fk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>fn', function() Snacks.picker.notifications() end, desc = 'Notification history' },

    -- Markdown headings in the current buffer, via Treesitter symbols
    { '<leader>fo', function() Snacks.picker.treesitter() end, desc = 'Outline (headings)' },
  },
}

-- vim: ts=2 sts=2 sw=2 et
