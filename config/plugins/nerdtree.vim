"==============================================================
" config/plugins/nerdtree.vim
" NERDTree 文件树配置
"==============================================================

if exists('g:loaded_nerdtree_config')
    finish
endif
let g:loaded_nerdtree_config = 1

"==============================================================
" NERDTree 基础配置
"==============================================================
" 显示隐藏文件（以点开头的文件）
let g:NERDTreeShowHidden = 1

" 其他常用配置（可选）
" let g:NERDTreeShowLineNumbers = 0        " 不显示行号
" let g:NERDTreeMinimalUI = 0               " 完整 UI
" let g:NERDTreeAutoDeleteBuffer = 1       " 删除文件时自动删除 buffer
