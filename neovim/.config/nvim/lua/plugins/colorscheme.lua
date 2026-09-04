-- Colour scheme. Loaded eagerly and with high priority so that no other
-- plugin paints before it.

return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    style = 'night',
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
    },
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme 'tokyonight'
  end,
}

-- vim: ts=2 sts=2 sw=2 et
