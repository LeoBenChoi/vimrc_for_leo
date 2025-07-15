" ~/.vim/config/plug-lsp.vim
" ========================
" compat 加载后配置
" 功能：兼容性配置以及优化
" ========================

" 确保只加载一次
if exists('g:config_load_compat')
    finish
endif
let g:config_load_compat = 1

" ========================
" 防止光标闪烁
" ========================

" 默认光标样式
" set guicursor=
" 调整为更平滑的光标样式
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
" 限制光标闪烁频率
set updatetime=1000
