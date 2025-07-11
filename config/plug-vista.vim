" ~/.vim/config/plug-vista.vim
" ========================
" plug-vista 代码大纲
" 功能：代码大纲显示
" ========================

" 确保只加载一次
" 确保只加载一次
if exists('g:plug_load_vista')
    finish
endif
let g:plug_load_vista = 1

" ========================
" 解决依赖
" ========================




" ========================
" 基础配置
" ========================

" 默认后端优先级（LSP > ctags > coc.nvim）
let g:vista_default_executive = 'lsp'

" 禁用默认快捷键（避免冲突）
let g:vista_disable_enable_shortcut = 1

" 自动更新频率（毫秒）
let g:vista_update_on_text_changed_delay = 500

" 符号图标配置（需Nerd Font）
let g:vista_icon_indent = ["╰─ ", "├─ "]
let g:vista#renderer#enable_icon = 1

" ========================
" 界面定制
" ========================
" 侧边栏样式
" 窗口位置和大小
let g:vista_sidebar_position = 'vertical botright'
let g:vista_sidebar_width = 40

" 高亮当前符号
let g:vista_cursor_delay = 300
highlight link VistaCursorLine CursorLine

" 符号图标集
let g:vista#renderer#icons = {
\   'function': '',
\   'variable': '',
\   'class':    '',
\   'method':   '',
\   'module':   '',
\   'constant': '',
\ }

" 开关大纲视图
nnoremap <silent> <Leader>v :Vista!!<CR>

" 快速跳转
nmap <silent> <Leader>f :Vista finder<CR>
nmap <silent> <Leader>t :Vista focus<CR>

" 在正常模式和可视模式下的操作
nmap <buffer> <Enter> <Plug>(vista_enter)
xmap <buffer> <Enter> <Plug>(vista_enter)