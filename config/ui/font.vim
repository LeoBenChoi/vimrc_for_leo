"==============================================================
" config/ui/font.vim
" 字体配置：GUI 模式字体设置
"==============================================================

if exists('g:loaded_font_config')
  finish
endif
let g:loaded_font_config = 1

"==============================================================
" 1. Windows 字体配置
"==============================================================
let g:font_win = get(g:, 'font_win', 'Maple Mono NF CN:h12')

" gui 配置
if has('gui_running')
  if has('win32') || has('win64')
    execute 'set guifont=' . escape(g:font_win, ' ')
    autocmd GUIEnter * simalt ~x " 最大化
  endif
endif
