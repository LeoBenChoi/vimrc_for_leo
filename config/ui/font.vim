"==============================================================
" config/ui/font.vim
" 字体配置：GUI 模式字体设置
"==============================================================

if exists('g:loaded_font_config')
    finish
endif
let g:loaded_font_config = 1

"==============================================================
" 字体配置
"==============================================================
" Windows 字体配置
" 使用 Maple_Mono_NL_NFMono_CN，字体大小 12
let g:font_win = get(g:, 'font_win', 'Maple_Mono_NL_NFMono_CN:h12')

" Linux 字体配置
" 使用 Maple_Mono_NL_NFMono_CN，字体大小 12
let g:font_linux = get(g:, 'font_linux', 'Maple_Mono_NL_NFMono_CN 12')

" Mac 字体配置
let g:font_mac = get(g:, 'font_mac', 'Maple_Mono_NL_NFMono_CN:h12')

"==============================================================
" GUI 字体设置
"==============================================================
if has('gui_running')
    if has('win32') || has('win64')
        " Windows 字体设置
        " 格式：字体名:h大小
        execute 'set guifont=' . escape(g:font_win, ' ')
        " 启动时最大化窗口（可选）
        " autocmd GUIEnter * simalt ~x
    elseif has('gui_macvim')
        " Mac 字体设置
        execute 'set guifont=' . escape(g:font_mac, ' ')
    elseif has('gui_gtk2') || has('gui_gtk3') || has('gui_motif')
        " Linux gvim 字体设置（GTK2/GTK3/Motif）
        " 格式：字体名 大小
        execute 'set guifont=' . escape(g:font_linux, ' ')
    endif
endif
