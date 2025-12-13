"==============================================================
" config/plugins/illuminate.vim
" vim-illuminate 插件配置：自动高亮光标下的单词
"==============================================================

" 注意：不在这里检查 g:loaded_illuminate，因为插件可能在配置加载后才设置这个变量
" 我们会在函数中检查插件是否可用

" 设置折叠方式为标记折叠（当打开此配置文件时自动启用）
augroup IlluminateConfigFold
  autocmd!
  autocmd BufRead,BufNewFile */config/plugins/illuminate.vim setlocal foldmethod=marker foldmarker={{{,}}} foldlevel=0
augroup END

"==============================================================
" 1. 基本配置 {{{1
"==============================================================

" 高亮延迟（毫秒），避免光标快速移动时频繁更新
let g:Illuminate_delay = 0

" 是否高亮光标下的单词（默认启用）
" 注意：这个变量会被自动管理，在非普通模式下自动设置为 0
let g:Illuminate_highlightUnderCursor = 1

" 全局变量：控制是否应该启用自动高亮
" 1 = 启用（普通模式），0 = 禁用（插入/视图等模式）
let g:Illuminate_auto_enabled = 1

" 在插入模式下禁用高亮（减少干扰，避免高亮卡住）
" 设置为 0 禁用插件自己的 InsertEnter 处理，使用我们的自定义处理
let g:Illuminate_onInsertEnter = 0
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
let g:Illuminate_useWordBoundary = 1
" }}}1

"==============================================================
" 4. 自定义高亮组 {{{1
"==============================================================

" Windows 终端下使用背景色高亮（更明显）
if has('win32') || has('win64') || has('win16')
  highlight IlluminatedWordText ctermbg=238 ctermfg=250 cterm=NONE guibg=#444444 guifg=#bcbcbc gui=NONE
  highlight IlluminatedWordRead ctermbg=238 ctermfg=250 cterm=NONE guibg=#444444 guifg=#bcbcbc gui=NONE
  highlight IlluminatedWordWrite ctermbg=238 ctermfg=250 cterm=NONE guibg=#444444 guifg=#bcbcbc gui=NONE
else
  " Linux/Mac：使用更柔和的背景色
  highlight IlluminatedWordText ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
  highlight IlluminatedWordRead ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
  highlight IlluminatedWordWrite ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
endif
" }}}1

"==============================================================
" 5. 核心功能：根据全局变量更新插件状态 {{{1
"==============================================================

" 根据全局变量更新插件的高亮设置
function! s:UpdateIlluminateState() abort
  " 如果当前文件类型在黑名单中，不处理
  if index(g:Illuminate_ftblacklist, &filetype) >= 0
    return
  endif
  
  " 检查插件是否已加载
  if !exists('g:loaded_illuminate')
    return
  endif
  
  " 根据全局变量更新插件的高亮设置
  if g:Illuminate_auto_enabled
    " 启用高亮：设置插件变量并恢复高亮
    let g:Illuminate_highlightUnderCursor = 1
    " 如果插件提供了恢复函数，调用它
    if exists('*Illuminate#resume')
      silent! call Illuminate#resume()
    endif
  else
    " 禁用高亮：设置插件变量并清除所有高亮
    let g:Illuminate_highlightUnderCursor = 0
    " 清除所有高亮匹配
    try
      call clearmatches()
    catch
    endtry
    " 如果插件提供了暂停函数，调用它
    if exists('*Illuminate#pause')
      silent! call Illuminate#pause()
    endif
  endif
endfunction

" 全局包装函数（用于外部调用和测试）
function! IlluminateUpdateState() abort
  call s:UpdateIlluminateState()
endfunction
" }}}1

"==============================================================
" 6. 模式检测：离开普通模式时禁用，回到普通模式时启用 {{{1
"==============================================================

augroup IlluminateModeControl
  autocmd!
  
  " 使用 ModeChanged 事件（Vim 8.2+）检测模式变化
  if exists('##ModeChanged')
    " 从普通模式切换到其他模式时，禁用高亮
    autocmd ModeChanged n:* 
          \ if mode() !=# 'n' | 
          \   let g:Illuminate_auto_enabled = 0 | 
          \   call s:UpdateIlluminateState() | 
          \ endif
    " 从其他模式切换回普通模式时，启用高亮
    autocmd ModeChanged *:n* 
          \ let g:Illuminate_auto_enabled = 1 | 
          \ call s:UpdateIlluminateState()
  else
    " 对于不支持 ModeChanged 的 Vim 版本，使用传统事件
    " 进入插入模式时禁用高亮
    autocmd InsertEnter * 
          \ let g:Illuminate_auto_enabled = 0 | 
          \ call s:UpdateIlluminateState()
    " 离开插入模式时启用高亮（如果回到普通模式）
    autocmd InsertLeave * 
          \ if mode() ==# 'n' | 
          \   let g:Illuminate_auto_enabled = 1 | 
          \   call s:UpdateIlluminateState() | 
          \ endif
    " 进入视图模式时禁用高亮
    if exists('##VisualEnter')
      autocmd VisualEnter * 
            \ let g:Illuminate_auto_enabled = 0 | 
            \ call s:UpdateIlluminateState()
      autocmd VisualLeave * 
            \ if mode() ==# 'n' | 
            \   let g:Illuminate_auto_enabled = 1 | 
            \   call s:UpdateIlluminateState() | 
            \ endif
    endif
  endif
