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
" 注意：ripgrep (rg) 检测已移至 config/plugins/fzf.vim
" 因为它是 FZF 插件的依赖，只在加载 FZF 时检测

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
