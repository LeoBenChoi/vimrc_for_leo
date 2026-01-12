" ============================================================================
" Vim 配置文件入口
" ============================================================================
" 此文件只需要复制到 home 目录一次
" 所有配置修改都在 ~/.vim/ 目录下进行，无需再次复制此文件

" 使用vim特性，禁用vi兼容模式
set nocompatible

" 设置运行时路径
set runtimepath+=~/.vim

" 加载真正的入口文件
if filereadable(expand('~/.vim/config/vimrc.vim'))
    source ~/.vim/config/vimrc.vim
else
    echoerr '无法找到配置文件: ~/.vim/config/vimrc.vim'
endif
