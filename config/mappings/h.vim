"==============================================================
" config/mappings/h.vim
" 快捷键映射：高亮相关功能
"==============================================================

if exists('g:loaded_highlight_mappings')
  finish
endif
let g:loaded_highlight_mappings = 1

"==============================================================
" 0. 检查是否使用插件（vim-cursorword）
"==============================================================
" 如果已安装 vim-cursorword 插件，则禁用自定义实现
" vim-cursorword 是轻量级插件，无需配置即可使用
if exists('g:loaded_cursorword')
  " 插件已加载，禁用自定义实现
  finish
endif

"==============================================================
" 1. 自动高亮当前单词（光标移动时自动高亮）
"==============================================================
" 注意：这是自定义实现，如果安装了 vim-cursorword 插件，此部分不会执行
" 功能：当光标移动到某个位置时，自动高亮当前单词在当前文件中的所有出现位置
" 使用场景：快速查看变量、函数名等在文件中的所有使用位置

" 高亮组 ID（用于清除高亮）
" s:highlight_id: 其他匹配位置的高亮（灰色）
" s:cursor_highlight_id: 光标位置的高亮（黑色）
let s:highlight_id = 0
let s:cursor_highlight_id = 0

" 上次高亮的单词（用于避免重复高亮）
let s:last_highlighted_word = ''

" 是否启用自动高亮（默认启用）
let g:auto_highlight_cursor_word = get(g:, 'auto_highlight_cursor_word', 1)

" 初始化时定义高亮组（在 VimEnter 时执行，确保主题已加载）
augroup AutoHighlightInit
  autocmd!
  autocmd VimEnter * call s:DefineHighlightGroups()
augroup END

