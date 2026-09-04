-- Neovim configuration: Markdown-first, minimal, pure Lua.
--
-- Layout:
--   lua/config/*        editor settings, keymaps, autocommands, plugin manager
--   lua/plugins/*       one file per plugin (lazy.nvim specs)
--   after/ftplugin/*    filetype-local overrides
--
-- Plugin versions are pinned in lazy-lock.json, which is tracked in the
-- dotfiles repository. Run `:Lazy sync` deliberately, then commit the lockfile.

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'

-- vim: ts=2 sts=2 sw=2 et
