if exists('g:loaded_gui') || &compatible
  finish
else
  let g:loaded_gui = 'yes'
endif

" =======================================================
" [GUI] 图形界面专属设置
" =======================================================
if has("gui_running")
    set guifont=Maple_Mono_NL_NFMono_CN:h12
    set guioptions-=m  " 去菜单栏
    set guioptions-=T  " 去工具栏
    set guioptions-=e  " 去异常菜单
    set guioptions-=r  " 去右滚动条
    set guioptions-=R  " 去右分割条
    set guioptions-=l  " 去左滚动条
    set guioptions-=L  " 去左分割条
    set notitle        " 不显示标题
endif