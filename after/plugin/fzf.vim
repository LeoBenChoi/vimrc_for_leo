" ============================================================================
" FZF 配置
" 文件位置: ~/.vim/after/plugin/fzf.vim
" 说明: 此文件会在所有插件加载后自动执行，用于配置 fzf 插件
" ============================================================================


" 解决浮动窗口问题
let g:fzf_layout = { 'down': '40%' }

" ============================================================================
" FZF 颜色配置（可选）
" ============================================================================
" 自定义 fzf 颜色以匹配你的主题
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
