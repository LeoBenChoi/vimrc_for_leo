" =======================================================
" [FZF] 模糊搜索插件配置
" =======================================================

" Todo 命令：使用 fzf 搜索 TODO 注释
command! -bang -nargs=0 Todo
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always --smart-case -- "TODO|FIXME|XXX|BUG|HACK|NOTE"', 1,
            \   fzf#vim#with_preview(), <bang>0)

" 解决浮动窗口问题
let g:fzf_layout = { 'down': '40%' }

" FZF 颜色配置
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment']
      \ }