" 高亮当前单词的函数
function! s:HighlightCursorWord() abort
  " 如果功能被禁用，直接返回
  if !g:auto_highlight_cursor_word
    return
  endif

  " 检查光标下的字符是否是单词字符
  " 如果光标在特殊字符（如引号、括号等）上，不应该高亮后面的单词
  let l:line = getline('.')
  let l:col = col('.')
  let l:char = l:col > len(l:line) ? '' : l:line[l:col - 1]
  
  " 如果光标下的字符不是单词字符（\w），清除高亮并返回
  " \w 匹配字母、数字和下划线
  if empty(l:char) || l:char !~# '\w'
    call s:ClearAllHighlights()
    let s:last_highlighted_word = ''
    return
  endif

  " 获取光标下的单词
  " 使用 expand('<cword>') 获取当前单词（只匹配单词字符）
  let l:word = expand('<cword>')

  " 如果单词为空或太短（少于 2 个字符），清除高亮并返回
  if empty(l:word) || len(l:word) < 2
    call s:ClearAllHighlights()
    let s:last_highlighted_word = ''
    return
  endif

  " 如果单词与上次相同，只需要更新光标位置的高亮
  " 重要：在单词内移动时，不应该清除高亮
  if l:word ==# s:last_highlighted_word
    " 高亮已存在，只需要更新光标位置的高亮
    call s:UpdateCursorHighlight()
    return
  endif

  " 清除之前的高亮（只有在单词不同时才清除）
  call s:ClearAllHighlights()

  " 更新上次高亮的单词
  let s:last_highlighted_word = l:word

  " 构建匹配模式
  " \b 表示单词边界，但在 Vim 中使用 \< 和 \> 表示单词边界
  " \<word\> 匹配完整的单词（不匹配部分单词）
  let l:pattern = '\<' . escape(l:word, '.*^$~[]\') . '\>'

  " 定义自定义高亮组（根据背景色动态调整）
  call s:DefineHighlightGroups()

  " 添加所有匹配位置的高亮（灰色，优先级较低）
  let s:highlight_id = matchadd('CursorWordHighlight', l:pattern, -1)
  
  " 添加光标位置的高亮（黑色，优先级较高，会覆盖光标位置的灰色高亮）
  call s:UpdateCursorHighlight()
endfunction

" 定义高亮组（根据背景色动态调整）
function! s:DefineHighlightGroups() abort
  " 根据背景色选择不同的颜色方案
  if &background ==# 'light'
    " 浅色背景：使用深色高亮
    " 其他匹配位置：深灰色高亮
    if has('win32') || has('win64') || has('win16')
      highlight CursorWordHighlight ctermbg=240 ctermfg=255 cterm=NONE guibg=#585858 guifg=#ffffff gui=NONE
    else
      highlight CursorWordHighlight ctermbg=240 ctermfg=NONE guibg=#585858 guifg=NONE
    endif
    
    " 光标位置：深黑色高亮（更明显）
    if has('win32') || has('win64') || has('win16')
      highlight CursorWordAtCursor ctermbg=0 ctermfg=255 cterm=bold,underline guibg=#000000 guifg=#ffffff gui=bold,underline
    else
      highlight CursorWordAtCursor ctermbg=0 ctermfg=NONE cterm=bold guibg=#000000 guifg=NONE gui=bold
    endif
  else
    " 深色背景：使用更明显的高亮
    " 其他匹配位置：使用更亮的背景色，确保在深色背景下清晰可见
    if has('win32') || has('win64') || has('win16')
      " Windows 终端：使用更亮的灰色背景 + 白色前景（确保对比度）
      highlight CursorWordHighlight ctermbg=240 ctermfg=255 cterm=NONE guibg=#585858 guifg=#ffffff gui=NONE
    else
      " Linux/Mac：使用更亮的灰色背景（在深色背景下更明显）
      highlight CursorWordHighlight ctermbg=240 ctermfg=NONE guibg=#585858 guifg=NONE
    endif
    
    " 光标位置：使用白色或亮黄色背景（在深色背景下更明显）
    if has('win32') || has('win64') || has('win16')
      " Windows 终端：使用白色背景 + 黑色前景（最明显）
      highlight CursorWordAtCursor ctermbg=255 ctermfg=0 cterm=bold,underline guibg=#ffffff guifg=#000000 gui=bold,underline
    else
      " Linux/Mac：使用亮黄色背景（在深色背景下明显）
      highlight CursorWordAtCursor ctermbg=226 ctermfg=0 cterm=bold guibg=#ffff00 guifg=#000000 gui=bold
    endif
  endif
endfunction

" 更新光标位置高亮的函数
function! s:UpdateCursorHighlight() abort
  " 清除之前的光标位置高亮
  if s:cursor_highlight_id > 0
    try
      call matchdelete(s:cursor_highlight_id)
    catch /E803/
      " E803: ID not found - 忽略此错误
    catch /.*/
      " 其他错误也忽略
    endtry
    let s:cursor_highlight_id = 0
  endif
  
  " 获取光标下的单词
  let l:word = expand('<cword>')
  if empty(l:word) || len(l:word) < 2
    return
  endif
  
  " 获取光标位置
  let l:line = line('.')
  let l:col = col('.')
  let l:line_text = getline(l:line)
  
  " 使用 matchstrpos 在当前行查找所有匹配的单词
  " 找到包含光标位置的那个匹配
  let l:pattern = '\<' . escape(l:word, '.*^$~[]\') . '\>'
  let l:start_pos = 0
  let l:found = 0
  
  " 在当前行查找所有匹配，找到包含光标位置的那个
  while 1
    let l:match_result = matchstrpos(l:line_text, l:pattern, l:start_pos)
    if empty(l:match_result[0])
      " 没有找到更多匹配
      break
    endif
    
    let l:match_start = l:match_result[1] + 1  " matchstrpos 返回 0-based，需要 +1
    let l:match_end = l:match_result[2] + 1     " matchstrpos 返回 0-based，需要 +1
    
    " 检查光标是否在这个匹配范围内
    if l:col >= l:match_start && l:col <= l:match_end
      " 找到光标所在的单词位置
      " 使用 matchaddpos 为光标位置添加高亮（优先级更高）
      " 优先级设置为 0，确保覆盖其他匹配的灰色高亮
      let s:cursor_highlight_id = matchaddpos('CursorWordAtCursor', [[l:line, l:match_start, len(l:word)]], 0)
      let l:found = 1
      break
    endif
    
    " 继续查找下一个匹配
    let l:start_pos = l:match_end
  endwhile
  
  " 如果没找到（理论上不应该发生），使用备用方法
  if !l:found
    " 使用 searchpos 作为备用方法
    let l:pos = searchpos(l:pattern, 'bcn', l:line)
    if l:pos[1] > 0
      let s:cursor_highlight_id = matchaddpos('CursorWordAtCursor', [[l:line, l:pos[1], len(l:word)]], 0)
    endif
  endif
endfunction

" 清除所有高亮的函数
function! s:ClearAllHighlights() abort
  if s:highlight_id > 0
    try
      call matchdelete(s:highlight_id)
    catch /E803/
      " E803: ID not found - 忽略此错误（高亮可能已被清除）
    catch /.*/
      " 其他错误也忽略，避免干扰
    endtry
    let s:highlight_id = 0
  endif
  
  if s:cursor_highlight_id > 0
    try
      call matchdelete(s:cursor_highlight_id)
    catch /E803/
      " E803: ID not found - 忽略此错误
    catch /.*/
      " 其他错误也忽略
    endtry
    let s:cursor_highlight_id = 0
  endif
endfunction

" 清除高亮的函数（保持向后兼容）
function! s:ClearCursorWordHighlight() abort
  call s:ClearAllHighlights()
  let s:last_highlighted_word = ''
endfunction

" 切换自动高亮功能的函数
function! s:ToggleAutoHighlight() abort
  let g:auto_highlight_cursor_word = !g:auto_highlight_cursor_word
  if g:auto_highlight_cursor_word
    echo '自动高亮当前单词：已启用'
    call s:HighlightCursorWord()
  else
    echo '自动高亮当前单词：已禁用'
    call s:ClearCursorWordHighlight()
  endif
endfunction

" 重新应用高亮的函数（在主题切换后调用）
function! s:ReapplyHighlight() abort
  " 重新定义高亮组（根据新的背景色）
  call s:DefineHighlightGroups()
  
  " 如果有正在高亮的单词，重新应用高亮
  if !empty(s:last_highlighted_word) && g:auto_highlight_cursor_word
    " 清除旧的高亮
    call s:ClearAllHighlights()
    " 重新应用高亮
    call s:HighlightCursorWord()
  endif
endfunction

" 自动命令：光标移动时高亮当前单词
augroup AutoHighlightCursorWord
  autocmd!
  " 普通模式和可视模式下光标移动时高亮
  autocmd CursorMoved,CursorMovedI * call s:HighlightCursorWord()
  " 离开缓冲区时清除高亮（排除特殊缓冲区，如 NERDTree）
  autocmd BufLeave * if &filetype !=# 'nerdtree' | call s:ClearCursorWordHighlight() | endif
  " 主题切换后重新应用高亮
  autocmd ColorScheme * call s:ReapplyHighlight()
  " 背景色切换后重新应用高亮
  autocmd OptionSet background call s:ReapplyHighlight()
  " 进入插入模式时清除高亮（可选，如果觉得插入模式下高亮干扰可以启用）
  " autocmd InsertEnter * call s:ClearCursorWordHighlight()
  " 离开插入模式时恢复高亮
  " autocmd InsertLeave * call s:HighlightCursorWord()
augroup END

"==============================================================
" 2. 快捷键映射
"==============================================================
" <leader>hh : 切换自动高亮当前单词功能
nnoremap <silent> <leader>hh :call <SID>ToggleAutoHighlight()<CR>

" <leader>hc : 手动清除当前单词高亮
nnoremap <silent> <leader>hc :call <SID>ClearCursorWordHighlight()<CR>

" <leader>hH : 手动高亮当前单词（即使功能被禁用）
nnoremap <silent> <leader>hH :call <SID>HighlightCursorWord()<CR>

"==============================================================
" 3. 帮助信息
"==============================================================
" 快捷键说明：
"   <leader>hh : 切换自动高亮当前单词功能（开/关）
"   <leader>hc : 手动清除当前单词高亮
"   <leader>hH : 手动高亮当前单词（即使功能被禁用）
"
" 功能说明：
"   - 默认启用，光标移动时自动高亮当前单词
"   - 只高亮完整单词（不匹配部分单词）
"   - 单词长度至少 2 个字符才会高亮
"   - 光标位置：黑色高亮（更明显，加粗+下划线）
"   - 其他匹配位置：灰色高亮（较柔和）
"   - 切换缓冲区时自动清除高亮
"   - 可以通过 <leader>hh 随时开启/关闭功能

