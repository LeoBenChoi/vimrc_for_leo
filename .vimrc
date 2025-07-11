" vimrc - 兼容所有平台的入口文件（可以软连接或者复制到~/.vimrc）

适配
" used Linux: Kali, Ubuntu, CentOS
" used Windows: Windows 11, 10

" 设置不兼容vi
if &compatible
  set nocompatible
endif

" 默认配置文件夹是否存在
let config_dir = expand('~/.vim/config')
if isdirectory(config_dir) == 0
echomsg '主要配置路径不存在，请检查路径: ~/.vim/config'
finish
endif


" 加载基础配置
let config_basic = expand('~/.vim/config/basic.vim')
if filereadable(config_basic)
	source ~/.vim/config/basic.vim
endif

" 加载字体配置
let config_font = expand('~/.vim/config/font.vim')
if filereadable(config_font)
	source ~/.vim/config/font.vim
endif

















finish


"source ~/.vim/config/keymaps.vim

if isdirectory(expand('~/.vim/config'))
    source ~/.vim/config/options.vim
endif







" 自动检测配置目录位置
let vim_dir = expand('~/.vim')
if has('win32') || has('win64')
  let vim_dir = expand('$HOME/vimfiles')
endif

" 将配置目录加入 runtimepata
execute 'set rtp+=' . vim_dir

" 加载模块化配置
for config_file in [
      \ '/config/basic.vim',
      \ '/config/plugins.vim',
      \ '/config/keys.vim',
      \ '/config/ui.vim'
      \ ]
  if filereadable(vim_dir . config_file)
    execute 'source ' . vim_dir . config_file
  endif
endfor

" 平台特定配置
if has('win32') || has('win64')
  if filereadable(vim_dir . '/config/windows.vim')
    source ~/.vim/config/windows.vim
  endif
elseif has('unix')
  if filereadable(vim_dir . '/config/unix.vim')
    source ~/.vim/config/unix.vim
  endif
endif

" 文件类型检测必须放在最后
filetype plugin indent on
syntax enable

