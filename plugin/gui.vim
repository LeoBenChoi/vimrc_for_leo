" =======================================================
" GUI 图形界面专属
" =======================================================
if has("gui_running")
  set guifont=Maple_Mono_NL_NFMono_CN:h12
  set guioptions-=m
  set guioptions-=T
  set guioptions-=e
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L
  set notitle
  " 启动时自动最大化窗口（Windows GVim）
  if has('win32') || has('win64')
    autocmd GUIEnter * simalt ~x
  endif
endif