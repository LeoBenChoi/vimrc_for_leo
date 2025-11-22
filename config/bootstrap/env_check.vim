"==============================================================
" config/bootstrap/env_check.vim
" 环境检测：依赖检查和环境修复
"==============================================================

if exists('g:loaded_env_check')
  finish
endif
let g:loaded_env_check = 1

" 提示：在此添加 rg/fd/node 等依赖检测逻辑
" 例如：if executable('rg') == 0 | echom '请安装 ripgrep' | endif
