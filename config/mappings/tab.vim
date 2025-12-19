"==============================================================
" config/mappings/tab.vim
" Tab 栏功能配置：Tab 页和 Buffer 管理快捷键
"==============================================================

if exists('g:loaded_tab_mappings')
  finish
endif
let g:loaded_tab_mappings = 1

"==============================================================
" 1. Tab 页管理（原生 Vim Tab 功能）
"==============================================================
" 新建 Tab 页
nnoremap <silent> <leader>tn :tabnew<CR>
" 关闭当前 Tab 页
nnoremap <silent> <leader>tc :tabclose<CR>
" 关闭所有其他 Tab 页（只保留当前）
nnoremap <silent> <leader>to :tabonly<CR>
" 关闭所有 Tab 页 手要快……
nnoremap <silent> <leader>tC :tabclose!<CR>

" Tab 页切换
" 下一个 Tab 页
nnoremap <silent> <leader>tl :tabnext<CR>
" 上一个 Tab 页
nnoremap <silent> <leader>th :tabprev<CR>
" 切换到第一个 Tab 页
nnoremap <silent> <leader>tH :tabfirst<CR>
" 切换到最后一个 Tab 页
nnoremap <silent> <leader>tL :tablast<CR>

" Tab 页移动
" 将当前 Tab 页向右移动
nnoremap <silent> <leader>t] :+tabmove<CR>
" 将当前 Tab 页向左移动
nnoremap <silent> <leader>t[ :-tabmove<CR>

" 快速切换到指定 Tab 页（1-9）
for i in range(1, 9)
  execute 'nnoremap <silent> <leader>' . i . ' :' . i . 'tabnext<CR>'
endfor
" 切换到第 10 个 Tab 页
nnoremap <silent> <leader>0 :10tabnext<CR>

"==============================================================
" 2. Buffer 管理（使用 vim-airline tabline 扩展）
"==============================================================
" 如果启用了 buffer_idx_mode，使用 vim-airline 提供的映射
if exists('g:airline#extensions#tabline#buffer_idx_mode') && g:airline#extensions#tabline#buffer_idx_mode > 0
  " 快速切换到指定 Buffer（1-9, 0 表示第 10 个）
  " 注意：这些映射需要 vim-airline 的 buffer_idx_mode 支持
  if g:airline#extensions#tabline#buffer_idx_mode == 1
    " 模式 1：1-9, 0 表示第 10 个
    nmap <silent> <leader>1 <Plug>AirlineSelectTab1
    nmap <silent> <leader>2 <Plug>AirlineSelectTab2
    nmap <silent> <leader>3 <Plug>AirlineSelectTab3
    nmap <silent> <leader>4 <Plug>AirlineSelectTab4
    nmap <silent> <leader>5 <Plug>AirlineSelectTab5
    nmap <silent> <leader>6 <Plug>AirlineSelectTab6
    nmap <silent> <leader>7 <Plug>AirlineSelectTab7
    nmap <silent> <leader>8 <Plug>AirlineSelectTab8
    nmap <silent> <leader>9 <Plug>AirlineSelectTab9
    nmap <silent> <leader>0 <Plug>AirlineSelectTab0
    " 上一个 Buffer
    nmap <silent> <leader>- <Plug>AirlineSelectPrevTab
    " 下一个 Buffer
    nmap <silent> <leader>= <Plug>AirlineSelectNextTab
  endif
endif

" Buffer 切换（不依赖 vim-airline）
" 下一个 Buffer
nnoremap <silent> <leader>bn :bnext<CR>
" 上一个 Buffer
nnoremap <silent> <leader>bp :bprev<CR>
" 关闭当前 Buffer（不关闭窗口）
nnoremap <silent> <leader>bd :bdelete<CR>
" 强制关闭当前 Buffer（即使有未保存的更改）
nnoremap <silent> <leader>bD :bdelete!<CR>
" 关闭所有 Buffer（除了当前）
nnoremap <silent> <leader>bo :%bdelete\|edit #\|bdelete #<CR>
" 关闭所有 Buffer
nnoremap <silent> <leader>bC :%bdelete!<CR>

" Buffer 列表
" 显示 Buffer 列表
nnoremap <silent> <leader>bl :buffers<CR>
" 使用 fzf 选择 Buffer（如果 fzf 可用）
if exists(':Buffers')
  nnoremap <silent> <leader>bf :Buffers<CR>
endif

"==============================================================
" 3. Tab 页和 Buffer 组合操作
"==============================================================
" 将当前 Buffer 移动到新 Tab 页
nnoremap <silent> <leader>bt :tab split<CR>
" 在新 Tab 页中打开当前文件
nnoremap <silent> <leader>btf :tabnew <C-r>=expand('%:p')<CR><CR>

"==============================================================
" 4. 便捷快捷键（使用 Ctrl 键）
"==============================================================
" 使用 Ctrl+Tab 和 Ctrl+Shift+Tab 切换 Tab 页（类似浏览器）
" 注意：在终端中 Ctrl+Tab 可能不可用，使用 Alt+Tab 替代
if has('gui_running')
  " GUI 模式下使用 Ctrl+Tab
  nnoremap <silent> <C-Tab> :tabnext<CR>
  nnoremap <silent> <C-S-Tab> :tabprev<CR>
endif

" 使用 Alt+方向键切换 Tab 页（终端兼容性更好）
if !has('gui_running')
  " Alt+h 上一个 Tab
  nnoremap <silent> <A-h> :tabprev<CR>
  " Alt+l 下一个 Tab
  nnoremap <silent> <A-l> :tabnext<CR>
  " Alt+j 上一个 Buffer
  nnoremap <silent> <A-j> :bprev<CR>
  " Alt+k 下一个 Buffer
  nnoremap <silent> <A-k> :bnext<CR>
endif

"==============================================================
" 5. Tab 页和 Buffer 状态显示
"==============================================================
" 显示当前 Tab 页信息
function! s:ShowTabInfo() abort
  let l:tab_count = tabpagenr('$')
  let l:current_tab = tabpagenr()
  let l:buf_count = len(getbufinfo({'buflisted': 1}))
  echo printf('Tab: %d/%d | Buffers: %d', l:current_tab, l:tab_count, l:buf_count)
endfunction
command! TabInfo call s:ShowTabInfo()
nnoremap <silent> <leader>ti :TabInfo<CR>

"==============================================================
" 6. Tab 页会话管理（可选功能）
"==============================================================
" 保存当前 Tab 页布局到会话
function! s:SaveTabSession() abort
  let l:session_file = getcwd() . '/.vimtab'
  execute 'mksession! ' . l:session_file
  echo 'Tab session saved to: ' . l:session_file
endfunction
command! TabSave call s:SaveTabSession()
nnoremap <silent> <leader>ts :TabSave<CR>

" 加载 Tab 页会话
function! s:LoadTabSession() abort
  let l:session_file = getcwd() . '/.vimtab'
  if filereadable(l:session_file)
    execute 'source ' . l:session_file
    echo 'Tab session loaded from: ' . l:session_file
  else
    echo 'Tab session file not found: ' . l:session_file
  endif
endfunction
command! TabLoad call s:LoadTabSession()
nnoremap <silent> <leader>tL :TabLoad<CR>

"==============================================================
" 快捷键索引
"==============================================================
" Tab 页操作：
"   <leader>tn  - 新建 Tab 页
"   <leader>tc  - 关闭当前 Tab 页
"   <leader>to  - 关闭其他 Tab 页
"   <leader>tC  - 关闭所有 Tab 页
"   <leader>tl  - 下一个 Tab 页
"   <leader>th  - 上一个 Tab 页
"   <leader>tf  - 第一个 Tab 页
"   <leader>tL  - 最后一个 Tab 页
"   <leader>t>  - Tab 页右移
"   <leader>t<  - Tab 页左移
"   <leader>1-9 - 切换到第 1-9 个 Tab 页
"   <leader>0   - 切换到第 10 个 Tab 页
"   <leader>ti  - 显示 Tab 页信息
"   <leader>ts  - 保存 Tab 页会话
"   <leader>tL  - 加载 Tab 页会话
"
" Buffer 操作：
"   <leader>bn  - 下一个 Buffer
"   <leader>bp  - 上一个 Buffer
"   <leader>bd  - 关闭当前 Buffer
"   <leader>bD  - 强制关闭当前 Buffer
"   <leader>bo  - 关闭其他 Buffer
"   <leader>bC  - 关闭所有 Buffer
"   <leader>bl  - 显示 Buffer 列表
"   <leader>bf  - 使用 fzf 选择 Buffer
"   <leader>bt  - 将当前 Buffer 移动到新 Tab 页
"   <leader>btf - 在新 Tab 页中打开当前文件
"
" 快速切换（如果启用 buffer_idx_mode）：
"   <leader>1-9 - 切换到第 1-9 个 Buffer
"   <leader>0   - 切换到第 10 个 Buffer
"   <leader>-   - 上一个 Buffer
"   <leader>=   - 下一个 Buffer
"
" Alt 键快捷方式（终端模式）：
"   Alt+h - 上一个 Tab 页
"   Alt+l - 下一个 Tab 页
"   Alt+j - 上一个 Buffer
"   Alt+k - 下一个 Buffer
