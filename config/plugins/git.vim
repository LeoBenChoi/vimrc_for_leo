"==============================================================
" config/plugins/git.vim
" Git 插件配置：vim-fugitive, vim-gitgutter, nerdtree-git-plugin
" 确保与 coc.nvim 兼容
"==============================================================

if exists('g:loaded_git_config')
  finish
endif
let g:loaded_git_config = 1

"==============================================================
" 1. vim-gitgutter 配置（Git 差异显示）
"==============================================================
if exists(':GitGutterEnable')
  " 基础设置
  let g:gitgutter_enabled = 1                    " 启用 GitGutter
  let g:gitgutter_map_keys = 0                   " 禁用默认快捷键（使用自定义映射）
  let g:gitgutter_highlight_lines = 0            " 不高亮整行（避免与 coc 高亮冲突）
  let g:gitgutter_highlight_linenrs = 0          " 不高亮行号
  
  " 性能优化
  let g:gitgutter_async = 1                      " 异步更新（提高性能）
  let g:gitgutter_realtime = 1                   " 实时更新
  let g:gitgutter_eager = 0                      " 延迟更新（节省资源）
  
  " 符号设置（使用简洁的符号）
  let g:gitgutter_sign_added = '+'               " 新增行
  let g:gitgutter_sign_modified = '~'            " 修改行
  let g:gitgutter_sign_removed = '_'             " 删除行
  let g:gitgutter_sign_removed_first_line = '‾'  " 删除的第一行
  let g:gitgutter_sign_removed_above_and_below = '=' " 删除的上下行
  let g:gitgutter_sign_modified_removed = '~'    " 修改并删除
  
  " 与 coc.nvim 兼容性设置
  " 注意：coc.nvim 和 gitgutter 都需要使用 signcolumn
  " 由于 signcolumn=yes 已在 lsp_coc.vim 中设置，这里不需要额外配置
  " 两个插件可以共享同一个 signcolumn
  
  " 更新频率（与 coc.nvim 的 updatetime=300 兼容）
  " updatetime 已在 lsp_coc.vim 中设置为 300ms，这对 gitgutter 也合适
endif

"==============================================================
" 2. vim-fugitive 配置（Git 集成）
"==============================================================
if exists(':Git')
  " 基础设置
  " vim-fugitive 通常不需要太多配置，使用默认设置即可
  
  " 自定义命令别名（可选）
  " 注意：:Git 和 :G 都是 fugitive 提供的命令，无需额外配置
endif

"==============================================================
" 3. nerdtree-git-plugin 配置（NERDTree Git 状态）
"==============================================================
" 注意：这些配置必须在插件加载前设置，所以直接设置变量
" 
" 禁用 Git 状态显示（解决对齐问题）
" 由于 nerdtree-git-plugin 会显示多个 Git 状态符号（如 + #, + !），
" 导致字符数量不一致（1个字符 vs 2个字符），造成文件名缩进不对齐。
" 如果以后需要 Git 状态显示，可以启用下面的配置。
let g:NERDTreeGitStatusEnable = 0              " 禁用 Git 状态显示（解决对齐问题）

" 如果需要启用 Git 状态显示，取消下面的注释并注释掉上面的禁用选项
" let g:NERDTreeGitStatusEnable = 1              " 启用 Git 状态显示
" let g:NERDTreeGitStatusShowIgnored = 1         " 显示被忽略的文件状态
" let g:NERDTreeGitStatusUseNerdFonts = 0        " 不使用 Nerd Fonts（使用 ASCII 字符，兼容性更好）
" let g:NERDTreeGitStatusUpdateOnWrite = 1       " 写入文件时更新状态
" let g:NERDTreeGitStatusUpdateOnCursorHold = 1   " 光标停留时更新状态

"==============================================================
" 4. 自动命令（确保 Git 状态正确更新）
"==============================================================
augroup git_plugin_config
  autocmd!
  " 当文件写入后，更新 Git 状态
  if exists(':GitGutterEnable')
    autocmd BufWritePost * GitGutter
  endif
augroup END
