"==============================================================
" config/mappings/o.vim
" 代码大纲相关快捷键：所有 o 开头的快捷键统一管理
"==============================================================

if exists('g:loaded_o_mappings')
  finish
endif
let g:loaded_o_mappings = 1

"==============================================================
" o / O - Outline / 代码大纲
"==============================================================
" 规范：小写 o 用于代码大纲，预留大写 O 给其他大纲相关功能

" Vista 代码大纲快捷键（切换打开/关闭）
" 使用函数包装，避免语法错误
function! s:VistaToggle()
  if exists(':Vista')
    Vista!!
  else
    echomsg 'Vista 未安装，请运行 :PlugInstall'
  endif
endfunction

" oo -> Vista Toggle：切换代码大纲显示/隐藏
nnoremap <silent> <leader>oo :call <SID>VistaToggle()<CR>

