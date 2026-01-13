" ============================================================================
" 跨平台统一入口 (Windows/Linux/macOS)
" 目标：强制所有系统都使用 ~/.vim/ 目录，并加载其中的 vimrc.vim
" ============================================================================

" 1. 定义配置目录路径
" 使用 expand('~') 确保获取正确的用户 Home 目录
let g:vim_home_path = expand('~/.vim')

" 2. 针对 Windows 的特殊处理
" Windows 默认识别 ~/vimfiles，我们需要强制把它指向 ~/.vim
if has('win32') || has('win64')
    " 将 ~/.vim 加入到 runtimepath 的最前面
    let &runtimepath = g:vim_home_path . ',' . &runtimepath
    " 将 ~/.vim/after 加入到 runtimepath 的最后面
    let &runtimepath = &runtimepath . ',' . g:vim_home_path . '/after'
endif

" 3. 定位真正的配置文件
" 这里指向我们在 .vim 目录里设计的调度中心 vimrc.vim (或者 vimrc)
let s:main_config = g:vim_home_path . '/vimrc.vim'

" 4. 加载配置
if filereadable(s:main_config)
    execute 'source ' . s:main_config
else
    " 容错提示：如果路径不对，打印错误
    echoerr "Error: Could not find main config at: " . s:main_config
endif
