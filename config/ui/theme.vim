"==============================================================
" config/ui/theme.vim
" 主题配置：默认使用 retrobox 深色主题
"==============================================================

if exists('g:loaded_theme_config')
    finish
endif
let g:loaded_theme_config = 1

"==============================================================
" 主题配置
"==============================================================
" 默认主题（在没有安装插件主题时使用）
let g:default_theme = get(g:, 'default_theme', 'retrobox')

" 主题模式：light 或 dark
let g:theme_mode = get(g:, 'theme_mode', 'dark')

" 启用语法高亮
syntax enable

" 设置背景色
if g:theme_mode ==# 'dark'
    set background=dark
else
    set background=light
endif

" 启用真彩色支持（如果支持）
if has('termguicolors')
    set termguicolors
endif

"==============================================================
" 加载主题
"==============================================================
function! s:load_theme() abort
    " 首先尝试加载用户指定的主题（如果已安装插件）
    " 如果主题不存在，则使用默认的 retrobox 主题
    
    " 检查是否有插件主题可用（例如 gruvbox, onedark 等）
    " 这里可以根据需要添加其他主题检查
    
    " 尝试加载默认主题
    try
        execute 'colorscheme ' . g:default_theme
        let g:colors_name = g:default_theme
    catch /^Vim\%((\a\+)\)\=:E185/
        " retrobox 不存在，尝试其他内置主题
        try
            colorscheme darkblue
            let g:colors_name = 'darkblue'
        catch
            try
                colorscheme desert
                let g:colors_name = 'desert'
            catch
                " 如果都不存在，至少设置背景色
                if g:theme_mode ==# 'dark'
                    set background=dark
                else
                    set background=light
                endif
            endtry
        endtry
    endtry
    
    " 主题加载完成后，延迟启动 Rainbow（确保 rainbow 插件已加载）
    " 使用延迟调用，确保 rainbow 在主题之后加载，避免高亮组被覆盖
    " 延迟时间增加到 200ms，确保异步加载的配置已完成
    if has('timers')
        " 延迟 200ms 启动，确保 rainbow 插件和配置已加载完成
        call timer_start(200, {-> s:start_rainbow()}, {'repeat': 1})
    else
        " 如果不支持 timer，立即尝试启动
        call s:start_rainbow()
    endif
    
    " 应用 GitGutter 高亮颜色（确保在主题加载后应用）
    call s:apply_gitgutter_highlight()
endfunction

"==============================================================
" GitGutter 高亮配置（在主题加载后应用）
"==============================================================
function! s:apply_gitgutter_highlight() abort
    " Git 相关高亮（使用与主题匹配的颜色）
    " 这些颜色会在主题加载后应用，确保不被主题覆盖
    highlight! GitGutterAdd    guifg=#98c379 ctermfg=114
    highlight! GitGutterChange guifg=#61afef ctermfg=75
    highlight! GitGutterDelete guifg=#e06c75 ctermfg=168
endfunction

"==============================================================
" 启动 Rainbow（在主题加载后调用）
"==============================================================
function! s:start_rainbow() abort
    " 先更新 rainbow 颜色配置（使用全局函数）
    if exists('*SetRainbowColors')
        call SetRainbowColors()
    endif
    
    " 检查 rainbow_main#load 函数是否存在
    if !exists('*rainbow_main#load')
        " 如果函数不存在，延迟重试（插件可能还在加载）
        if has('timers')
            call timer_start(100, {-> s:start_rainbow()}, {'repeat': 1})
        endif
        return
    endif
    
    " 显式启动 rainbow
    try
        call rainbow_main#load()
    catch
        " 如果失败，延迟重试
        if has('timers')
            call timer_start(200, {-> s:start_rainbow()}, {'repeat': 1})
        endif
    endtry
endfunction

"==============================================================
" 主题切换函数
"==============================================================
function! ToggleTheme()
    if g:theme_mode ==# 'dark'
        let g:theme_mode = 'light'
        set background=light
    else
        let g:theme_mode = 'dark'
        set background=dark
    endif
    call s:load_theme()
    " 主题切换后，重新启动 rainbow（load_theme 中已调用，这里确保执行）
    call s:start_rainbow()
    echo '主题模式: ' . g:theme_mode . ' | 主题: ' . g:colors_name
endfunction

"==============================================================
" 初始化
"==============================================================
" 在 VimEnter 时加载主题（确保所有配置已加载）
augroup ThemeLoad
    autocmd!
    autocmd VimEnter * call s:load_theme()
    " 在主题切换时也启动 rainbow（确保 rainbow 在主题之后加载）
    " 使用延迟调用，确保 rainbow 插件已准备好
    autocmd ColorScheme * if has('timers') | call timer_start(200, {-> s:start_rainbow()}, {'repeat': 1}) | else | call s:start_rainbow() | endif
    " 在主题切换时也应用 GitGutter 高亮
    autocmd ColorScheme * call s:apply_gitgutter_highlight()
augroup END

" 如果是在配置重新加载时，立即加载主题
if exists('g:loaded_custom_vimrc')
    call s:load_theme()
endif
