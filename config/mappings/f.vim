"==============================================================
" config/mappings/f.vim
" FZF 模糊搜索快捷键：所有 f 开头的快捷键统一管理
"==============================================================

if exists('g:loaded_f_mappings')
  finish
endif
let g:loaded_f_mappings = 1

"==============================================================
" f / F - FZF 模糊搜索套件
"==============================================================
" 规范：所有 FZF 相关快捷键统一归档在 f 段，保持肌肉记忆一致

" 基础文件搜索
" ff -> Files：当前工作区文件模糊搜索
nnoremap <silent> <leader>ff :Files<CR>

" fg -> GitFiles：仅匹配 Git 跟踪文件
nnoremap <silent> <leader>fg :GFiles<CR>

" fr -> Ripgrep：内容级搜索（rg 必需）
nnoremap <silent> <leader>fr :Rg<CR>

" fb -> Buffers：列出所有 buffer，支持模糊选择
nnoremap <silent> <leader>fb :Buffers<CR>

" 扩展搜索功能（需要 fzf.vim 中的函数支持）
" f. -> 当前目录文件搜索
if exists('*FzfFiles')
  nnoremap <silent> <leader>f. :call FzfFiles()<CR>
endif

" fp -> 项目根目录文件搜索（Git 根目录）
if exists('*FzfProjectFiles')
  nnoremap <silent> <leader>fp :call FzfProjectFiles()<CR>
endif

" fh -> 最近打开的文件
if exists('*FzfRecentFiles')
  nnoremap <silent> <leader>fh :call FzfRecentFiles()<CR>
endif

" fc -> 命令历史
if exists('*FzfCommandHistory')
  nnoremap <silent> <leader>fc :call FzfCommandHistory()<CR>
endif

" fs -> 搜索历史
if exists('*FzfSearchHistory')
  nnoremap <silent> <leader>fs :call FzfSearchHistory()<CR>
endif

" ft -> 标签搜索（需要 ctags）
if exists('*FzfTags')
  nnoremap <silent> <leader>ft :call FzfTags()<CR>
endif

" fb -> 当前文件符号搜索（注意：与 Buffers 冲突，但功能不同）
" 如果 FZF 已加载，fb 优先用于 buffer 搜索
" 如果需要文件符号搜索，可以使用其他快捷键或直接调用函数

" fG -> Git 提交搜索
if exists('*FzfCommits')
  nnoremap <silent> <leader>fG :call FzfCommits()<CR>
endif

" fB -> Git 分支搜索
if exists('*FzfBranches')
  nnoremap <silent> <leader>fB :call FzfBranches()<CR>
endif

" fS -> Git 状态搜索（未暂存的文件）
if exists('*FzfGitStatus')
  nnoremap <silent> <leader>fS :call FzfGitStatus()<CR>
endif

