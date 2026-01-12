"==============================================================
" config/vimrc.vim
" Vim 配置入口文件：负责加载所有配置文件
" 注意：此文件由 ~/.vimrc 或 ~/.vim/.vimrc 加载
"==============================================================

"==============================================================
" 安全保护：确保脚本只加载一次
"==============================================================
if exists('g:loaded_custom_vimrc')
    finish
endif
let g:loaded_custom_vimrc = 1

"==============================================================
" 记录启动时间（用于状态栏显示）
"==============================================================
let g:vim_start_time = reltime()
let g:show_startup_time = 1

"==============================================================
" 路径与平台检测
"==============================================================
let s:this_file_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:candidate_dirs = [
            \ s:this_file_dir,
            \ s:this_file_dir . '/..',
            \ expand('~/.vim')
            \ ]
let s:vim_home = ''
for dir in s:candidate_dirs
    if isdirectory(dir . '/config')
        let s:vim_home = dir
        break
    endif
endfor
if empty(s:vim_home)
    let s:vim_home = s:this_file_dir
endif
let s:config_root = s:vim_home . '/config'

" 提供一个通用的模块加载函数，失败时给出提示但不中断
function! s:source_if_exists(path) abort
    if filereadable(a:path)
        execute 'source' fnameescape(a:path)
    else
        echomsg '[vimrc] 未找到模块: ' . a:path
    endif
endfunction

"==============================================================
" coc.nvim 用户配置（必须在插件加载前设置）
"==============================================================
" 注意：g:coc_user_config 只在 coc.nvim 初始化时生效
" 如果在此之后修改，需要使用 coc#config() 函数
let g:coc_user_config = {
  \ 'suggest.noselect': v:true,
  \ }

"==============================================================
" 插件管理（必须在基础配置之前加载）
"==============================================================
call s:source_if_exists(s:config_root . '/plugins/plugins.vim')

"==============================================================
" 基础配置
"==============================================================
call s:source_if_exists(s:config_root . '/init/basic.vim')
call s:source_if_exists(s:config_root . '/init/filetype.vim')
call s:source_if_exists(s:config_root . '/init/indent.vim')
call s:source_if_exists(s:config_root . '/init/fold.vim')
call s:source_if_exists(s:config_root . '/init/performance.vim')

"==============================================================
" 快捷键映射（按字母顺序加载）
"==============================================================
" 核心映射（包含 F 键和索引）
call s:source_if_exists(s:config_root . '/mappings/core.vim')
" 按字母顺序加载映射文件
call s:source_if_exists(s:config_root . '/mappings/a.vim')
call s:source_if_exists(s:config_root . '/mappings/c.vim')
call s:source_if_exists(s:config_root . '/mappings/e.vim')
call s:source_if_exists(s:config_root . '/mappings/f.vim')
call s:source_if_exists(s:config_root . '/mappings/g.vim')
call s:source_if_exists(s:config_root . '/mappings/h.vim')
call s:source_if_exists(s:config_root . '/mappings/j.vim')
call s:source_if_exists(s:config_root . '/mappings/k.vim')
call s:source_if_exists(s:config_root . '/mappings/l.vim')
call s:source_if_exists(s:config_root . '/mappings/n.vim')
call s:source_if_exists(s:config_root . '/mappings/p.vim')
call s:source_if_exists(s:config_root . '/mappings/q.vim')
call s:source_if_exists(s:config_root . '/mappings/r.vim')
call s:source_if_exists(s:config_root . '/mappings/s.vim')
call s:source_if_exists(s:config_root . '/mappings/t.vim')
call s:source_if_exists(s:config_root . '/mappings/v.vim')
call s:source_if_exists(s:config_root . '/mappings/w.vim')

"==============================================================
" UI 配置（关键配置同步加载）
"==============================================================
call s:source_if_exists(s:config_root . '/ui/theme.vim')
call s:source_if_exists(s:config_root . '/ui/font.vim')
" startify 配置必须在 VimEnter 之前加载（插件在 VimEnter 时读取配置）
call s:source_if_exists(s:config_root . '/ui/startify.vim')

"==============================================================
" 异步加载配置（优化启动时间）
"==============================================================
" 异步加载函数：使用 timer 延迟加载非关键配置
function! s:async_source(path, delay) abort
    if has('timers')
        " 使用 timer 延迟加载，不阻塞启动
        call timer_start(a:delay, {-> s:source_if_exists(a:path)}, {'repeat': 1})
    else
        " 如果不支持 timer，立即加载
        call s:source_if_exists(a:path)
    endif
endfunction

" 立即加载的配置（关键配置，需要立即生效）
" rainbow 配置需要立即加载，因为主题加载时需要它
call s:source_if_exists(s:config_root . '/plugins/rainbow.vim')

" UI 配置（非关键，异步加载，延迟 50ms）
call s:async_source(s:config_root . '/ui/statusline.vim', 50)

" 插件配置（异步加载，延迟 100ms，确保插件已加载）
call s:async_source(s:config_root . '/plugins/fzf.vim', 100)
call s:async_source(s:config_root . '/plugins/lsp_coc.vim', 100)
call s:async_source(s:config_root . '/plugins/vista.vim', 100)
call s:async_source(s:config_root . '/plugins/todo.vim', 100)
call s:async_source(s:config_root . '/plugins/git.vim', 100)
call s:async_source(s:config_root . '/plugins/nerdtree.vim', 100)

"==============================================================
" 环境检查配置（手动触发，不影响性能）
"==============================================================
call s:source_if_exists(s:config_root . '/check/go_lsp.vim')
call s:source_if_exists(s:config_root . '/check/fzf.vim')