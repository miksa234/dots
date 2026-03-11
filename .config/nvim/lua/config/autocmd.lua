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

-- Convert two spaces to tabs in router folder
autocmd({'BufWritePre'}, {
  pattern = '*/oari/*.ts',
  callback = function()
    vim.cmd([[%s/  /\t/ge]])
  end,
})

-- Convert tabs to two spaces on buf enter
autocmd({'BufEnter'}, {
  pattern = '*/oari/*.ts',
  callback = function()
    vim.cmd([[%s/\t/  /ge]])
  end,
})

-- Convert double qotes to single qotes on save
autocmd({'BufWritePre'}, {
  pattern = '*/oari/*.ts',
  callback = function()
    vim.cmd([[%s/"/'/ge]])
  end,
})






