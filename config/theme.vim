" ========================
" 主题选择
" ========================

" 根据时间切换主题深浅色
let hour = strftime("%H")
if hour >= 7 && hour < 19
    " let g:theme_mode = 'light'  " 'dark' 或 'light'
    let g:theme_mode = 'dark'  " 暂时将 light 模式禁用
else
    let g:theme_mode = 'dark'  " 'dark' 或 'light'
endif

" let g:theme_mode = 'dark'
" 默认主题设置
" 终端推荐的主题
" habamax
" koehler
" lunaperche
" retrobox
" if !has('gui_running') && (has('win32') || has('win64'))
function! s:set_theme()
    try
        if !has('gui_running') && (has('win32') || has('win64'))
            let g:theme_mode = 'dark'
            " colorscheme lunaperche
            let g:theme_name = 'lunaperche'
            augroup CustomHighlights
                autocmd!
                " 在 Vim 完全初始化后执行（包括插件加载）
                autocmd VimEnter * call s:custom_highlights()
            augroup END
        else
            let g:theme_name = 'gruvbox'
        endif
    catch /^Vim\%((\a\+)\)\=:E185/
        echo "主题未加载"
    endtry
endfunction
call s:set_theme()




" ========================
" 主题加载函数
" ========================

function! s:load_theme()
    try
        " 加载主题包
        execute 'colorscheme ' . g:theme_name
        execute 'set background=' . g:theme_mode

        " 特殊主题配置
        if g:theme_name ==# 'gruvbox'
            let g:gruvbox_contrast_dark = 'medium'
            let g:gruvbox_italic = 1
        elseif g:theme_name ==# 'onedark'
            let g:onedark_terminal_italics = 1
        endif
    catch /^Vim\%((\a\+)\)\=:E185/
        " g未安装以上主题则提示
        " echohl ErrorMsg
        " echo '主题 ' . g:theme_name . ' 未安装，使用默认主题'
        " echohl None
        colorscheme default
        colorscheme retrobox
    endtry
endfunction
call s:load_theme()

" ========================
" 3. 亮/暗模式切换（已迁移到mapping里）
" ========================

" function! ToggleThemeMode()
"     if g:theme_mode ==# 'dark'
"         let g:theme_mode = 'light'
"     else
"         let g:theme_mode = 'dark'
"     endif
"     execute 'set background=' . g:theme_mode
"     call s:load_theme()
" endfunction

" ========================
" 状态栏
" ========================

" 我的原生配置很久版本前删除了，现在这部分配置交给 plug-airline.vim 这个文件配置

" ========================
" 高亮配置(放到主题加载后)
" ========================

function! s:custom_highlights()
    " 基础背景色
    if has('gui') == '0'
        highlight Normal       guibg=NONE ctermbg=NONE  " 透明背景
    endif
    " 行号高亮
    highlight LineNr       guifg=#5c6370 ctermfg=242
    highlight CursorLineNr guifg=#e5c07b ctermfg=214 gui=bold cterm=bold
    " 特殊语法高亮增强
    highlight! link TSVariable Identifier
    highlight! link TSParameter Special
    " Git 相关高亮
    highlight GitGutterAdd    guifg=#98c379 ctermfg=114
    highlight GitGutterChange guifg=#61afef ctermfg=75
    highlight GitGutterDelete guifg=#e06c75 ctermfg=168
    " 诊断信息高亮
    highlight DiagnosticError guifg=#e06c75 ctermfg=168
    highlight DiagnosticWarn  guifg=#e5c07b ctermfg=180
endfunction

" 标签栏样式
highlight TabLine      guifg=#5c6370 guibg=#282c34 gui=NONE
highlight TabLineSel   guifg=#abb2bf guibg=#3e4452 gui=BOLD
highlight TabLineFill  guifg=NONE    guibg=#282c34 gui=NONE
