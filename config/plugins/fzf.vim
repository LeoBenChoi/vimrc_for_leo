"==============================================================
" config/plugins/fzf.vim
" FZF 模糊搜索配置：文件、内容、缓冲区、Git 等搜索功能
"==============================================================

if exists('g:loaded_fzf_config')
  finish
endif
let g:loaded_fzf_config = 1

"==============================================================
" 1. FZF 基础配置
"==============================================================
" 如果 FZF 未安装，跳过配置
if !exists(':Files')
  finish
endif

" FZF 窗口布局配置
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" FZF 颜色配置（适配主题）
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment']
      \ }

" FZF 历史记录文件
let g:fzf_history_dir = expand('~/.vim/fzf-history')

" 创建历史记录目录（如果不存在）
if !isdirectory(g:fzf_history_dir)
  call mkdir(g:fzf_history_dir, 'p')
endif

"==============================================================
" 2. ripgrep (Rg) 配置
"==============================================================
" ripgrep 命令参数
" --column: 显示列号
" --line-number: 显示行号
" --no-heading: 不显示文件头
" --color=always: 始终显示颜色
" --smart-case: 智能大小写匹配
" --hidden: 搜索隐藏文件
" --follow: 跟随符号链接
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" 自定义 Rg 命令（如果 ripgrep 可用）
if executable('rg')
  " 使用 ripgrep 进行内容搜索
  command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --follow '.shellescape(<q-args>),
        \   1,
        \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%'),
        \   <bang>0)
else
  " 如果 ripgrep 不可用，使用 grep 作为后备
  " 静默记录到消息历史，不显示（可通过 :messages 查看）
  silent! echohl WarningMsg
  silent! echomsg '[环境检测] ripgrep (rg) 未安装，<Space>fr 命令将无法使用'
  silent! echomsg '[安装方法] Windows: choco install ripgrep 或 scoop install ripgrep'
  silent! echomsg '[安装方法] 或访问: https://github.com/BurntSushi/ripgrep/releases'
  silent! echomsg '[FZF] ripgrep (rg) 未安装，内容搜索功能将受限'
  silent! echomsg '请安装: choco install ripgrep 或 scoop install ripgrep'
  silent! echohl None
endif

"==============================================================
" 3. Git 文件搜索配置
"==============================================================
" Git 文件搜索（仅搜索 Git 跟踪的文件）
" 默认忽略 .gitignore 中的文件
let g:fzf_git_files_command = 'git ls-files --cached --others --exclude-standard'

"==============================================================
" 4. 文件搜索配置
"==============================================================
" 文件搜索命令（排除常见不需要的文件）
let g:fzf_files_command = 'fd --type f --hidden --follow --exclude .git'

" 如果 fd 不可用，使用 find 作为后备
if !executable('fd')
  let g:fzf_files_command = 'find . -type f -not -path "*/\.git/*"'
endif

"==============================================================
" 5. 自定义搜索函数（全局函数，供 mappings/f.vim 调用）
"==============================================================
" 在当前目录下搜索文件
function! FzfFiles() abort
  let l:dir = expand('%:p:h')
  if empty(l:dir)
    let l:dir = getcwd()
  endif
  call fzf#vim#files(l:dir, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}, 'right:50%'))
endfunction

" 在项目根目录（Git 根目录）搜索文件
function! FzfProjectFiles() abort
  let l:git_dir = system('git rev-parse --show-toplevel 2>nul')
  if v:shell_error == 0
    let l:git_dir = substitute(l:git_dir, '\n$', '', '')
    call fzf#vim#files(l:git_dir, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}, 'right:50%'))
  else
    call fzf#vim#files('.', fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}, 'right:50%'))
  endif
endfunction

" 搜索最近打开的文件（使用 vim-startify 的历史记录）
function! FzfRecentFiles() abort
  " 使用 vim-startify 的最近文件列表
  if exists('*startify#get_files')
    let l:files = startify#get_files()
    call fzf#vim#files('.', {
          \ 'source': l:files,
          \ 'options': ['--layout=reverse', '--info=inline']
          \ })
  else
    " 如果没有 startify，使用 vim 的 oldfiles
    call fzf#run(fzf#wrap({
          \ 'source': map(v:oldfiles, 'fnamemodify(v:val, ":~")'),
          \ 'options': ['--layout=reverse', '--info=inline', '--preview', 'bat --color=always {}']
          \ }))
  endif
endfunction

" 搜索命令历史
function! FzfCommandHistory() abort
  if exists('*fzf#vim#command_history')
    call fzf#vim#command_history({'options': ['--layout=reverse', '--info=inline']})
  else
    call fzf#run(fzf#wrap({
          \ 'source': map(range(1, &history), 'histget(":", -1 * v:val)'),
          \ 'options': ['--layout=reverse', '--info=inline']
          \ }))
  endif
