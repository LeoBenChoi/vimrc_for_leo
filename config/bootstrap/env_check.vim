"==============================================================
" config/bootstrap/env_check.vim
" 环境检测：依赖检查和环境修复
"==============================================================

if exists('g:loaded_env_check')
  finish
endif
let g:loaded_env_check = 1

"==============================================================
" 1. 依赖检测
"==============================================================
" 检测 ripgrep (rg) - FZF 内容搜索需要
if executable('rg') == 0
  echohl WarningMsg
  echomsg '[环境检测] ripgrep (rg) 未安装，<Space>fr 命令将无法使用'
  echomsg '[安装方法] Windows: choco install ripgrep 或 scoop install ripgrep'
  echomsg '[安装方法] 或访问: https://github.com/BurntSushi/ripgrep/releases'
  echohl None
endif

" 检测 node.js - coc.nvim 需要
if executable('node') == 0
  echohl WarningMsg
  echomsg '[环境检测] Node.js 未安装，coc.nvim 将无法正常工作'
  echomsg '[安装方法] Windows: choco install nodejs 或访问: https://nodejs.org/'
  echohl None
endif

" 检测 git - 插件管理需要
if executable('git') == 0
  echohl WarningMsg
  echomsg '[环境检测] Git 未安装，插件管理功能将无法使用'
  echomsg '[安装方法] Windows: choco install git 或访问: https://git-scm.com/'
  echohl None
endif
