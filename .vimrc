let g:start_time = reltime()
" 上面是记录启动时间的开始

" vimrc - 兼容所有平台的入口文件（可以软连接或者复制到~/.vimrc）

" 使用过的系统
" used Linux: Kali, Ubuntu, CentOS
" used Windows: Windows 11, 10

" ===================================================================
" 配置加载
" ===================================================================

" 设置 runtimepath 包含 ~/.vim 目录，以确保配置文件和插件能够被正确加载
set runtimepath^=~/.vim

" 加载基础配置
if !exists('g:load_config_basic')
  let config_basic = expand('~/.vim/config/basic.vim')
  if filereadable(config_basic)
      source ~/.vim/config/basic.vim
  endif
  let g:load_config_basic = 1
endif

" 加载字体配置 (要在 GUI 版本下加载)
if !exists('g:load_config_font')
  let config_font = expand('~/.vim/config/font.vim')
  if filereadable(config_font)
      source ~/.vim/config/font.vim
  endif
  let g:load_config_font = 1
endif

" ===================================================================
" 插件包管理器
" ===================================================================

" 原生包管理器(瞎jb搓的，已经弃用，目前留着做纪念)
" let plug_manager_pack = expand('~/.vim/config/vimPackInstallPlug.vim')
" if filereadable(plug_manager_pack)
"   source ~/.vim/config/vimPackInstallPlug.vim
" endif

" plug 包管理器的插件路径
let $VIMPLUGHOME = expand('~/.vim/plugged')
if index(split(&rtp, ','), $VIMPLUGHOME) == -1
    set rtp^=$VIMPLUGHOME
endif

" vim-plug
if !exists('g:load_config_vim_plug')
  let config_vim_plug = expand('~/.vim/config/vim-plug.vim')
  if filereadable(config_vim_plug)
      source ~/.vim/config/vim-plug.vim
  endif
  let g:load_config_vim_plug = 1
endif

if isdirectory($VIMPLUGHOME)
  " 如果插件目录存在，加载插件

  " nerdtree
  let plug_config_nerdtree = expand('~/.vim/config/plug/plug-nerdtree.vim')
  if filereadable(plug_config_nerdtree)
      source ~/.vim/config/plug/plug-nerdtree.vim
  endif

"   airline
  let plug_config_airline = expand('~/.vim/config/plug/plug-airline.vim')
  if filereadable(plug_config_airline)
      source ~/.vim/config/plug/plug-airline.vim
  endif

  " coc.nvim
  let plug_config_cocnvim = expand('~/.vim/config/plug/plug-coc.vim')
  if filereadable(plug_config_cocnvim)
      source ~/.vim/config/plug/plug-coc.vim
  endif

  " fzf
  let plug_config_fzf = expand('~/.vim/config/plug/plug-fzf.vim')
  if filereadable(plug_config_fzf)
      source ~/.vim/config/plug/plug-fzf.vim
  endif

  " git
  let plug_config_git = expand('~/.vim/config/plug/plug-git.vim')
  if filereadable(plug_config_git)
      source ~/.vim/config/plug/plug-git.vim
  endif

  " commentary
  let plug_config_commentary = expand('~/.vim/config/plug/plug-commentary.vim')
  if filereadable(plug_config_commentary)
      source ~/.vim/config/plug/plug-commentary.vim
  endif

  " vista
  let plug_config_vista = expand('~/.vim/config/plug/plug-vista.vim')
  if filereadable(plug_config_vista)
      source ~/.vim/config/plug/plug-vista.vim
  endif
endif

" ===================================================================
" 配置加载 | 插件后
" ===================================================================

" 加载主题(要在包管理器后面，不然会报错)
if !exists('g:load_config_theme')
  let config_theme = expand('~/.vim/config/theme.vim')
  if filereadable(config_theme)
      source ~/.vim/config/theme.vim
  endif
  let g:load_config_theme = 1
endif

" 加载映射 放到最后，防止函数未定义、防止被覆盖
if !exists('g:load_config_mappings')
  let config_mapping = expand('~/.vim/config/mappings.vim')
  if filereadable(config_mapping)
      source ~/.vim/config/mappings.vim
  endif
  let g:load_config_mappings = 1
endif

" 缩进配置(要在包管理器后面，不然会被插件覆盖)
if !exists('g:load_config_indent')
  let config_indent = expand('~/.vim/config/indent.vim')
  if filereadable(config_indent)
      source ~/.vim/config/indent.vim
  endif
  let g:load_config_indent = 1
endif

" ===================================================================
" 显示启动时间
" ===================================================================

" 在状态栏显示启动时间（需要安装 vim-airline 插件, 不安装不显示）
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

