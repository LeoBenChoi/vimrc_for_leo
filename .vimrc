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

" vim-devicons Vue 图标自定义配置（必须在插件加载前设置）
" 默认 Vue 图标 '﵂' 在 Windows 终端下可能显示为乱码
" 使用更兼容的图标替代
if !exists('g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols')
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
endif
" 设置 Vue 图标（选择一个不会乱码的图标）
" 当前使用：'⚡'（闪电符号，Vue 官方 logo 类似）
" 如果还是乱码，可以尝试以下选项：
"   'V' - 大写字母 V（最兼容）
"   '◆' - 实心菱形 (U+25C6)
"   '▽' - 倒三角 (U+25BD)
"   '◈' - 空心菱形 (U+25C8)
"   '●' - 实心圆 (U+25CF)
"   '★' - 实心星 (U+2605)
"   '☆' - 空心星 (U+2606)
"   '♦' - 菱形 (U+2666)
"   '▶' - 右三角 (U+25B6)
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vue'] = '󰡄'

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
" 3.1. 文件类型检测配置
"==============================================================
call s:source_if_exists(s:config_root . '/init/filetype.vim')

"==============================================================
" 3.2. 文件类型缩进配置
"==============================================================
call s:source_if_exists(s:config_root . '/init/indent.vim')

"==============================================================
" 3.3. 文件类型折叠配置
"==============================================================
call s:source_if_exists(s:config_root . '/init/fold.vim')

"==============================================================
" 3.4. 性能优化配置
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
" 6. 快捷键映射（按字母分类）
"==============================================================
call s:source_if_exists(s:config_root . '/mappings/core.vim')
" 按字母分类的快捷键映射
call s:source_if_exists(s:config_root . '/mappings/c.vim')  " 注释功能
call s:source_if_exists(s:config_root . '/mappings/e.vim')  " 文件浏览器
call s:source_if_exists(s:config_root . '/mappings/g.vim')  " Git 操作
call s:source_if_exists(s:config_root . '/mappings/o.vim')  " 代码大纲
call s:source_if_exists(s:config_root . '/mappings/t.vim')  " 主题切换

"==============================================================
" 7. LSP 配置
"==============================================================
call s:source_if_exists(s:config_root . '/plugins/lsp_coc.vim')

"==============================================================
" 7.1. FZF 搜索配置
"==============================================================
call s:source_if_exists(s:config_root . '/plugins/fzf.vim')

"==============================================================
" 7.2. Git 插件配置
"==============================================================
call s:source_if_exists(s:config_root . '/plugins/git.vim')

"==============================================================
" 7.3. 自动高亮当前单词（vim-cursorword，无需配置）
"==============================================================

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
