-- Autocommands. Grouped so that re-sourcing this file is idempotent.

local group = function(name)
  return vim.api.nvim_create_augroup('user_' .. name, { clear = true })
end

-- Briefly highlight the text that was just yanked.
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group 'highlight_yank',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reopen a file at the position the cursor was left in.
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group 'last_position',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Create missing parent directories when writing a new file.
vim.api.nvim_create_autocmd('BufWritePre', {
  group = group 'mkdir_on_save',
  callback = function(args)
    if args.match:match '^%w%w+://' then
      return
    end
    vim.fn.mkdir(vim.fn.fnamemodify(args.match, ':p:h'), 'p')
  end,
})

-- vim: ts=2 sts=2 sw=2 et
