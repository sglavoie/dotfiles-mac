-- Formatting on save via conform.nvim.
--
-- Markdown uses prettier if it is on PATH, otherwise mdformat. If neither is
-- installed, saving is simply left alone; `:ConformInfo` shows what was found.
-- Install one of:
--   npm install -g prettier
--   uv tool install mdformat

return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  keys = {
    {
      '<leader>F',
      function()
        require('conform').format { async = true }
      end,
      mode = { 'n', 'x' },
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      markdown = { 'prettier', 'mdformat', stop_after_first = true },
      lua = { 'stylua' },
      json = { 'prettier' },
      yaml = { 'prettier' },
    },
    -- Never let an LSP server format; only the tools listed above.
    default_format_opts = { lsp_format = 'never' },
    format_on_save = { timeout_ms = 1000 },
  },
}

-- vim: ts=2 sts=2 sw=2 et