endfunction

" 搜索搜索历史
function! FzfSearchHistory() abort
  if exists('*fzf#vim#search_history')
    call fzf#vim#search_history({'options': ['--layout=reverse', '--info=inline']})
  else
    call fzf#run(fzf#wrap({
          \ 'source': map(range(1, &history), 'histget("/", -1 * v:val)'),
          \ 'options': ['--layout=reverse', '--info=inline']
          \ }))
  endif
endfunction

" 搜索标签（需要 ctags）
function! FzfTags() abort
  if exists('*fzf#vim#tags')
    call fzf#vim#tags('', {'options': ['--layout=reverse', '--info=inline']})
  else
    echohl WarningMsg
    echomsg 'FZF tags 功能需要 ctags，请先安装 ctags'
    echohl None
  endif
endfunction

" 搜索当前文件中的符号（需要 ctags 或 LSP）
function! FzfBTags() abort
  if exists('*fzf#vim#buffer_tags')
    call fzf#vim#buffer_tags('', {'options': ['--layout=reverse', '--info=inline']})
  else
    echohl WarningMsg
    echomsg 'FZF buffer tags 功能需要 ctags，请先安装 ctags'
    echohl None
  endif
endfunction

" 搜索 Git 提交
function! FzfCommits() abort
  if exists('*fzf#vim#commits')
    call fzf#vim#commits({'options': ['--layout=reverse', '--info=inline']})
  else
    echohl WarningMsg
    echomsg 'FZF commits 功能需要 Git 仓库'
    echohl None
  endif
endfunction

" 搜索 Git 分支
function! FzfBranches() abort
  if exists('*fzf#vim#git_branches')
    call fzf#vim#git_branches({'options': ['--layout=reverse', '--info=inline']})
  else
    echohl WarningMsg
    echomsg 'FZF branches 功能需要 Git 仓库'
    echohl None
  endif
endfunction

" 搜索 Git 状态（未暂存的文件）
function! FzfGitStatus() abort
  if exists('*fzf#vim#git_status')
    call fzf#vim#git_status({'options': ['--layout=reverse', '--info=inline']})
  else
    echohl WarningMsg
    echomsg 'FZF git status 功能需要 Git 仓库'
    echohl None
  endif
endfunction

"==============================================================
" 6. 快捷键映射
"==============================================================
" 注意：所有 FZF 相关快捷键已迁移到 mappings/f.vim
" 这里只保留函数定义，快捷键映射在 mappings/f.vim 中统一管理

"==============================================================
" 7. FZF 窗口快捷键（在 FZF 窗口中可用）
"==============================================================
" 这些快捷键在 FZF 窗口中自动可用，无需额外配置
"   Ctrl-T: 在新标签页打开
"   Ctrl-X: 在水平分割窗口打开
"   Ctrl-V: 在垂直分割窗口打开
"   Ctrl-Q: 将选中项添加到 quickfix 列表
"   Enter: 在当前窗口打开
"   Ctrl-A: 全选
"   Ctrl-D: 取消全选
"   Tab: 多选模式切换
"   Shift-Tab: 多选模式切换

"==============================================================
" 8. 高级配置和优化
"==============================================================
" FZF 预览窗口命令
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" FZF 默认选项
let g:fzf_default_opts = {
      \ '--reverse': '',
      \ '--border': '',
      \ '--info': 'inline',
      \ '--height': '60%',
      \ '--layout': 'reverse',
      \ '--bind': 'ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all',
      \ '--color': 'fg+:11,bg+:-1,gutter:-1,hl:10,hl+:13,marker:11,prompt:12,pointer:13'
      \ }

" FZF 文件搜索默认命令
let g:fzf_files_command = executable('fd') 
      \ ? 'fd --type f --hidden --follow --exclude .git'
      \ : 'find . -type f -not -path "*/\.git/*"'

"==============================================================
" 9. 诊断命令
"==============================================================
" 检查 FZF 配置状态
function! FzfConfigStatus() abort
  echomsg '=== FZF 配置状态 ==='
  echomsg '配置文件已加载: ' . (exists('g:loaded_fzf_config') ? '是' : '否')
  echomsg 'FZF 命令存在: ' . (exists(':Files') == 2 ? '是' : '否')
  echomsg 'ripgrep (rg) 可用: ' . (executable('rg') ? '是' : '否')
  echomsg 'fd 可用: ' . (executable('fd') ? '是' : '否')
  echomsg 'Git 可用: ' . (executable('git') ? '是' : '否')
  echomsg 'FZF 历史目录: ' . g:fzf_history_dir
  echomsg '=================='
endfunction
command! FzfConfigStatus call FzfConfigStatus()

