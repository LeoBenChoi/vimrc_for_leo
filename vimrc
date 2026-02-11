let g:is_win = has("win32") || has("win64")
let g:vim_dir = g:is_win ? ($HOME . '/vimfiles') : ($HOME . '/.vim')

execute 'set rtp^=' . fnameescape(g:vim_dir)
if filereadable(g:vim_dir . '/plugins.vim')
    execute 'source ' . g:vim_dir . '/plugins.vim'
endif