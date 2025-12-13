"==============================================================
" config/plugins/illuminate.vim
" vim-illuminate 插件配置：自动高亮光标下的单词
"==============================================================

if !exists('g:loaded_illuminate')
  finish
endif

" 设置折叠方式为标记折叠（当打开此配置文件时自动启用）
augroup IlluminateConfigFold
  autocmd!
  autocmd BufRead,BufNewFile */config/plugins/illuminate.vim setlocal foldmethod=marker foldmarker={{{,}}} foldlevel=0
augroup END

"==============================================================
" 1. 基本配置 {{{1
"==============================================================

" 高亮延迟（毫秒），避免光标快速移动时频繁更新
" 设置为 0 可以立即更新，但可能影响性能
" 推荐值：0-50 毫秒（减少延迟可以避免高亮"卡住"的问题）
" 如果仍然出现高亮卡住，设置为 0（立即更新，无延迟）
let g:Illuminate_delay = 0

" 是否高亮光标下的单词（默认启用）
let g:Illuminate_highlightUnderCursor = 1

" 在插入模式下禁用高亮（减少干扰，避免高亮卡住）
" 注意：vim-illuminate 默认在插入模式下会清除高亮
" 如果仍然出现高亮卡住，可以尝试禁用此选项（设置为 0）
" let g:Illuminate_onInsertEnter = 0
" }}}1

"==============================================================
" 2. 文件类型配置 {{{1
"==============================================================

" 禁用高亮的文件类型（某些文件类型可能不需要高亮）
let g:Illuminate_ftblacklist = ['nerdtree', 'vista', 'fzf', 'startify']

" 启用高亮的文件类型（如果设置了，只有这些文件类型会高亮）
" let g:Illuminate_ftwhitelist = ['python', 'javascript', 'typescript', 'vue', 'go']
" }}}1

"==============================================================
" 3. 单词匹配配置 {{{1
"==============================================================

" 最小单词长度（少于这个长度的单词不会被高亮）
let g:Illuminate_minimumWordLength = 2

" 是否只高亮完整单词（不匹配部分单词，如 'word' 不会匹配 'words'）
" 默认启用，推荐保持启用
let g:Illuminate_useWordBoundary = 1
" }}}1

"==============================================================
" 4. 性能优化 {{{1
"==============================================================

" 是否在插入模式下禁用高亮（减少干扰）
" 默认启用，如果觉得插入模式下高亮干扰，可以设置为 0
" let g:Illuminate_highlightUnderCursor = 0
" }}}1

"==============================================================
" 5. 自定义高亮组（重要：确保高亮可见） {{{1
"==============================================================
" vim-illuminate 使用以下高亮组：
"   - IlluminatedWordText  : 普通文本高亮
"   - IlluminatedWordRead  : 只读文本高亮
"   - IlluminatedWordWrite : 可写文本高亮
"
" 如果高亮不明显或闪烁，需要自定义这些高亮组的颜色

" 定义自定义高亮组（确保高亮明显可见）
" 注意：vim-illuminate 插件不支持区分光标位置和其他匹配位置
" 如果需要光标位置（黑色）和其他匹配（灰色）的区别，请禁用此插件，使用自定义实现（config/mappings/h.vim）
"
" Windows 终端下使用背景色高亮（更明显）
if has('win32') || has('win64') || has('win16')
  " Windows 终端：使用深色背景 + 浅色前景（灰色，用于所有匹配）
  highlight IlluminatedWordText ctermbg=238 ctermfg=250 cterm=NONE guibg=#444444 guifg=#bcbcbc gui=NONE
  highlight IlluminatedWordRead ctermbg=238 ctermfg=250 cterm=NONE guibg=#444444 guifg=#bcbcbc gui=NONE
  highlight IlluminatedWordWrite ctermbg=238 ctermfg=250 cterm=NONE guibg=#444444 guifg=#bcbcbc gui=NONE
else
  " Linux/Mac：使用更柔和的背景色（灰色，用于所有匹配）
  highlight IlluminatedWordText ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
  highlight IlluminatedWordRead ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
  highlight IlluminatedWordWrite ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
