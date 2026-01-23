" =======================================================
" [AsyncRun] 异步任务执行器配置
" =======================================================
" 核心作用：让 Vim 在运行外部命令（编译、测试、搜索）时不会卡死
" 命令在后台执行，输出显示在 Quickfix 窗口，可继续编辑代码

" 1. 基础设置
" 任务结束时响铃提醒 (0:关闭, 1:开启)
let g:asyncrun_bell = 1

" 停止当前正在运行的异步任务
noremap <silent> <F10> :AsyncStop<CR>

" =======================================================
" [AsyncRun] 自动化体验增强
" =======================================================

" 1. 自动打开 Quickfix 窗口
augroup AsyncRun_Auto_Toggle
    autocmd!
    " 任务开始时：自动打开底部窗口(高度6)，并不让光标跳进去
    autocmd User AsyncRunStart call asyncrun#quickfix_toggle(6, 1)
augroup END

" 2. 任务结束后的行为
function! s:asyncrun_stop()
    " 成功时：
    if g:asyncrun_status == 'success'
        " [修改点] 原来的 'call asyncrun#quickfix_toggle(0)' 被删除了
        " 现在无论成功失败，窗口都会保持打开状态
        redraw
        echohl MoreMsg | echo " [SUCCESS] 任务执行成功！" | echohl None
    
    " 失败时：
    elseif g:asyncrun_status == 'failure'
        call asyncrun#quickfix_toggle(8, 1) " 失败时把窗口拉高一点(8行)
        execute "cc" " 自动跳到第一个错误
        redraw
        echohl ErrorMsg | echo " [FAILURE] 任务执行失败，请检查错误！" | echohl None
    endif
endfunction

" 绑定结束事件
augroup AsyncRun_Stop_Event
    autocmd!
    autocmd User AsyncRunStop call s:asyncrun_stop()
augroup END

" =======================================================
" [AsyncRun] Airline 集成：在状态栏显示 AsyncRun 状态
" =======================================================

" 定义新的 accent 配色
function! AirlineThemePatch(palette)
    " [ guifg, guibg, ctermfg, ctermbg, opts ]
    " 有关 opts 的所有有效值见 :help attr-list
    " Xterm 256 色参考(https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim)
    let a:palette.accents.running = [ '', '', '', '', '' ]
    let a:palette.accents.success = [ '#00ff00', '' , 'green', '', '' ]
    let a:palette.accents.failure = [ '#ff0000', '' , 'red', '', '' ]
endfunction
let g:airline_theme_patch_func = 'AirlineThemePatch'
    
" 根据 AsyncRun 的 g:asyncrun_status（全局变量）切换状态栏区块颜色
" 'running': 默认；'success': 绿色；'failure': 红色
let g:async_status_old = ''
function! Get_asyncrun_running()

    let async_status = g:asyncrun_status
    if async_status != g:async_status_old

    if async_status == 'running'
        call airline#parts#define_accent('asyncrun_status', 'running')
    elseif async_status == 'success'
        call airline#parts#define_accent('asyncrun_status', 'success')
    elseif async_status == 'failure'
        call airline#parts#define_accent('asyncrun_status', 'failure')
    endif

    let g:airline_section_x = airline#section#create(['asyncrun_status'])
    AirlineRefresh
    let g:async_status_old = async_status

    endif

    return async_status

endfunction

call airline#parts#define_function('asyncrun_status', 'Get_asyncrun_running')
let g:airline_section_x = airline#section#create(['asyncrun_status'])

" =======================================================
" [AsyncRun] 自动构建 C/C++ 项目（保存时自动编译）
" =======================================================

augroup asyncrun_autocmd
    autocmd!
    " 当保存 .c, .cpp, .h 文件时，如果目录下有 Makefile，自动执行 make
    autocmd BufWritePost *.c,*.cpp,*.h
                \ let dir=expand('<amatch>:p:h') |
                \ if filereadable(dir.'/Makefile') || filereadable(dir.'/makefile') |
                \   execute 'AsyncRun -cwd=<root> make -j8' |
                \ endif
augroup END
