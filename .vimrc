let g:start_time = reltime()
" vimrc - 兼容所有平台的入口文件（可以软连接或者复制到~/.vimrc）

" 使用过的系统
" used Linux: Kali, Ubuntu, CentOS
" used Windows: Windows 11, 10

" 保证windows .vim/ 路径正常
let $VIMHOME = expand('~/.vim')
" 确保 ~/.vim 在 runtimepath 中
if index(split(&rtp, ','), $VIMHOME) == -1
  set rtp^=$VIMHOME
endif

" plug 包管理器的插件路径
let $VIMPLUGHOME = expand('~/.vim/plugged')
if index(split(&rtp, ','), $VIMPLUGHOME) == -1
  set rtp^=$VIMPLUGHOME
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

" 加载映射
let config_mapping = expand('~/.vim/config/mappings.vim')
if filereadable(config_mapping)
  source ~/.vim/config/mappings.vim
endif

" 插件包管理器
" 原生包管理器(瞎jb搓的)
" let plug_manager_pack = expand('~/.vim/config/vimPackInstallPlug.vim')
" if filereadable(plug_manager_pack)
"   source ~/.vim/config/vimPackInstallPlug.vim
" endif
" vim-plug
let plug_manager_vim_plug = expand('~/.vim/config/vim-plug.vim')
if filereadable(plug_manager_vim_plug)
  source ~/.vim/config/vim-plug.vim
endif

" 插件配置
" airline
let plug_config_airline = expand('~/.vim/config/plug-airline.vim')
if filereadable(plug_config_airline)
  source ~/.vim/config/plug-airline.vim
endif

" fzf
let plug_config_fzf = expand('~/.vim/config/plug-fzf.vim')
if filereadable(plug_config_fzf)
  source ~/.vim/config/plug-fzf.vim
endif

" nerdtree
let plug_config_nerdtree = expand('~/.vim/config/plug-nerdtree.vim')
if filereadable(plug_config_nerdtree)
  source ~/.vim/config/plug-nerdtree.vim
endif

" lsp
let plug_config_lsp = expand('~/.vim/config/plug-lsp.vim')
if filereadable(plug_config_lsp)
  source ~/.vim/config/plug-lsp.vim
endif

" vista
" 需要在 lsp 之后加载
let plug_config_vista = expand('~/.vim/config/plug-vista.vim')
if filereadable(plug_config_vista)
  source ~/.vim/config/plug-vista.vim
endif
" git
let plug_config_git = expand('~/.vim/config/plug-git.vim')
if filereadable(plug_config_git)
  source ~/.vim/config/plug-git.vim
endif

" session
let plug_config_session = expand('~/.vim/config/plug-vim-session.vim')
if filereadable(plug_config_session)
  source ~/.vim/config/plug-vim-session.vim
endif

" 加载主题(要在包管理器后面，不然会报错)
let config_theme = expand('~/.vim/config/theme.vim')
if filereadable(config_theme)
  source ~/.vim/config/theme.vim
endif

" 显示启动时间
function! UpdateAirlineWithStartupTime() abort
    let l:elapsed = reltimefloat(reltime(g:start_time)) * 1000
    let g:startup_time_display = '🚀 ' . printf('%.2f ms', l:elapsed)
    call timer_start(10, { -> execute('redrawstatus!') })

    " 自动清除
    call timer_start(10000, { -> RemoveStartupTime() })
endfunction

function! RemoveStartupTime() abort
    let g:startup_time_display = ''
    call timer_start(10, { -> execute('redrawstatus!') })
endfunction

autocmd VimEnter * call timer_start(100, { -> UpdateAirlineWithStartupTime() })