augroup END
" }}}1

"==============================================================
" 7. 辅助功能：手动清除高亮 {{{1
"==============================================================

" 手动清除高亮（如果高亮卡住时使用）
function! s:ClearIlluminateHighlight() abort
  " 清除所有高亮匹配
  try
    call clearmatches()
  catch
  endtry
  " 清除搜索高亮
  nohlsearch
  " 如果插件提供了暂停函数，调用它
  if exists('*Illuminate#pause')
    silent! call Illuminate#pause()
  endif
  echo '已清除高亮'
endfunction

" 手动清除高亮快捷键
nnoremap <silent> <leader>hc :call <SID>ClearIlluminateHighlight()<CR>
" }}}1

"==============================================================
" 8. 自动恢复机制（修复高亮卡住问题） {{{1
"==============================================================

" 记录上次光标位置和单词，用于检测高亮是否卡住
let s:last_cursor_pos = [0, 0, 0, 0]
let s:last_cursor_word = ''
let s:stuck_check_count = 0

" 自动恢复函数：检测并修复卡住的高亮
function! s:AutoRecoverIlluminate() abort
  " 只在普通模式下检查
  if mode() !=# 'n'
    return
  endif
  
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
  
  " 如果光标位置没变，但单词变了，重置计数器
  if l:current_word != s:last_cursor_word
    let s:stuck_check_count = 0
    let s:last_cursor_word = l:current_word
    return
  endif
  
  " 如果光标位置和单词都没变，可能是卡住了
  let s:stuck_check_count += 1
  if s:stuck_check_count >= 5
    " 静默清除高亮
    try
      call clearmatches()
    catch
    endtry
    if exists('*Illuminate#pause')
      silent! call Illuminate#pause()
    endif
    let s:stuck_check_count = 0
  endif
endfunction

augroup IlluminateAutoRecover
  autocmd!
  " 光标移动后延迟检查（只在普通模式下）
  autocmd CursorMoved * 
        \ if mode() ==# 'n' | 
        \   call timer_start(500, { -> s:AutoRecoverIlluminate() }) | 
        \ endif
  " 离开缓冲区时重置状态
  autocmd BufLeave * let s:stuck_check_count = 0 | let s:last_cursor_pos = [0, 0, 0, 0] | let s:last_cursor_word = ''
augroup END
" }}}1

"==============================================================
" 9. 窗口切换处理 {{{1
"==============================================================

augroup IlluminateWindowControl
  autocmd!
  " 切换到其他窗口时清除高亮
  autocmd WinLeave * 
        \ if exists('g:loaded_illuminate') | 
        \   try | 
        \     call clearmatches() | 
        \   catch | 
        \   endtry | 
        \ endif
  " 进入窗口时恢复高亮（如果回到普通模式且高亮应该启用）
  autocmd WinEnter * 
        \ if &filetype !=# 'nerdtree' && &filetype !=# 'vista' && &filetype !=# 'fzf' && &filetype !=# 'startify' && mode() ==# 'n' && g:Illuminate_auto_enabled | 
        \   call timer_start(200, { -> s:UpdateIlluminateState() }) | 
        \ endif
  " NERDTree 打开/关闭时清除高亮
  autocmd FileType nerdtree 
        \ if exists('g:loaded_illuminate') | 
        \   try | 
        \     call clearmatches() | 
        \   catch | 
        \   endtry | 
        \ endif
augroup END
" }}}1

"==============================================================
" 10. 帮助信息 {{{1
"==============================================================
" vim-illuminate 插件说明：
"   - 自动高亮光标下的单词在当前文件中的所有出现位置
"   - 只在普通模式下启用高亮，插入/视图模式自动禁用
"   - 支持多种文件类型
"
" 快捷键：
"   <leader>hc - 手动清除高亮
"
" 配置说明：
"   - g:Illuminate_auto_enabled: 全局控制变量（自动管理）
"   - g:Illuminate_highlightUnderCursor: 插件核心变量（自动管理）
"   - 在非普通模式下自动禁用，回到普通模式时自动启用
"
" 插件 GitHub: https://github.com/RRethy/vim-illuminate
" }}}1
