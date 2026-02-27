" ============================================================================
" vim-illuminate 配置：光标下单词的其它出现位置高亮
" ============================================================================

" 延迟（毫秒），避免移动光标时高亮闪烁过于频繁
let g:Illuminate_delay = 200

" 是否高亮光标下的单词本身（1=高亮，0=只高亮其它出现位置）
let g:Illuminate_highlightUnderCursor = 1

" 在这些文件类型中不启用 illuminate
let g:Illuminate_ftblacklist = [
      \ 'nerdtree',
      \ 'dirbuf',
      \ 'dirvish',
      \ 'fugitive',
      \ 'startify',
      \ 'vista',
      \ 'fzf',
      \ ]

" 高亮样式：其它出现位置用下划线，光标下单词保持默认
augroup illuminate_highlight
  autocmd!
  autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
augroup END
