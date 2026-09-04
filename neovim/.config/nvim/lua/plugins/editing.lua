-- mini.surround, configured to keep the vim-surround key sequences it
-- replaces: ysiw" / ds" / cs"' all behave as before.
--
-- Extra Markdown surroundings are added under keys mini.surround leaves free
-- (b and q stay the built-in "any bracket" and "any quote" aliases):
--   ysiwB -> **bold**        ysiwi -> _italic_
--   ysiwc -> `code`          ysiws -> ~~strikethrough~~

return {
  'echasnovski/mini.surround',
  version = '*',
  keys = {
    { 'ys', desc = 'Add surrounding', mode = 'n' },
    { 'yss', desc = 'Add surrounding to line', mode = 'n' },
    { 'ds', desc = 'Delete surrounding', mode = 'n' },
    { 'cs', desc = 'Replace surrounding', mode = 'n' },
    { 'S', desc = 'Add surrounding', mode = 'x' },
  },
  opts = {
    mappings = {
      add = 'ys',
      delete = 'ds',
      replace = 'cs',
      -- Sequences vim-surround does not have, left unmapped to keep the
      -- keyboard uncluttered.
      find = '',
      find_left = '',
      highlight = '',
      update_n_lines = '',
      suffix_last = '',
      suffix_next = '',
    },
    search_method = 'cover_or_next',
    custom_surroundings = {
      B = { input = { '%*%*().-()%*%*' }, output = { left = '**', right = '**' } },
      i = { input = { '_().-()_' }, output = { left = '_', right = '_' } },
      c = { input = { '`().-()`' }, output = { left = '`', right = '`' } },
      s = { input = { '~~().-()~~' }, output = { left = '~~', right = '~~' } },
    },
  },
  config = function(_, opts)
    require('mini.surround').setup(opts)

    -- Restore the two sequences mini.surround maps differently from
    -- vim-surround: `S` on a Visual selection, and `yss` for a whole line.
    -- The Visual mapping goes through :lua so that Visual mode is left first
    -- and the '< / '> marks are set, which is what MiniSurround.add expects.
    pcall(vim.keymap.del, 'x', 'ys')
    vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], {
      silent = true,
      desc = 'Add surrounding to selection',
    })
    vim.keymap.set('n', 'yss', 'ys_', { remap = true, desc = 'Add surrounding to line' })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
