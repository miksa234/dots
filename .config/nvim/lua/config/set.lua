vim.cmd('filetype on')
vim.cmd('filetype plugin indent on')

vim.bo.filetype = "on"
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.show_whitespace = 1
vim.g.loaded_perl_provider = false
vim.opt.termguicolors = true

vim.opt.clipboard = "unnamedplus"

vim.opt.ignorecase = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.expandtab = true

vim.opt.undodir = os.getenv("XDG_STATE_HOME") .. "/nvim/undodir"
vim.opt.undofile = true

vim.opt.scrolloff = 10
vim.opt.hlsearch = false

vim.opt.ttimeoutlen = 0
vim.opt.timeoutlen = 1000

vim.opt.scrolloff = 10
vim.opt.mouse = ""
vim.opt.mousescroll = "ver:0,hor:0"
vim.opt.wildmode= "longest,list,full"
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.viminfofile = os.getenv("XDG_STATE_HOME") .. "/nvim/viminfo"

vim.opt.spellsuggest = { "best", 5 }
