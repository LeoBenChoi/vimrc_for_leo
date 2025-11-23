"==============================================================
" config/mappings/e.vim
" 文件浏览器相关快捷键：所有 e 开头的快捷键统一管理
"==============================================================

if exists('g:loaded_e_mappings')
  finish
endif
let g:loaded_e_mappings = 1

"==============================================================
" e / E - Explorer / 侧边栏
"==============================================================
" 规范：小写 e 用于文件浏览器，预留大写 E 给其他编辑器增强功能

" NERDTree 快捷键
" 使用函数包装，避免语法错误
function! s:NERDTreeToggle()
  if exists(':NERDTreeToggle')
    NERDTreeToggle
  else
    echomsg 'NERDTree 未安装，请运行 :PlugInstall'
  endif
endfunction

function! s:NERDTreeFind()
  if exists(':NERDTreeFind')
    NERDTreeFind
  else
    echomsg 'NERDTree 未安装'
  endif
endfunction

function! s:NERDTreeRefreshRoot()
  if exists(':NERDTreeRefreshRoot')
    NERDTreeRefreshRoot
  else
    echomsg 'NERDTree 未安装'
  endif
endfunction

" ee -> NERDTree Toggle：切换文件浏览器显示/隐藏
nnoremap <silent> <leader>ee :call <SID>NERDTreeToggle()<CR>

" ef -> NERDTree Find：定位当前文件在文件树中的位置
nnoremap <silent> <leader>ef :call <SID>NERDTreeFind()<CR>

" er -> NERDTree RefreshRoot：刷新文件树根目录
nnoremap <silent> <leader>er :call <SID>NERDTreeRefreshRoot()<CR>

