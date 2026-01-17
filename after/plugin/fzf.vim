" ============================================================================
" FZF 配置
" 文件位置: ~/.vim/after/plugin/fzf.vim
" 说明: 此文件会在所有插件加载后自动执行，用于配置 fzf 插件
" ============================================================================

" ============================================================================
" FZF 浮动窗口配置
" ============================================================================
" 解决 Neovim 浮动窗口边框错位问题
" 在 Windows 上，使用 'sharp' 边框可以避免滚动时的边框错位问题
" 如果仍有问题，可以尝试禁用边框或使用 split 窗口布局

" 配置 fzf 使用浮动窗口，并设置边框样式为 'sharp' 以避免错位
" 'sharp' 边框在滚动时比 'rounded' 更稳定
"let g:fzf_layout = {
"      \ 'window': {
"      \   'width': 0.9,
"      \   'height': 0.6,
"      \   'relative': v:false,
"      \   'yoffset': 0.5,
"      \   'xoffset': 0.5,
"      \   'border': 'sharp'
"      \ }
"      \ }

" 如果 'sharp' 边框仍有问题，可以尝试以下替代方案：

" 方案 1: 禁用边框（最简单，但视觉效果较差）
"let g:fzf_layout = {
"      \ 'window': {
"      \   'width': 0.9,
"      \   'height': 0.6,
"      \   'relative': v:false,
"      \   'yoffset': 0.5,
"      \   'xoffset': 0.5,
"      \   'border': 'none'
"      \ }
"      \ }

" 方案 2: 使用 split 窗口而不是浮动窗口（最稳定，但占用更多屏幕空间）
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

" ============================================================================
" FZF 历史记录配置（可选）
" ============================================================================
" 启用每个命令的历史记录
" 历史文件将存储在指定目录中
" 设置后，CTRL-N 和 CTRL-P 将绑定到 'next-history' 和 'previous-history'
" let g:fzf_history_dir = expand('~/.vim/fzf-history')
