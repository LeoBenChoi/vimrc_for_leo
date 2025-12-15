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

"==============================================================
" 2. Linux 字体配置
"==============================================================
let g:font_linux = get(g:, 'font_linux', 'Maple Mono NF CN 12')

"==============================================================
" 3. GUI 字体设置
"==============================================================
if has('gui_running')
  if has('win32') || has('win64')
    " Windows 字体设置
    execute 'set guifont=' . escape(g:font_win, ' ')
    autocmd GUIEnter * simalt ~x " 最大化
  elseif has('gui_gtk2') || has('gui_gtk3') || has('gui_motif')
    " Linux gvim 字体设置（GTK2/GTK3/Motif）
    execute 'set guifont=' . escape(g:font_linux, ' ')
  endif
endif
