" ============================================================================
" vim-airline 状态栏插件配置
" 文件位置: ~/.vim/after/plugin/airline.vim
" 说明: 此文件会在所有插件加载后自动执行，用于配置 vim-airline 插件
" ============================================================================
" 启用 Powerline 字体，以特殊符号显示三角箭头
let g:airline_powerline_fonts = 1

" 主题
if has('gui_running')
    let g:airline_theme = 'luna'
else
    let g:airline_theme = 'seoul256'
endif

" 顶部标签栏
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" 集成 coc.nvim: 在状态栏显示错误和警告数量
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#coc#error_symbol = 'E:'
let g:airline#extensions#coc#warning_symbol = 'W:'

" ============================================================================
" Z
" ============================================================================

" 获取当前光标下字符的十六进制值（简化逻辑）
function! GetHexChar()
    let l:line = getline('.')
    let l:col = col('.') - 1
    " 检查列号是否在行内，如果不在则字符不存在，返回 NULL
    if l:col >= len(l:line) || l:col < 0
        return 'NULL'
    endif
    let l:char = l:line[l:col]
    let l:code = char2nr(l:char)
    return printf("0x%02X", l:code)
endfunction

let g:airline_section_z = '%3p%% Ln:%l/%L:%02v | %{GetHexChar()} '

" ============================================================================
" 启动时间显示（10秒后自动关闭）
" ============================================================================

" 计算并更新启动时间显示
function! s:UpdateStartupTime() abort
    if !exists('g:start_time')
        return
    endif
    
    " 使用 autoload 函数获取格式化的启动时间
    let g:startup_time_display = startup_time#get_airline_string()
endfunction

" 初始化启动时间显示
function! s:AirlineStartupTimeInit() abort
    if !exists(':AirlineRefresh')
        return
    endif
    
    " 如果用户已经在文件开头直接设置了 g:airline_section_z，则不再修改
    " 检查是否包含启动时间，如果没有则添加
    if exists('g:airline_section_z') && g:airline_section_z !~# 'startup_time_display'
        " 在现有配置后添加启动时间
        let g:airline_section_z = g:airline_section_z . ' %{get(g:, "startup_time_display", "")}'
    elseif !exists('g:airline_section_z')
        " 如果没有设置，使用简单格式
        let g:airline_section_z = '%3p%% %l/%L:%02v|%{GetHexChar()} %{get(g:, "startup_time_display", "")}'
    endif
    
    " 计算启动时间
    call s:UpdateStartupTime()
    
    " 刷新状态栏
    if exists(':AirlineRefresh')
        execute 'AirlineRefresh'
    endif
endfunction

autocmd User AirlineAfterInit call s:AirlineStartupTimeInit()

" 10 秒后清除启动时间显示
function! s:ClearStartupTime() abort
    if !exists(':AirlineRefresh')
        return
    endif
    let g:startup_time_display = ''
    " 如果用户已经设置了 g:airline_section_z，移除启动时间部分
    if exists('g:airline_section_z')
        let g:airline_section_z = substitute(g:airline_section_z, ' %{get(g:, "startup_time_display", "")}', '', '')
    endif
    " 刷新状态栏
    if exists(':AirlineRefresh')
        execute 'AirlineRefresh'
    endif
endfunction

" 使用定时器在 10 秒后清除显示
if has('timers')
    let s:startup_timer = timer_start(10000, {-> s:ClearStartupTime()}, {'repeat': 1})
endif