endif

" 如果还是不明显，可以尝试使用更显眼的颜色：
" highlight IlluminatedWordText ctermbg=52 ctermfg=255 cterm=bold guibg=#5f0000 guifg=#ffffff gui=bold
" highlight IlluminatedWordRead ctermbg=52 ctermfg=255 cterm=bold guibg=#5f0000 guifg=#ffffff gui=bold
" highlight IlluminatedWordWrite ctermbg=52 ctermfg=255 cterm=bold guibg=#5f0000 guifg=#ffffff gui=bold
" }}}1

"==============================================================
" 6. 快捷键映射（可选） {{{1
"==============================================================
" vim-illuminate 默认没有快捷键，如果需要可以添加

" 手动清除高亮（如果高亮卡住，可以使用此命令清除）
" 方法：强制清除所有 illuminate 高亮
" 参数：silent - 如果为 1，则不显示消息（用于自动恢复）
function! s:ClearIlluminateHighlight(...) abort
  " 静默模式标志（用于自动恢复，不显示消息）
  let l:silent = get(a:000, 0, 0)
  
  " 方法1：使用 nohlsearch（清除搜索高亮）
  nohlsearch
  
  " 方法2：如果插件提供了清除函数，调用它
  if exists('*Illuminate#pause')
    silent! call Illuminate#pause()
    silent! call Illuminate#resume()
  endif
  
  " 方法3：强制重新触发高亮更新（通过微小的光标移动）
  " 这会触发插件的更新机制
  let l:save_cursor = getpos('.')
  try
    call cursor(line('.'), col('.') + 1)
    call cursor(l:save_cursor[1], l:save_cursor[2])
  catch
    " 忽略错误
  endtry
  
  " 只在手动调用时显示消息
  if !l:silent
    echo '已清除高亮'
  endif
endfunction

" 静默清除高亮的包装函数（用于自动恢复）
function! s:ClearIlluminateHighlightSilent() abort
  call s:ClearIlluminateHighlight(1)
endfunction

" 切换高亮功能（如果插件支持）
" nnoremap <silent> <leader>hh :IlluminateToggle<CR>

" 手动清除高亮（如果高亮卡住时使用）
" 注意：这个快捷键可能与自定义实现的 <leader>hc 冲突
" 如果使用 vim-illuminate 插件，建议使用此快捷键
" 如果高亮卡住，可以按 <leader>hc 尝试清除
nnoremap <silent> <leader>hc :call <SID>ClearIlluminateHighlight()<CR>
" }}}1

"==============================================================
" 7. 自动恢复机制（修复高亮卡住问题） {{{1
"==============================================================
" 添加自动恢复机制，防止高亮卡住

" 记录上次光标位置和单词，用于检测高亮是否卡住
let s:last_cursor_pos = [0, 0, 0, 0]
let s:last_cursor_word = ''
let s:stuck_check_count = 0

" 自动恢复函数：检测并修复卡住的高亮
function! s:AutoRecoverIlluminate() abort
  " 获取当前光标位置和单词
  let l:current_pos = getpos('.')
  let l:current_word = expand('<cword>')
  
  " 如果光标位置变化了，重置计数器
  if l:current_pos != s:last_cursor_pos
    let s:stuck_check_count = 0
    let s:last_cursor_pos = l:current_pos
    let s:last_cursor_word = l:current_word
    return
  endif
  
  " 如果光标位置没变，但单词变了（可能是文件内容变化），重置计数器
  if l:current_word != s:last_cursor_word
    let s:stuck_check_count = 0
    let s:last_cursor_word = l:current_word
    return
  endif
  
  " 如果光标位置和单词都没变，但已经停留了一段时间，可能是卡住了
  " 这种情况下，如果检测到多次，尝试清除高亮
  let s:stuck_check_count += 1
  if s:stuck_check_count >= 5
    " 静默清除，不显示消息
    call s:ClearIlluminateHighlightSilent()
    let s:stuck_check_count = 0
  endif
