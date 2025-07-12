" ~/.vim/config/mappings.vim
" ========================
" 高效键位映射
" 原则：
" 1. 高频操作优先
" 2. 避免与插件冲突
" 3. 符合肌肉记忆
" ========================

" 确保只加载一次
if exists('g:loaded_mappings_config')
  finish
endif
let g:loaded_mappings_config = 1

" ===================================================
" F1 - F12 区域
" ===================================================

" 快速切换相对行号
function! ToggleRelativeNumber()
  if &relativenumber
    set norelativenumber
  else
    set relativenumber
  endif
endfunction
nnoremap <F8> :call ToggleRelativeNumber()<CR>

" 切换主题
" <F4> 占用 to theme.vim
nnoremap <silent> <F4> :call ToggleThemeMode()<CR>

" 分析启动时间
nnoremap <F12> :StartupTime<CR>

" ===================================================
" 基础编辑映射
" ===================================================

" === 文件操作 ===
nnoremap <leader>w :w<CR>                  " 快速保存
nnoremap <leader>q :q<CR>                  " 安全退出
nnoremap <leader>Q :qa!<CR>                " 强制退出
nnoremap <leader>s :wq<CR>                 " 保存并退出

" === 缓冲区管理 ===
nnoremap <silent> <leader>bn :bn<CR>       " 下一个缓冲区
nnoremap <silent> <leader>bp :bp<CR>       " 上一个缓冲区
nnoremap <silent> <leader>bd :bd<CR>       " 关闭当前缓冲区
nnoremap <leader>bl :buffers<CR>           " 列出缓冲区

" === 代码编辑 ===
vnoremap < <gv                             " 保持选中状态缩进
vnoremap > >gv                             " 保持选中状态取消缩进
nnoremap Y y$                              " 复制到行尾
nnoremap <leader>p "0p                     " 粘贴最后一次复制内容
nnoremap <leader>P "0P

" ===================================================
" 窗口管理映射
" ===================================================

" === 窗口导航 ===
nnoremap <C-h> <C-w>h                      " 向左切换窗口
nnoremap <C-j> <C-w>j                      " 向下切换窗口
nnoremap <C-k> <C-w>k                      " 向上切换窗口
nnoremap <C-l> <C-w>l                      " 向右切换窗口

" === 窗口调整 ===
nnoremap <silent> <C-Left> :vertical resize -5<CR>
nnoremap <silent> <C-Right> :vertical resize +5<CR>
nnoremap <silent> <C-Up> :resize -5<CR>
nnoremap <silent> <C-Down> :resize +5<CR>

" === 窗口创建 ===
nnoremap <leader>v :vsplit<CR>             " 垂直分割
nnoremap <leader>h :split<CR>              " 水平分割
nnoremap <leader>o :only<CR>               " 关闭其他窗口

" ===================================================
" 搜索与替换
" ===================================================

" === 搜索优化 ===
nnoremap <silent> <leader>/ :nohlsearch<CR>" 取消高亮
nnoremap n nzz                             " 搜索结果居中
nnoremap N Nzz
vnoremap // y/<C-R>"<CR>                   " 可视化模式搜索选中文本

" === 全局替换 ===
nnoremap <leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
xnoremap <leader>r "sy:%s/<C-r>s//g<Left><Left>

" ===================================================
" 代码操作增强
" ===================================================

" === 代码折叠 ===
" nnoremap <space> za                        " 切换折叠 写到base里面了
vnoremap <space> zf                        " 创建折叠

" === 快速跳转 ===
nnoremap gb `[                            " 跳转到上次编辑位置
nnoremap <leader>j :%!python -m json.tool<CR> " 格式化JSON

" === 注释切换 ===
" nmap <leader>c <Plug>CommentaryLine       " 需要vim-commentary插件
" xmap <leader>c <Plug>Commentary

" 需要vim-commentary插件
nmap <C-/> <Plug>CommentaryLine
xmap <C-/> <Plug>Commentary

" ===================================================
" 特殊模式优化(奇奇怪怪)
" ===================================================

" === 命令行模式 ===
cnoremap <C-a> <Home>                     " 行首
cnoremap <C-e> <End>                      " 行尾
cnoremap <C-p> <Up>                       " 历史记录上一条
cnoremap <C-n> <Down>                     " 历史记录下一条

" === 插入模式 ===
" inoremap jk <ESC>                         " 快速退出插入模式
" 移动光标
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" ===================================================
" 特自定义功能键（后续换到功能区）
" ===================================================

" === 实用功能 ===
nnoremap <leader>ev :vsplit $MYVIMRC<CR>  " 编辑vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>  " 重载配置

" 切换相对行号
nnoremap <silent> <leader>rn :set relativenumber!<CR>

" 清除行尾空格
nnoremap <leader>cw :%s/\s\+$//<CR>:let @/=''<CR>

" 检查未使用的键位（需要插件）
" nnoremap <leader>ck :map<CR>
