"==============================================================
" config/plugins/todo.vim
" TODO 搜索功能（Vim 原生）
"==============================================================

if exists('g:loaded_todo_config')
  finish
endif
let g:loaded_todo_config = 1

"==============================================================
" 1. TODO 高亮显示配置
"==============================================================
" hi Todo term=bold ctermfg=0 ctermbg=15 gui=NONE guifg=NONE

"==============================================================
" 2. TODO 窗口管理（参考 Vista 实现）
"==============================================================

" 初始化 TODO 全局变量
function! s:InitTodo() abort
  if !exists('g:todo')
    let g:todo = {}
  endif
endfunction

" 查找 __todo__ 窗口编号
function! s:TodoWinnr() abort
  return bufwinnr('__todo__')
endfunction

" 查找 __todo__ 窗口 ID
function! s:TodoWinid() abort
  if exists('*bufwinid')
    return bufwinid('__todo__')
  endif
  return -1
endfunction

" 创建新的 TODO 窗口（参考 Vista 的 s:NewWindow）
function! s:NewTodoWindow() abort
  " 默认在下方打开，高度 5 行
  let l:position = get(g:, 'todo_sidebar_position', 'belowright')
  let l:height = get(g:, 'todo_sidebar_height', 5)
  
  if exists('g:todo_sidebar_open_cmd')
    let l:open = g:todo_sidebar_open_cmd
  else
    " 使用 split 命令从下方打开，高度为指定行数
    let l:open = l:position . ' ' . l:height . 'split'
  endif
  
  if get(g:, 'todo_sidebar_keepalt', 0)
    silent execute 'keepalt ' . l:open . ' __todo__'
  else
    silent execute l:open . ' __todo__'
  endif
  
  " 设置文件类型，触发 ftplugin
  execute 'setlocal filetype=todo'
endfunction

" 设置 TODO 窗口的缓冲区选项（参考 Vista 的 ftplugin）
function! s:SetupTodoBuffer() abort
  setlocal
    \ nonumber
    \ norelativenumber
    \ nopaste
    \ nomodeline
    \ noswapfile
    \ nocursorline
    \ nocursorcolumn
    \ colorcolumn=
    \ nobuflisted
    \ buftype=nofile
    \ bufhidden=hide
    \ nomodifiable
    \ signcolumn=no
    \ textwidth=0
    \ nolist
    \ winfixwidth
    \ winfixheight
    \ nospell
    \ nofoldenable
    \ foldcolumn=0
    \ nowrap
  
  " 设置缓冲区映射
  if !get(g:, 'todo_no_mappings', 0)
    nnoremap <buffer> <silent> q    :call <SID>CloseTodoWindow()<CR>
    nnoremap <buffer> <silent> <CR> :call <SID>JumpToTodo()<CR>
    nnoremap <buffer> <silent> <2-LeftMouse>
                                  \ :call <SID>JumpToTodo()<CR>
  endif
endfunction

" 打开或更新 TODO 窗口（参考 Vista 的 vista#sidebar#OpenOrUpdate）
function! s:OpenOrUpdateTodoWindow(rows) abort
  call s:InitTodo()
  
  " 如果缓冲区不存在，创建新窗口
  if !exists('g:todo.bufnr')
    call s:NewTodoWindow()
    let g:todo.bufnr = bufnr('%')
    let g:todo.winid = win_getid()
  else
    " 检查窗口是否存在
    let l:winnr = s:TodoWinnr()
    if l:winnr == -1
      " 窗口不存在，重新创建
      call s:NewTodoWindow()
      let g:todo.bufnr = bufnr('%')
      let g:todo.winid = win_getid()
    elseif winnr() != l:winnr
      " 窗口存在但不在当前，切换到该窗口
      noautocmd execute l:winnr . 'wincmd w'
    endif
  endif
  
  " 设置缓冲区内容
  call s:SetTodoBufferLines(a:rows)
  
  " 如果设置了不保持在 TODO 窗口，返回上一个窗口
  if !get(g:, 'todo_stay_on_open', 0)
    wincmd p
  endif
endfunction