endfunction

" 定期检查高亮状态（每 500ms 检查一次）
augroup IlluminateAutoRecover
  autocmd!
  " 光标移动后延迟检查（给插件时间更新）
  autocmd CursorMoved,CursorMovedI * call timer_start(500, { -> s:AutoRecoverIlluminate() })
  " 离开缓冲区时重置状态
  autocmd BufLeave * let s:stuck_check_count = 0 | let s:last_cursor_pos = [0, 0, 0, 0] | let s:last_cursor_word = ''
  " 进入插入模式时强制清除高亮（避免卡住，静默模式）
  autocmd InsertEnter * call timer_start(100, { -> s:ClearIlluminateHighlightSilent() })
  " 切换到其他窗口时清除高亮（静默模式）
  autocmd WinLeave * call timer_start(100, { -> s:ClearIlluminateHighlightSilent() })
  " 进入窗口时恢复高亮（修复侧边栏打开时的高亮异常）
  " 当从 NERDTree 或其他窗口切换回编辑窗口时，强制刷新高亮
  autocmd WinEnter * if &filetype !=# 'nerdtree' && &filetype !=# 'vista' && &filetype !=# 'fzf' && &filetype !=# 'startify'
        \ | call timer_start(200, { -> s:RefreshIlluminateHighlight() })
        \ | endif
  " NERDTree 打开/关闭时刷新高亮
  autocmd FileType nerdtree call timer_start(100, { -> s:ClearIlluminateHighlightSilent() })
  " 从 NERDTree 窗口切换回编辑窗口时刷新高亮
  autocmd BufEnter * if &filetype !=# 'nerdtree' && &filetype !=# 'vista' && &filetype !=# 'fzf' && &filetype !=# 'startify'
        \ | call timer_start(300, { -> s:RefreshIlluminateHighlight() })
        \ | endif
augroup END

" 刷新高亮函数（用于窗口切换后恢复）
function! s:RefreshIlluminateHighlight() abort
  " 如果当前文件类型在黑名单中，不处理
  if index(g:Illuminate_ftblacklist, &filetype) >= 0
    return
  endif
  " 如果插件提供了刷新函数，使用它
  if exists('*Illuminate#refresh')
    silent! call Illuminate#refresh()
    return
  endif
  " 否则，强制触发高亮更新（通过微小的光标移动）
  let l:save_cursor = getpos('.')
  try
    " 先清除可能卡住的高亮
    call s:ClearIlluminateHighlightSilent()
    " 然后触发插件重新高亮（通过光标移动）
    call cursor(line('.'), col('.') + 1)
    call cursor(l:save_cursor[1], l:save_cursor[2])
  catch
    " 忽略错误
  endtry
endfunction
" }}}1

"==============================================================
" 8. 帮助信息 {{{1
"==============================================================
" vim-illuminate 插件说明：
"   - 自动高亮光标下的单词在当前文件中的所有出现位置
"   - 支持多种文件类型
"   - 性能优化，延迟更新避免卡顿
"   - 可配置高亮组、文件类型、单词长度等
"
" 已优化的配置：
"   - 延迟时间设置为 0（立即更新，无延迟，避免卡住）
"   - 插入模式下自动清除高亮（减少干扰）
"   - 添加自动恢复机制（检测并修复卡住的高亮）
"   - 窗口切换时自动清除高亮
"   - 提供手动清除快捷键 <leader>hc
"
" 如果仍然出现高亮卡住的问题：
"   1. 使用 <leader>hc 手动清除高亮（快速修复）
"   2. 进入插入模式会自动清除高亮
"   3. 自动恢复机制会在检测到卡住时自动修复
"   4. 如果问题持续，考虑禁用插件，使用自定义实现（config/mappings/h.vim）
"
" 插件 GitHub: https://github.com/RRethy/vim-illuminate
"
" 如果不想使用插件，可以禁用此文件，使用自定义实现（config/mappings/h.vim）
" }}}1

