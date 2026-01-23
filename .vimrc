let s:vim_home = expand('$HOME/.vim')
execute 'set runtimepath^=' . fnameescape(s:vim_home)
execute 'set runtimepath+=' . fnameescape(s:vim_home . '/after')
let &packpath = &runtimepath

" 【关键】在 Vim 启动扫描前，先把插件路径加进去
if filereadable(s:vim_home . '/plugins.vim')
  source ~/.vim/plugins.vim
endif