" 设置 TODO 缓冲区内容
function! s:SetTodoBufferLines(lines) abort
  if !exists('g:todo.bufnr')
    return
  endif
  
  " 保存当前窗口
  let l:save_winnr = winnr()
  let l:winnr = s:TodoWinnr()
  
  if l:winnr != -1
    " 切换到 TODO 窗口
    execute l:winnr . 'wincmd w'
    
    " 设置为可修改，以便写入内容
    setlocal modifiable
    
    " 清空并写入新内容
    silent %delete _
    call setline(1, a:lines)
    
    " 恢复为不可修改
    setlocal nomodifiable
    
    " 返回原窗口
    execute l:save_winnr . 'wincmd w'
  endif
endfunction

" 关闭 TODO 窗口（参考 Vista 的 vista#sidebar#Close）
function! s:CloseTodoWindow() abort
  if !exists('g:todo.bufnr')
    return
  endif
  
  let l:winnr = s:TodoWinnr()
  
  " 如果当前在 TODO 窗口，先返回上一个窗口
  if l:winnr == winnr()
    wincmd p
  endif
  
  " 关闭窗口
  if l:winnr != -1
    noautocmd execute l:winnr . 'wincmd c'
  endif
  
  " 删除缓冲区
  if bufnr('__todo__') != -1
    silent execute 'bwipe! __todo__'
  endif
  
  " 清理全局变量
  if exists('g:todo.bufnr')
    unlet g:todo.bufnr
  endif
  if exists('g:todo.winid')
    unlet g:todo.winid
  endif
endfunction

" 检查 TODO 窗口是否打开
function! s:IsTodoWindowOpen() abort
  return s:TodoWinnr() != -1
endfunction

" 跳转到 TODO 项（从 TODO 窗口跳转到源文件）
function! s:JumpToTodo() abort
  if !exists('g:todo.qflist')
    return
  endif
  
  let l:current_line = line('.')
  let l:qf_list = g:todo.qflist
  
  if l:current_line < 1 || l:current_line > len(l:qf_list)
    return
  endif
  
  let l:qf_item = l:qf_list[l:current_line - 1]
  
  if !has_key(l:qf_item, 'bufnr') || l:qf_item.bufnr == 0
    return
  endif
  
  try
    " 切换到目标窗口
    if exists('*bufwinid')
      let l:winid = bufwinid(l:qf_item.bufnr)
      if l:winid != -1
        call win_gotoid(l:winid)
      else
        execute 'buffer ' . l:qf_item.bufnr
      endif
    else
      for l:winnr in range(1, winnr('$'))
        if winbufnr(l:winnr) == l:qf_item.bufnr
          execute l:winnr . 'wincmd w'
          break
        endif
      endfor
    endif
    
    " 跳转到对应行
    if has_key(l:qf_item, 'lnum') && l:qf_item.lnum > 0
      execute l:qf_item.lnum
      if has_key(l:qf_item, 'col') && l:qf_item.col > 0
        execute 'normal! ' . l:qf_item.col . '|'
      endif
      normal! zz
    endif
    
    " 如果设置了关闭窗口选项，关闭 TODO 窗口
    if get(g:, 'todo_close_on_jump', 0)
      call s:CloseTodoWindow()
    endif
  catch /^Vim\%((\a\+)\)\=:/
    " 忽略错误
  endtry
endfunction

"==============================================================
" 3. TODO 搜索和显示
"==============================================================

" 格式化 TODO 项显示（从 quickfix 项格式化为显示行）
function! s:FormatTodoItem(qf_item, index) abort
  let l:filename = bufname(a:qf_item.bufnr)
  let l:lnum = get(a:qf_item, 'lnum', 0)
  let l:text = get(a:qf_item, 'text', '')
  
  " 提取文件名（只显示文件名，不显示完整路径）
  let l:basename = fnamemodify(l:filename, ':t')
  
  " 格式化显示：文件名:行号 文本
  return printf('%s:%d %s', l:basename, l:lnum, l:text)
endfunction

