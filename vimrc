let g:is_win = has("win32") || has("win64")
let g:vim_dir = g:is_win ? ($HOME . '/vimfiles') : ($HOME . '/.vim')

execute 'set rtp^=' . fnameescape(g:vim_dir)
execute 'set rtp+=' . fnameescape(g:vim_dir . '/after')
let &packpath = &runtimepath

if filereadable(g:vim_dir . '/pluginlist.vim')
    " execute 'source ' . g:vim_dir . '/pluginlist.vim'
    call plug#begin()
        "so $VIMHOME/pluginlist.vim
        execute 'source ' . g:vim_dir . '/pluginlist.vim'
    call plug#end()
endif


