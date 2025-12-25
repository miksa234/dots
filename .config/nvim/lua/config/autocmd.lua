local autocmd = vim.api.nvim_create_autocmd

-- Delete trailing whitespace
autocmd({'BufWritePre'}, {
	pattern = '*',
	command = [[%s/\s\+$//e]],
})

autocmd({'BufEnter'}, {
	pattern = 'justfile',
	command = "set filetype=make";
})

autocmd({'BufWritePost'}, {
	pattern = vim.fn.expand('~') .. '/.config/X/Xresources',
	command = '!xrdb %',
})

autocmd({'BufWritePost'}, {
	pattern = vim.fn.expand('~') .. '/.config/X/Xresources.mon',
	command = '!xrdb %',
})

autocmd({'BufWritePost'}, {
	pattern = vim.fn.expand('~') .. '/.local/src/dmenu/config.def.h',
	command = '!cd ~/.local/src/dmenu/; sudo make clean install && { killall -q dmenu}',
})

autocmd({'BufWritePost'}, {
	pattern = vim.fn.expand('~') .. '/.local/src/dwm/config.def.h',
	command = '!cd ~/.local/src/dwm/; sudo make clean install && { killall -q dwm;setsid dwm & }',
})

autocmd({'BufWritePost'}, {
	pattern = vim.fn.expand('~') .. '/.local/src/dwmblocks/config.h',
	command = '!cd ~/.local/src/dwmblocks/; sudo make clean install && { killall -q dwmblocks;setsid dwmblocks & }',
})

autocmd({'BufWritePost'}, {
	pattern = vim.fn.expand('~') .. '/.local/src/st/config.h',
	command = '!cd ~/.local/src/st/; sudo make clean install && { killall -q st;setsid st & }',
})

autocmd({'BufWritePost'}, {
	pattern = vim.fn.expand('~') .. '/.local/src/slock/config.h',
	command = '!cd ~/.local/src/slock/; sudo make clean install && { killall -q slock;setsid & }',
})









