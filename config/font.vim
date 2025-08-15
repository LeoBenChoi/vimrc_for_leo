" ============================================================================
" File:         ~/.vim/config/font.vim
" Description:  设置 GUI 字体，支持平台自动判断和字体存在性检测
" ============================================================================

" 确保只加载一次
if exists('g:loaded_fnot')
        finish
endif
let g:loaded_fnot = 1

if has('gui_running')
        " 字体优先级可以根据if函数判断顺序调整优先级

        " 判断字体是否存在函数（仅适用于 GUI）
        function! s:font_exists(fontname) abort
                try
                        execute 'set guifont=' . a:fontname
                        return &guifont ==# substitute(a:fontname, '\\ ', ' ', 'g')
                catch
                        return 0
                endtry
        endfunction

        " Windows 平台字体优先级设置
        if has('win32') || has('win64')
                if s:font_exists('更纱终端书呆黑体-简:h14:cGB2312:qDRAFT')
                        set guifont=更纱终端书呆黑体-简:h14:cGB2312:qDRAFT
                elseif s:font_exists('Consolas:h12:cANSI:qDRAFT')
                        set guifont=Consolas:h12:cANSI:qDRAFT
                endif

        " macOS 字体配置
        "   elseif has('macunix')
        "     if s:font_exists('SF\ Mono:h13')
        "       set guifont=SF\ Mono:h13
        "     elseif s:font_exists('Menlo\ for\ Powerline:h13')
        "       set guifont=Menlo\ for\ Powerline:h13
        "     endif

        " Linux 字体配置
        elseif has('unix')
                if s:font_exists('Sarasa\ Term\ SC\ Nerd\ 10')
                        set guifont=Sarasa\ Term\ SC\ Nerd\ 10
                endif
                if s:font_exists('JetBrainsMono\ Nerd\ Font\ Mono:h12')
                        set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h12
                elseif s:font_exists('FiraCode\ Nerd\ Font\ Mono:h12')
                        set guifont=FiraCode\ Nerd\ Font\ Mono:h12
                endif
        endif
endif
