-- In-buffer Markdown rendering: styled headings, boxed code blocks, aligned
-- tables, icon checkboxes and concealed link syntax.
--
-- Neovim 0.12 ships the `markdown` and `markdown_inline` Treesitter parsers
-- and enables highlighting for them automatically, so nvim-treesitter is not
-- needed here.

return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  opts = {
    file_types = { 'markdown' },
    -- Render everything except the line the cursor sits on, so the raw
    -- Markdown is always editable where you are typing.
    anti_conceal = { enabled = true },
    heading = {
      position = 'inline', -- no left gutter offset
      sign = false,
      width = 'block',
      min_width = 40,
    },
    code = {
      sign = false,
      width = 'block',
      min_width = 60,
      left_pad = 1,
      right_pad = 1,
      border = 'thin',
    },
    bullet = { icons = { '•', '◦', '▸', '▪' } },
    checkbox = {
      unchecked = { icon = '󰄱 ' },
      checked = { icon = '󰱒 ' },
    },
    -- Completion sources are for note-taking with wiki links; not needed here.
    completions = {
      lsp = { enabled = false },
      blink = { enabled = false },
    },
  },
  keys = {
    { '<leader>tm', '<cmd>RenderMarkdown buf_toggle<CR>', ft = 'markdown', desc = 'Toggle Markdown rendering' },
  },
}

-- vim: ts=2 sts=2 sw=2 et
