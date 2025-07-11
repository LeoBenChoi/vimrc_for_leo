" ========================
" fzf 配置
" 功能：搜索
" ========================

" 确保只加载一次
if exists('g:plug_load_fzf')
  finish
endif
let g:plug_load_fzf = 1

" 初始化fzf.vim
let g:fzf_vim = {}

" 窗口
"let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_layout = { 'down': '~30%' }

" 快捷键绑定
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
" 文件模糊搜索
nnoremap <leader>ff :Files<CR>
" Git 文件
nnoremap <leader>fg :GFiles<CR>
" 搜索内容（使用 rg）
nnoremap <leader>fa :Rg<CR>
" 打开 buffer
nnoremap <leader>fb :Buffers<CR>
" 书签
nnoremap <leader>fm :Marks<CR>
" 历史
nnoremap <leader>fh :History<CR>
" 避免和 airline 冲突的映射
let g:fzf_buffers_jump = 1
let $FZF_DEFAULT_OPTS = '--bind=ctrl-j:preview-down,ctrl-k:preview-up'

