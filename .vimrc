"==============================================================
" ~/.vim/.vimrc
" Vim 配置入口：仅负责加载 config/vimrc.vim
" 
" 说明：
" - 此文件作为配置系统的入口点
" - 所有实际配置都在 config/ 目录下
" - 修改配置时只需更新 config/ 下的文件，无需修改此文件
" - 如需同步到上层目录，只需复制此文件到 ~/.vimrc
"==============================================================

" 检测配置文件位置
let s:config_file = expand('<sfile>:p:h') . '/config/vimrc.vim'

" 如果当前目录下没有 config 目录，尝试从 ~/.vim 加载
if !filereadable(s:config_file)
  let s:config_file = expand('~/.vim/config/vimrc.vim')
endif

" 加载配置文件
if filereadable(s:config_file)
  execute 'source' fnameescape(s:config_file)
else
  echohl ErrorMsg
  echomsg '[vimrc] 错误: 未找到配置文件: ' . s:config_file
  echomsg '[vimrc] 请确保 config/vimrc.vim 存在'
  echohl None
endif
