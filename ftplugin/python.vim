" ~/.vim/ftplugin/python.vim
" Python 专属配置（仅在打开 .py 文件时加载）

" ===== 基础设置 =====
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal textwidth=120
setlocal colorcolumn=120

" 保存时自动整理 import（vim-isort）
augroup python_isort
	autocmd!
	" autocmd BufWritePre <buffer> Isort
augroup END
