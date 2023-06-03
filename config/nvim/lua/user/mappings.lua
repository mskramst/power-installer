-- My config
vim.g.mapleader = " "
vim.o.showmatch = true
vim.o.ruler = true
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 4
vim.bo.autoindent = true
vim.wo.relativenumber = true
vim.bo.textwidth = 80
vim.bo.tabstop = 4
vim.bo.expandtab = true
vim.wo.nu = true
vim.wo.cc = "80"

-- {{Personal Quick Actions}}
local keymap = vim.api.nvim_set_keymap
keymap('n','<c-s>', ':w<CR>', {})
keymap('i','<c-s>', '<ESC>:w<CR>a', {})
keymap('n','<Leader>so', ':so %<CR>', {})
keymap('n','<Leader>vim', ':e ~/.config/nvim/lua/user/mappings.lua<CR>', {})
keymap('n','<Leader>plug', ':e ~/.config/nvim/lua/user/plugins.lua<CR>', {})
keymap('n','<Leader>gg', ':Telescope find_files<CR>', {})
keymap('n','<Leader>buf', ':Telescope buffers<CR>', {})
keymap('n','<Leader>bp', ':bp<CR>', {})
keymap('n','<Leader>bn', ':bn<CR>', {})
keymap('i','<Leader>cde', 'i```<CR><CR>```', {})
keymap('n','<Leader>o', ':on', {})
keymap('n','<Leader>q', ':q', {})

-- {{Split Navigation}}
local opts = { noremap = true };
keymap('n','<c-j>', '<c-w>j', opts)
keymap('n','<c-h>', '<c-w>h', opts)
keymap('n','<c-k>', '<c-w>k', opts)
keymap('n','<c-l>', '<c-w>l', opts)
