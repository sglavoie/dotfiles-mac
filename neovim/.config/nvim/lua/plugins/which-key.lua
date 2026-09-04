-- which-key: press a prefix, pause, and see what can follow.
--
-- Labels come from the `desc` field on each keymap, so nothing needs to be
-- registered here twice. The `spec` below only names the prefix groups, which
-- have no keymap of their own to carry a description.

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'helix', -- side panel; 'modern' for a bottom popup, 'classic' for the old style
    delay = 250, -- ms to wait before the popup appears
    spec = {
      { '<leader>f', group = 'find' },
      { '<leader>t', group = 'toggle' },
      { '<leader>m', group = 'markdown', mode = 'n' },
      { '<leader>C', desc = 'Edit Neovim config' },
      { '<leader>F', desc = 'Format buffer' },
      { '<leader>L', desc = 'Open Lazy' },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer-local keymaps',
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
