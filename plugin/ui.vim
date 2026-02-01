if exists('g:loaded_ui') || &compatible
  finish
else
  let g:loaded_ui = 'yes'
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

" =======================================================
" [UI] Theme Strategy (主题策略)
" =======================================================

" 1. 全局共用设置
set background=dark    " 无论哪里，都用暗色背景

" 2. 环境判断与切换
if has("gui_running")
    " GUI 模式 (GVim) -> 使用 Retrobox
    try
        colorscheme retrobox
    catch
        " 万一 Vim 版本太老没有 retrobox，回退到默认
        colorscheme default
    endtry
    
else
    " 终端模式 (Terminal) -> 使用 Seoul256
    " 只有插件加载成功才执行，防止报错
    if globpath(&rtp, 'colors/seoul256.vim') != ""
        " 设置 Seoul256 的背景深度 (234 是经典的深灰)
        let g:seoul256_background = 234
        silent! colorscheme seoul256
    else
        " 如果没装插件，回退到默认
        colorscheme default
    endif
endif