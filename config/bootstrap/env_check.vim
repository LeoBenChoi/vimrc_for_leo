"==============================================================
" config/bootstrap/env_check.vim
" 环境检测/修复脚本：可按需扩展，目前仅做占位
"==============================================================

if exists('g:loaded_env_check')
  finish
endif
let g:loaded_env_check = 1

" 提示：在此添加 rg/fd/node 等依赖检测逻辑
" 例如：if executable('rg') == 0 | echom '请安装 ripgrep' | endif

