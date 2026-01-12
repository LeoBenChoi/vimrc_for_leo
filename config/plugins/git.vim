"==============================================================
" config/plugins/git.vim
" Git 插件配置：vim-fugitive, vim-gitgutter, gv.vim
" 确保与 coc.nvim 兼容
"==============================================================

if exists('g:loaded_git_config')
  finish
endif
let g:loaded_git_config = 1

"==============================================================
" 1. vim-gitgutter 配置（Git 差异显示）
"==============================================================
" 开启符号列（用于显示 GitGutter 标记和 coc.nvim 诊断信息）
set signcolumn=yes

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
" 3. gv.vim 配置（提交历史浏览器）
"==============================================================
" gv.vim 依赖 vim-fugitive，通常不需要额外配置
" 使用 :GV 命令查看提交历史

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
