"==============================================================
" config/ui/font.vim
" 字体设定：仅在支持 GUI 的 Vim/Neovim 中生效
"==============================================================

if exists('g:loaded_font_config')
  finish
endif
let g:loaded_font_config = 1

" Windows 推荐字体
let g:font_win = get(g:, 'font_win', 'Maple Mono NF CN:h12')

if has('gui_running')
  if has('win32') || has('win64')
    execute 'set guifont=' . escape(g:font_win, ' ')
    " 启动时自动最大化窗口（Windows 专用）
    " simalt ~x 是 Windows 的窗口最大化快捷键
    autocmd GUIEnter * simalt ~x
  endif
endif

