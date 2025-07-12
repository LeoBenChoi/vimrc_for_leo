" ========================
" vim-session 配置
" 功能：会话管理
" ========================

" 确保只加载一次
if exists('g:plug_load_vim_session')
  finish
endif
let g:plug_load_vim_session = 1

" ========================
" 推荐配置
" ========================


let g:session_directory = '~/.vim/.sessions'  " 会话文件存储目录
" let g:session_autosave = 'no'               " 默认禁用自动保存（按需开启）
" let g:session_autoload = 'no'               " 默认禁用自动加载
let g:session_autosave = 'yes'  " 退出时询问是否保存
let g:session_autoload = 'no'  " 启动时询问是否加载
let g:session_default_overwrite = 1 " 允许覆盖已有会话
let g:session_autosave_periodic = 10 " 每10分钟自动保存一次会话

nnoremap <leader>ss :SaveSession<CR>       " 保存会话

nnoremap <leader>ss :<C-U>call SaveSessionWithVistaCheck()<CR>

function! SaveSessionWithVistaCheck()
  " 检查Vista窗口是否存在（通过窗口变量或缓冲区类型）
  let vista_open = 0
  for winnr in range(1, winnr('$'))
    if getwinvar(winnr, '&filetype') == 'vista'
      let vista_open = 1
      break
    endif
  endfor

  " 如果Vista开启则先关闭
  if vista_open && exists(':Vista')
    Vista!
    echo "Closed Vista before saving session..."
  endif

  " 保存会话
  SaveSession
endfunction

nnoremap <leader>sl :OpenSession<CR>        " 加载会话

" let g:session_skip_files = [
"     \ 'NERD_tree.*',  " 忽略NERDTree窗口
"     \ 'term://.*',    " 忽略终端缓冲区
"     \ 'COMMIT_EDITMSG' " 忽略Git提交消息
"     \ '__vista__',    " 忽略Vista窗口
"     \ 'tagbar.*',     " 忽略Tagbar窗口
" \ ]
let g:session_skip_files = [
    \ 'NERD_tree.*',
    \ 'term://.*',
    \ 'COMMIT_EDITMSG',
    \ 'tagbar.*',
\ ]

" ========================
" 快捷键
" ========================

" 快捷键( 转移至 mappings.vim )
" nnoremap <leader>ss :SaveSession<CR>
" nnoremap <leader>sl :OpenSession<space>
" nnoremap <leader>sd :DeleteSession<CR>

" 模糊查找会话文件（依赖 fzf.vim）
" nnoremap <leader>fs :execute 'OpenSession ' . fzf#run({'source': 'ls ~/.vim/.sessions', 'sink': 'OpenSession'})<CR>

" ========================
" 进阶
" ========================

" 将会话文件加入Git忽略（避免提交个人工作状态）
" echo '*.vim' >> ~/.vim/.sessions/.gitignore

" 禁用不必要的恢复项（提升加载速度）
let g:session_persist_colors = 0  " 不恢复颜色方案
let g:session_persist_font = 0    " 不恢复GUI字体

