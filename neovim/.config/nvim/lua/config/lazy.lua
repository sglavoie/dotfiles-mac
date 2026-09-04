-- lazy.nvim bootstrap and setup.
--
-- Update policy: automatic update checking is disabled on purpose. Run
-- `:Lazy sync` when you choose to, then commit the resulting lazy-lock.json.
-- That lockfile is what makes this configuration reproducible.

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Failed to clone lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = { { import = 'plugins' } },
  -- Follow the committed lockfile rather than the latest upstream commit.
  lockfile = vim.fn.stdpath 'config' .. '/lazy-lock.json',
  install = { colorscheme = { 'tokyonight', 'habamax' } },
  checker = { enabled = false }, -- no "updates available" nagging
  change_detection = { enabled = true, notify = false },
  rocks = { enabled = false }, -- no luarocks toolchain required
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}

vim.keymap.set('n', '<leader>L', '<cmd>Lazy<CR>', { desc = 'Open Lazy' })

-- vim: ts=2 sts=2 sw=2 et
