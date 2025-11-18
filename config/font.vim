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
        " Maple Mono NF CN 字体 gvim 图标过大，渲染显示的时候可能只有一半
        if s:font_exists('Maple\ Mono\ NF\ CN')        
            set guifont=Maple\ Mono\ NF\ CN:h12:cANSI:qDRAFT
        elseif s:font_exists('0xProto\ Nerd\ Font\ Mono')
            set guifont=0xProto\ Nerd\ Font\ Mono:h12:cANSI:qDRAFT
        " FiraCode Nerd Font Mono 字体 gvim连字符渲染异常
        elseif s:font_exists('FiraCode\ Nerd\ Font\ Mono')
            set guifont=FiraCode\ Nerd\ Font\ Mono:h12:cANSI:qDRAFT
        elseif s:font_exists('Consolas:h10:cANSI:qDRAFT')
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
        if has('gui')
            if s:font_exists('更纱终端书呆黑体-简')
                set guifont=更纱终端书呆黑体-简\ 12
            endif
        endif
    " 需要安装字体 等距更纱黑体 SC Nerd Font
    elseif s:font_exists('Sarasa\ Term\ SC\ Nerd')
        set guifont=Sarasa\ Term\ SC\ Nerd\ 10
    elseif s:font_exists('JetBrainsMono\ Nerd\ Font\ Mono:h12')
        set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h12
    elseif s:font_exists('FiraCode\ Nerd\ Font\ Mono:h12')
        set guifont=FiraCode\ Nerd\ Font\ Mono:h12
    endif
endif

