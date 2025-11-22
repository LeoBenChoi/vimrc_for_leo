"==============================================================
" config/init/performance.vim
" 性能优化：针对高性能硬件的优化配置
"==============================================================

if exists('g:loaded_performance_config')
  finish
endif
let g:loaded_performance_config = 1

"==============================================================
" 1. 性能优化开关
"==============================================================
" 是否启用性能优化（默认启用）
let g:enable_performance_optimization = get(g:, 'enable_performance_optimization', 1)

" 是否启用内存优化（默认启用，适合 32GB 内存）
let g:enable_memory_optimization = get(g:, 'enable_memory_optimization', 1)

" 是否启用渲染优化（默认启用，可禁用以保留更多视觉效果）
let g:enable_render_optimization = get(g:, 'enable_render_optimization', 1)

" 是否启用超大文件优化（默认启用）
let g:enable_large_file_optimization = get(g:, 'enable_large_file_optimization', 1)

" 超大文件阈值（MB），超过此大小将启用特殊优化
let g:large_file_threshold = get(g:, 'large_file_threshold', 10)

if !g:enable_performance_optimization
  finish
endif

"==============================================================
" 2. 内存优化
"==============================================================
if g:enable_memory_optimization
  " 内存限制提升（充分利用 32GB 内存）
  set maxmempattern=8000000   " 模式匹配内存提升到 8MB（默认 1MB）
  set maxmem=4000000          " 每个缓冲区最大内存提升到 4GB（默认取决于系统）
  set maxmemtot=16000000      " Vim 总内存限制提升到 16GB（充分利用 32GB 内存）
  
  " 函数和映射深度提升
  set maxfuncdepth=400        " 最大函数嵌套深度（默认 100）
  set maxmapdepth=200         " 最大映射深度（默认 1000，降低以提升性能）
  set maxcombine=8            " 最大组合字符（默认 6）
endif

"==============================================================
" 3. CPU 优化
"==============================================================
if has('patch-7.4.1105')
  set regexpengine=2          " 使用新版正则引擎（性能更好）
endif

" 脚本执行时不重绘屏幕（提升宏和脚本执行速度）
set lazyredraw                " 执行宏/寄存器时不重绘

" 快速终端连接优化
set ttyfast                   " 快速终端连接，优化终端重绘

" 超时设置
set nottimeout                " 无键映射超时（提升响应速度）
set timeoutlen=300            " 映射等待时间（毫秒）

" 更新时间优化（降低延迟，提升响应速度）
set updatetime=50             " 降低更新时间到 50ms（默认 4000ms，影响插件响应）

" 重绘超时（充分利用高性能硬件）
set redrawtime=30000          " 增加重绘超时到 30 秒（充分利用高性能硬件）

"==============================================================
" 4. 渲染优化
"==============================================================
if g:enable_render_optimization
  " 语法高亮优化
  set synmaxcol=800           " 每行只高亮前 800 列（提升大文件性能）
  
  " 增加语法同步行数（提升语法高亮性能）
  if has('syntax')
    syntax sync minlines=300  " 语法同步最小行数（默认 100）
  endif
  if get(g:, 'disable_cursor_highlight', 0)
    set nocursorline          " 禁用光标行高亮
    set nocursorcolumn        " 禁用光标列高亮
  endif
  if get(g:, 'disable_relative_number', 0)
    set norelativenumber      " 禁用相对行号（提升大文件性能）
  endif
endif

"==============================================================
" 4. 超大文件优化（预防性配置）
"==============================================================
if g:enable_large_file_optimization
  function! s:OptimizeForLargeFile() abort
    let size = getfsize(expand('%:p'))
    let threshold = g:large_file_threshold * 1024 * 1024  " 转换为字节
    
    if size > threshold
      " 超大文件优化
      setlocal synmaxcol=200        " 减少语法高亮列数
      setlocal syntax=off           " 禁用语法高亮
      setlocal nofoldenable         " 禁用折叠
      setlocal norelativenumber     " 禁用相对行号
      setlocal updatetime=2000      " 增加更新时间
      
      echomsg '[性能优化] 检测到超大文件（' . (size / 1024 / 1024) . 'MB），已启用优化模式'
    endif
  endfunction
  
  " 打开文件时自动检测
  augroup PerformanceLargeFile
    autocmd!
    autocmd BufReadPre * call s:OptimizeForLargeFile()
  augroup END
endif

"==============================================================
" 6. GPU 加速（Windows GUI）
"==============================================================
if has('gui_running') && (has('win32') || has('win64'))
  if has('directx')
    set renderoptions=type:directx,geom:1,renmode:5 " Windows 专用 GPU 加速
  endif
  set linespace=0              " 优化文本渲染
endif

"==============================================================
" 6. 其他性能优化
"==============================================================
" 禁用某些不必要的功能以提升性能
set noshowcmd                 " 禁用命令显示（提升性能）
set noshowmode                " 禁用模式显示（vim-airline 会显示）

" 折叠优化（手动折叠性能更好）
set foldmethod=manual         " 手动折叠（语法折叠消耗大）

"==============================================================
" 7. 性能监控命令（可选）
"==============================================================
" 查看当前性能设置
function! PerformanceInfo() abort
  echomsg '=== 性能优化信息 ==='
  echomsg '内存优化: ' . (g:enable_memory_optimization ? '启用' : '禁用')
  echomsg '渲染优化: ' . (g:enable_render_optimization ? '启用' : '禁用')
  echomsg '超大文件优化: ' . (g:enable_large_file_optimization ? '启用' : '禁用')
  echomsg '超大文件阈值: ' . g:large_file_threshold . 'MB'
  echomsg '当前文件大小: ' . (getfsize(expand('%:p')) / 1024) . 'KB'
  echomsg 'maxmempattern: ' . &maxmempattern
  echomsg 'maxmem: ' . &maxmem
  echomsg 'maxmemtot: ' . &maxmemtot
  echomsg 'synmaxcol: ' . &synmaxcol
  echomsg 'updatetime: ' . &updatetime
  echomsg '=================='
endfunction
command! PerformanceInfo call PerformanceInfo()
