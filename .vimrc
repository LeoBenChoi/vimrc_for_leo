"==============================================================
" 0. 安全保护：确保脚本只加载一次
"==============================================================

if exists('g:loaded_custom_vimrc')
  finish
endif
let g:loaded_custom_vimrc = 1

"==============================================================
" 0.0. 记录启动时间（用于状态栏显示）
"==============================================================
let g:vim_start_time = reltime()
let g:show_startup_time = 1

"==============================================================
" 0.1. 早期插件配置（必须在所有插件加载前设置）
"==============================================================
" Vista 扩展禁用（必须在 vim-airline 加载前设置）
" Vista 使用延迟加载，但 vim-airline 启动时会尝试加载扩展
" 如果 Vista 未加载，扩展的 init 函数不存在，会导致错误
let g:airline#extensions#vista#enabled = 0

"==============================================================
" 1. 路径与平台检测
"==============================================================
let s:this_file_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:candidate_dirs = [
      \ s:this_file_dir,
      \ s:this_file_dir . '/.vim',
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
let s:is_win = has('win32') || has('win64')

" 提供一个通用的模块加载函数，失败时给出提示但不中断
function! s:source_if_exists(path) abort
  if filereadable(a:path)
    execute 'source' fnameescape(a:path)
  else
    echomsg '[vimrc] 未找到模块: ' . a:path
  endif
endfunction

"==============================================================
" 2. 环境检测
"==============================================================
call s:source_if_exists(s:config_root . '/bootstrap/env_check.vim')

"==============================================================
" 3. 基础配置
"==============================================================
call s:source_if_exists(s:config_root . '/init/basic.vim')

"==============================================================
" 3.1. 性能优化配置
"==============================================================
call s:source_if_exists(s:config_root . '/init/performance.vim')

"==============================================================
" 4. 插件管理
"==============================================================
call s:source_if_exists(s:config_root . '/ui/startify.vim')
call s:source_if_exists(s:config_root . '/plugins/plugins.vim')

"==============================================================
" 5. UI 配置
"==============================================================
call s:source_if_exists(s:config_root . '/ui/theme.vim')
call s:source_if_exists(s:config_root . '/ui/font.vim')
call s:source_if_exists(s:config_root . '/ui/statusline.vim')
call s:source_if_exists(s:config_root . '/ui/sidebar.vim')

"==============================================================
" 6. 快捷键映射
"==============================================================
call s:source_if_exists(s:config_root . '/mappings/core.vim')

"==============================================================
" 7. LSP 配置
"==============================================================
call s:source_if_exists(s:config_root . '/plugins/lsp_coc.vim')

"==============================================================
" 8. 代码大纲配置（Vista）
"==============================================================
call s:source_if_exists(s:config_root . '/ui/outline.vim')

"==============================================================
" 9. 本地覆盖
"==============================================================
if filereadable(s:vim_home . '/local.vim')
  execute 'source' fnameescape(s:vim_home . '/local.vim')
endif
