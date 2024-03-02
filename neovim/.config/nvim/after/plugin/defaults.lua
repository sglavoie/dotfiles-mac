-- options
vim.opt.autoindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = [[menuone,noinsert,noselect]]
vim.opt.cursorline = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8"
vim.opt.foldlevel = 9
vim.opt.foldmethod = "indent"
vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.laststatus = 3
vim.opt.lazyredraw = true
vim.opt.list = true
vim.opt.listchars = "tab:│ ,extends:>,trail:·,precedes:<,nbsp:⦸"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 4
vim.opt.shortmess:append("I")
vim.opt.shortmess:append("W")
vim.opt.shortmess:append("c")
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.smartcase = true
vim.opt.spellfile = "$HOME/.config/nvim/spell/en.utf-8.add"
vim.opt.spelllang = "en_gb"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.undodir = "/tmp"
vim.opt.undofile = true
vim.opt.updatetime = 150
vim.opt.wildmenu = true
vim.opt.wrap = true

-- general keybindings
vim.keymap.set('n', '<C-n>', ":Vifm<CR>", { desc = '[N]avigate with Vifm' })
vim.keymap.set('n', '<leader>C', ":tabedit ~/.config/nvim/init.lua<CR>",
	{ desc = 'Edit Neovim [C]onfiguration file in a new tab' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>y', ":%y<CR>", { desc = 'Copy the content of the entire buffer' })
vim.keymap.set('n', 'Y', "yg_", { desc = '[Y]ank to the end of the line' })
vim.keymap.set('n', '<leader>e', ":e!<CR>", { desc = 'Reset [e]dits made in current buffer if file hasn\'t been saved' })

---- buffers
vim.keymap.set('n', '<leader>B', ":%bd|e#|bd#<CR>", { desc = 'Delete all [B]uffers except the active one' })
vim.keymap.set('n', '<leader>Q', ":qall!<CR>", { desc = 'Close all buffers without saving' })
vim.keymap.set('n', '<leader>w', ":w<CR>", { desc = '[W]rite file' })
vim.keymap.set('n', '<leader>x', ":bd!<CR>", { desc = 'Force close/e[X]it active buffer' })
vim.keymap.set('n', '<leader>x', ":bd<CR>",
	{ desc = 'Close/e[X]it active buffer if there are no pending changes to save' })
vim.keymap.set('n', '<leader>o', ":only<CR>", { desc = 'Make the current window the [o]nly one visible' })
------ formatting
vim.keymap.set('n', '<leader>F', ":Format<CR>", { desc = 'Format current buffer with LSP' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up and reformat properly along the way' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down and reformat properly along the way' })

---- windows
vim.keymap.set('n', '<char-172>', "<C-w>l", { desc = 'Move to the window to the right M-l' })
vim.keymap.set('n', '<char-729>', "<C-w>h", { desc = 'Move to the window to the left M-h' })
vim.keymap.set('n', '<char-730>', "<C-w>k", { desc = 'Move to the window above M-k' })
vim.keymap.set('n', '<char-8710>', "<C-w>j", { desc = 'Move to the window below M-j' })
vim.keymap.set('n', '<char-231>', "<C-w>c", { desc = 'Close window pane M-c' })
vim.keymap.set('n', '<char-177>', "<C-w>>", { desc = 'Increase window size horizontally M-S-+' })
vim.keymap.set('n', '<char-8212>', "<C-w><", { desc = 'Decrease window size horizontally M-S--' })
vim.keymap.set('n', '<char-8211>', "<C-w>-", { desc = 'Decrease window size vertically M--' })
vim.keymap.set('n', '<char-8800>', "<C-w>+", { desc = 'Increase window size vertically - M-+' })

---- tabs
vim.keymap.set('n', '<Left>', "gT", { desc = 'Navigate to tab to the left' })
vim.keymap.set('n', '<Right>', "gt", { desc = 'Navigate to tab to the right' })

---- visual mode
vim.keymap.set('v', '<Left>', "<gv", { desc = 'Indent text to the left in visual mode' })
vim.keymap.set('v', '<Right>', ">gv", { desc = 'Indent text to the right in visual mode' })
vim.keymap.set('v', '<leader>dg', ":diffget<CR>", { desc = 'Indent text to the right in visual mode' })
vim.keymap.set('v', '<leader>dp', ":diffput<CR>", { desc = 'Indent text to the right in visual mode' })

---- vim fugitive (Git)
vim.keymap.set('n', '<leader>gb', ":Git blame<CR>", { desc = '[g]it [b]lame' })
vim.keymap.set('n', '<leader>gb', ":Git commit<CR>", { desc = '[g]it [c]commit' })
vim.keymap.set('n', '<leader>gd', ":Gdiffsplit<CR>", { desc = '[g]it [d]iff' })
vim.keymap.set('n', '<leader>gl', ":Gclog<CR>", { desc = '[g]it [l]og' })
vim.keymap.set('n', '<leader>gs', ":G<CR>", { desc = '[g]it [s]tatus' })
------ stage/unstage in visual mode
vim.keymap.set('v', '<leader>g', ":diffget<CR>", { desc = 'stage' })
vim.keymap.set('v', '<leader>p', ":diffput<CR>", { desc = 'unstage' })
------ merge conflicts
vim.keymap.set('n', '<leader>gH', ":diffget //2<CR>", { desc = 'merge from left' })
vim.keymap.set('n', '<leader>gL', ":diffget //3<CR>", { desc = 'merge from right' })

-- auto commands
vim.cmd [[
	augroup python_save | au!
		autocmd BufWritePost *.py silent! !black <afile>:p:S
	augroup end
]]