" 搜索 TODO 并显示在 __todo__ 窗口中
function! s:SearchTodos() abort
  " 执行搜索
  try
    execute 'vimgrep /\/\/\ \<\(TODO\|FIXME\|XXX\)\>/gj **'
  catch /^Vim\%((\a\+)\)\=:E480/
    " 没有找到匹配项
    call s:OpenOrUpdateTodoWindow(['未找到 TODO 项'])
    return
  endtry
  
  " 获取 quickfix 列表
  let l:qf_list = getqflist()
  if empty(l:qf_list)
    call s:OpenOrUpdateTodoWindow(['未找到 TODO 项'])
    return
  endif
  
  " 保存 quickfix 列表供跳转使用
  call s:InitTodo()
  let g:todo.qflist = l:qf_list
  
  " 格式化显示行
  let l:display_lines = []
  for l:index in range(len(l:qf_list))
    call add(l:display_lines, s:FormatTodoItem(l:qf_list[l:index], l:index))
  endfor
  
  " 在 TODO 窗口中显示
  call s:OpenOrUpdateTodoWindow(l:display_lines)
endfunction

"==============================================================
" 4. TODO 窗口自动跟随（参考 Vista 实现）
"==============================================================

let s:todo_follow_timer = -1

function! s:StopTodoFollowTimer() abort
  if s:todo_follow_timer != -1
    call timer_stop(s:todo_follow_timer)
    let s:todo_follow_timer = -1
  endif
endfunction

function! s:TodoAutoFollow(_timer) abort
  " 检查是否仍在 TODO 窗口中
  if &ft != 'todo' || !exists('g:todo.qflist')
    return
  endif
  
  let l:current_line = line('.')
  let l:qf_list = g:todo.qflist
  
  if l:current_line < 1 || l:current_line > len(l:qf_list)
    return
  endif
  
  let l:qf_item = l:qf_list[l:current_line - 1]
  
  if !has_key(l:qf_item, 'bufnr') || l:qf_item.bufnr == 0
    return
  endif
  
  try
    let l:todo_winid = win_getid()
    
    " 切换到目标窗口
    if exists('*bufwinid')
      let l:winid = bufwinid(l:qf_item.bufnr)
      if l:winid != -1
        call win_gotoid(l:winid)
      else
        execute 'buffer ' . l:qf_item.bufnr
      endif
    else
      for l:winnr in range(1, winnr('$'))
        if winbufnr(l:winnr) == l:qf_item.bufnr && l:winnr != winnr()
          execute l:winnr . 'wincmd w'
          break
        endif
      endfor
    endif
    
    " 跳转到对应行
    if has_key(l:qf_item, 'lnum') && l:qf_item.lnum > 0
      execute l:qf_item.lnum
      if has_key(l:qf_item, 'col') && l:qf_item.col > 0
        execute 'normal! ' . l:qf_item.col . '|'
      endif
      normal! zz
    endif
    
    " 返回 TODO 窗口
    call win_gotoid(l:todo_winid)
  catch /^Vim\%((\a\+)\)\=:/
    try
      call win_gotoid(l:todo_winid)
    catch
    endtry
  endtry
endfunction

function! s:TodoAutoFollowWithDelay() abort
  if &ft != 'todo'
    return
  endif
  
  call s:StopTodoFollowTimer()
  
  let s:todo_follow_timer = timer_start(
        \ 100,
        \ function('s:TodoAutoFollow'),
        \ )
endfunction

"==============================================================
" 5. 命令定义
"==============================================================

command! -bar Todo call s:SearchTodos()
command! -bar TodoClose call s:CloseTodoWindow()
command! -bar TodoToggle if s:IsTodoWindowOpen() | call s:CloseTodoWindow() | else | call s:SearchTodos() | endif

"==============================================================
" 6. 文件类型和自动命令设置
"==============================================================

" 当打开 TODO 窗口时，设置缓冲区选项和自动跟随
augroup TodoFileType
  autocmd!
  autocmd FileType todo call s:SetupTodoBuffer()
  autocmd FileType todo call s:SetupTodoAutoFollow()
augroup END

function! s:SetupTodoAutoFollow() abort
  if &ft != 'todo'
    return
  endif
  
  if getbufvar(bufnr('%'), 'todo_autofollow_set', 0)
    return
  endif
  
  call setbufvar(bufnr('%'), 'todo_autofollow_set', 1)
  
  augroup TodoAutoFollowBuffer
    autocmd! * <buffer>
    autocmd CursorMoved <buffer> call s:TodoAutoFollowWithDelay()
    autocmd BufLeave <buffer> call s:StopTodoFollowTimer()
  augroup END
endfunction
