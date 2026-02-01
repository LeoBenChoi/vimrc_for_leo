if exists('g:loaded_statusline') || &compatible
  finish
else
  let g:loaded_statusline = 'yes'
endif

" =======================================================
" [Native Statusline] 全功能集成版
" =======================================================
set laststatus=2

" --- 1. [Git] 获取分支名称 (Fugitive) ---
function! StatusGitBranch() abort
  if !exists('*FugitiveHead')
    return ''
  endif
  let head = FugitiveHead()
  " 格式:  master
  return empty(head) ? '' : '  '.head . ' '
endfunction

" --- 2. [Git] 获取增删改统计 (GitGutter) ---
function! StatusGitHunks() abort
  if !exists('*GitGutterGetHunkSummary')
    return ''
  endif
  " 获取 [added, modified, removed] 列表
  let [a, m, r] = GitGutterGetHunkSummary()
  
  " 如果没有变更，返回空
  if a == 0 && m == 0 && r == 0
    return ''
  endif
  
  " 组装字符串: [+1 ~2 -1]
  let l:summary = ''
  if a > 0 | let l:summary .= '+' . a . ' ' | endif
  if m > 0 | let l:summary .= '~' . m . ' ' | endif
  if r > 0 | let l:summary .= '-' . r . ' ' | endif
  
  " 去掉末尾空格并加方括号
  return '[' . substitute(l:summary, ' $', '', '') . '] '
endfunction

" --- 3. [Coc] 诊断信息 (简化版: 只显示 E1) ---
function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []

  " 只显示数量，不再计算行号
  if get(info, 'error', 0)   | call add(msgs, 'E' . info['error']) | endif
  if get(info, 'warning', 0) | call add(msgs, 'W' . info['warning']) | endif

  return empty(msgs) ? '' : '[' . join(msgs, ' ') . ']'
endfunction

" --- 4. [Coc] 状态 (Formatting...) ---
function! StatusCoc() abort
  let status = get(g:, 'coc_status', '')
  return empty(status) ? '' : ' (' . status . ') '
endfunction

" --- 5. [System] 文件格式 (DOS/Linux) ---
function! StatusFileFormat() abort
  let l:fmt = &fileformat
  if l:fmt ==# 'dos'  | return 'DOS'   | endif
  if l:fmt ==# 'unix' | return 'Linux' | endif
  if l:fmt ==# 'mac'  | return 'Mac'   | endif
  return l:fmt
endfunction

" =======================================================
" 组装状态栏
" =======================================================
set statusline=
set statusline+=%f                      " 文件名
set statusline+=%{StatusGitBranch()}    " Git 分支 ( master)
set statusline+=%{StatusGitHunks()}     " Git 统计 ([+1 ~2])
set statusline+=%m%r%h%w                " 修改/只读标记 ([+])
set statusline+=%{StatusDiagnostic()}   " 诊断信息 ([E1])

set statusline+=%=                      " ========== 右对齐 ==========

set statusline+=%{StatusCoc()}          " Coc 状态
set statusline+=\ %y                    " 文件类型
set statusline+=\ %{&fileencoding?&fileencoding:&encoding} " 编码
set statusline+=\ [%{StatusFileFormat()}] " 格式 [Linux]/[DOS]
set statusline+=\ %-14.(%l,%c%V%)\ %P   " 位置