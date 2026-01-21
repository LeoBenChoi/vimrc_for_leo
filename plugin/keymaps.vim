" ============================================================================
" 键位映射配置
" 文件位置: ~/.vim/plugin/keymaps.vim
" 说明: 此文件会在 Vim 启动时自动加载
" ============================================================================

" 注意：Leader 键在 vimrc.vim 中定义为 <Space>
" 如果未定义，请确保在 vimrc.vim 中设置：let mapleader = "\<Space>"

" ============================================================================
" 基础键位映射
" ============================================================================

" 取消搜索高亮
nnoremap <silent> <Leader><Leader> :nohlsearch<CR>

" 快速保存
nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :w!<CR>

" 快速退出
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>

" 保存并退出
nnoremap <Leader>x :x<CR>

" ============================================================================
" 窗口导航
" ============================================================================

" 使用 Ctrl+h/j/k/l 在窗口间导航
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 调整窗口大小
nnoremap <Leader>+ :resize +5<CR>
nnoremap <Leader>- :resize -5<CR>
nnoremap <Leader>> :vertical resize +5<CR>
nnoremap <Leader>< :vertical resize -5<CR>

" ============================================================================
" 缓冲区导航
" ============================================================================

" 切换到上一个/下一个缓冲区
nnoremap <Leader>bp :bprevious<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bd :bdelete<CR>

" ============================================================================
" 行移动（可选）
" ============================================================================

" 在可视模式下，J/K 可以移动选中的行
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" 保持搜索结果在屏幕中央
nnoremap n nzzzv
nnoremap N Nzzzv

" 保持跳转结果在屏幕中央
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
