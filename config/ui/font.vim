"==============================================================
" config/ui/font.vim
" 字体配置：GUI 模式字体设置
"==============================================================

if exists('g:loaded_font_config')
  finish
endif
let g:loaded_font_config = 1

"==============================================================
" 0. 连字控制配置
"==============================================================
" 是否启用连字（ligature）效果
" 已关闭连字以避免光标经过时显示异常
" 关闭连字后，-> 会显示为 -> 而不是 →，但显示更稳定
let g:enable_font_ligatures = get(g:, 'enable_font_ligatures', 0)

"==============================================================
" 1. Windows 字体配置
"==============================================================
" 使用 Maple Mono NL NFMono CN（适配图标显示，支持全宽图标）
" 如果字体名称不对，可以尝试其他变体
" 注意：已关闭连字功能，显示更稳定
let g:font_win = get(g:, 'font_win', 'Maple Mono NL NFMono CN:h12')

"==============================================================
" 2. Linux 字体配置
"==============================================================
" 使用 Maple Mono NL NFMono CN（适配图标显示，支持全宽图标）
" 如果字体名称不对，可以尝试其他变体
" 注意：已关闭连字功能，显示更稳定
let g:font_linux = get(g:, 'font_linux', 'Maple Mono NL NFMono CN 12')

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

