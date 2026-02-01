if exists('g:loaded_statusline') || &compatible
  finish
else
  let g:loaded_statusline = 'yes'
endif

" =======================================================
" [Native Statusline] 智能诊断定位版
" =======================================================
set laststatus=2

" --- 1. 核心逻辑：获取第一个错误的行号 ---
" 原理：查找当前缓冲区所有 Sign，找到第一个名字叫 'CocErrorSign' 的
function! s:GetFirstErrorLine() abort
  " 获取所有组的 signs
  let l:signs_list = sign_getplaced(bufnr('%'), {'group': '*'})
  
  for l:group in l:signs_list
    for l:sign in l:group.signs
      " 找到第一个错误标记，直接返回行号 (Vim 默认按行号排序返回，所以第一个就是最靠前的)
      if l:sign.name ==# 'CocErrorSign'
        return l:sign.lnum
      endif
    endfor
  endfor
  return 0
endfunction

" --- 2. 状态栏显示逻辑 ---
function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []

  " [处理错误] E1 -> E1(L11)
  if get(info, 'error', 0)
    let err_msg = 'E' . info['error']
    
    " 🕵️ 关键：如果有错误，去查一下位置
    let err_line = s:GetFirstErrorLine()
    if err_line > 0
        let err_msg .= '(L' . err_line . ')'
    endif
    
    call add(msgs, err_msg)
  endif

  " [处理警告] W2
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif

  " 格式化输出: [E1(L11) W2]
  return empty(msgs) ? '' : ' [' . join(msgs, ' ') . ']'
endfunction

function! StatusCoc() abort
  let status = get(g:, 'coc_status', '')
  return empty(status) ? '' : ' (' . status . ') '
endfunction

" --- 3. 组装状态栏 ---
set statusline=%f\ %h%w%m%r
set statusline+=%{StatusDiagnostic()}   " <--- 这里会显示 [E1(L11)]
set statusline+=%=
set statusline+=%{StatusCoc()}
set statusline+=%-14.(%l,%c%V%)\ %P