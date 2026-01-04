"==============================================================
" config/init/basic.vim
" 基础配置：跨平台基础设置，无插件依赖
"==============================================================

if exists('g:loaded_basic_config')
  finish
endif
let g:loaded_basic_config = 1

"==============================================================
" 1. 编码设置
"==============================================================
set encoding=utf-8 " 设置编码为utf-8，防止coc.nvim报错
set fileencodings=utf-8,ucs-bom,gbk,latin1

" 模糊宽度字符（如 emoji、图标）显示各有各的bug……酌情修改
" 单宽度：一个字符占一个宽度,解决状态栏和侧边栏图标显示问题
" 双宽度：一个字符占两个宽度,解决ansi代码对齐错位问题
set ambiwidth=single                
" set ambiwidth=double

"==============================================================
" 1.2. Shell 设置（Windows 下使用 PowerShell）
"==============================================================
if has('win32') || has('win64') || has('win16')
  " Windows 下默认使用 PowerShell（pwsh 或 powershell）
  " 优先使用 pwsh（PowerShell Core），如果不存在则使用 powershell（Windows PowerShell）
  if executable('pwsh')
    set shell=pwsh
    let &shellcmdflag = '-NoProfile -Command'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s'
  elseif executable('powershell')
    set shell=powershell
    let &shellcmdflag = '-NoProfile -Command'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s'
  endif
  " 如果 PowerShell 不可用，保持默认的 cmd.exe
endif

"==============================================================
" 1.1. 换行符设置（统一使用 LF）
"==============================================================
" 新文件默认使用 Unix 格式（LF）
set fileformat=unix
set fileformats=unix,dos  " 保存文件自动保存为unix,dos格式

"==============================================================
" 2. 编辑体验（不依赖任何插件）
"==============================================================
set number                         " 显示绝对行号
set relativenumber                 " 同时显示相对行号，便于跳行
set numberwidth=4                  " 行号列宽度（为符号预留空间）
set signcolumn=yes                 " 始终显示符号列（为诊断和 Git 符号预留空间）
set hidden                         " 允许切换 buffer 时保留未保存内容
set expandtab                      " 将 Tab 转换为空格
set tabstop=4                      " Tab 视觉宽度（只影响显示）
set shiftwidth=4                   " 自动缩进宽度（默认 4 个空格）
" 注意：文件类型特定的缩进配置在 config/init/indent.vim 中

set smartcase                      " 搜索包含大写时自动切换到大小写敏感
set ignorecase                     " 默认忽略大小写，配合 smartcase 更智能
set hlsearch                       " 高亮显示所有搜索结果
set incsearch                      " 输入搜索模式时实时高亮匹配结果
set mouse=a                        " 全模式启用鼠标（终端支持时生效）
set scrolloff=5                    " 上下翻页和滚动时保留 5 行缓冲区

"==============================================================
" 2.1.5. 命令行补全设置（末行模式 Tab 补全）
"==============================================================
set wildmenu                        " 启用命令行补全菜单
set wildmode=full                   " 让菜单垂直显示，补全项可用上下键垂直选择
if exists('+pumheight')
  set pumheight=5                   " 补全菜单最大高度限制为 5 行
endif
" 使用弹出菜单（popup menu）样式，让补全菜单垂直显示
if has('patch-8.2.3382') || has('nvim-0.5')
  set wildoptions=pum               " 使用弹出菜单样式（垂直显示）
endif
set wildignorecase                 " 命令行补全时忽略大小写

"==============================================================
" 2.2. 缩进可视化（纯 Vim list 模式）
"==============================================================
" 使用 Vim 内置的 list 功能显示不可见字符
" 设置 listchars 显示多种不可见字符：
"   tab:      - 制表符显示为空格（由于已设置 expandtab，tab 会被转换为空格）
"   trail:-   - 尾随空格显示为 -
"   eol:⏎     - 行尾显示为 ⏎（回车键符号，推荐）
"               其他可选：↵ (U+21B5) 或 ↲ (U+21B2) 或 $ (传统)
"   nbsp:␣    - 非断行空格显示为 ␣
"   extends:> - 行尾延伸字符显示为 >
"   precedes:< - 行首前置字符显示为 <
" 注意：multispace（缩进符号）配置在 config/init/indent.vim 中
" tab 显示为 | 加空格
set listchars=tab:\|\ ,trail:-,eol:↵,nbsp:␣,extends:>,precedes:<
" 默认启用 list 模式（显示不可见字符）
set list

" 设置 list 模式显示字符的高亮颜色（根据深色/浅色主题自动调整）
" NonText: 控制行尾字符（eol）和延伸字符（extends/precedes）的颜色
" SpecialKey: 控制制表符、尾随空格、前导空格等字符的颜色
" 根据背景色自动设置合适的颜色
function! s:set_list_colors() abort
  if &background ==# 'dark'
    " 深色主题：使用浅灰色，在深色背景上可见
    hi NonText    ctermfg=250 guifg=#666666  " 浅灰色（终端：250，GUI：#aaaaaa）
    hi SpecialKey ctermfg=250 guifg=#666666  " 浅灰色（终端：250，GUI：#aaaaaa）
  else
    " 浅色主题：使用灰色，在浅色背景上可见
    hi NonText    ctermfg=240 guifg=#dddddd  " 灰色（终端：240深灰，GUI：#BCBCBC浅灰）
    hi SpecialKey ctermfg=240 guifg=#dddddd  " 灰色（终端：240深灰，GUI：#BCBCBC浅灰）
  endif
endfunction

" 初始设置（根据当前背景色）
call s:set_list_colors()

" 在主题切换和背景色变化时重新设置颜色
augroup ListModeColors
  autocmd!
  autocmd ColorScheme * call s:set_list_colors()
  autocmd OptionSet background call s:set_list_colors()
augroup END
" 注意：如果觉得显示太多字符太乱，可以只保留 tab, trail, eol

" 文件自动重新加载配置
set autoread                       " 当文件在外部被修改时自动重新读取（不显示 W11 警告）
set updatetime=2000                " 更新间隔（毫秒），用于检查文件变更和触发 CursorHold 事件
"==============================================================
" 2.1. 文本排版
"==============================================================
set textwidth=79                   " 超过 79 列自动换行
set formatoptions+=t               " 输入时根据 textwidth 自动换行
set colorcolumn=80                 " 可视化提示 79 列限制（第 80 列高亮）

"==============================================================
" 3. 自动备份配置（集中管理）
"==============================================================
" 备份文件目录：~/.vim/.backup/
set backup
let s:backup_dir = expand('~/.vim/.backup')
if !isdirectory(s:backup_dir)
  call mkdir(s:backup_dir, 'p', 0700)
endif
execute 'set backupdir=' . fnameescape(s:backup_dir . '//')
set backupext=.bak

" 交换文件目录：~/.vim/.swap/
set swapfile
let s:swap_dir = expand('~/.vim/.swap')
if !isdirectory(s:swap_dir)
  call mkdir(s:swap_dir, 'p', 0700)
endif
execute 'set directory=' . fnameescape(s:swap_dir . '//')

" 撤销历史目录：~/.vim/.undo/
set undofile
let s:undo_dir = expand('~/.vim/.undo')
if !isdirectory(s:undo_dir)
  call mkdir(s:undo_dir, 'p', 0700)
endif
execute 'set undodir=' . fnameescape(s:undo_dir . '//')

" 视图文件目录：~/.vim/.view/
let s:view_dir = expand('~/.vim/.view')
if !isdirectory(s:view_dir)
  call mkdir(s:view_dir, 'p', 0700)
endif
execute 'set viewdir=' . fnameescape(s:view_dir)

"==============================================================
" 4. 光标位置恢复（打开文件时回到上次编辑位置）
"==============================================================
" 启用 viminfo 来保存编辑历史（包括光标位置）
" viminfo 文件位置：~/.vim/.viminfo
let s:viminfo_file = expand('~/.vim/.viminfo')
" 确保目录存在
let s:viminfo_dir = fnamemodify(s:viminfo_file, ':h')
if !isdirectory(s:viminfo_dir)
  call mkdir(s:viminfo_dir, 'p', 0700)
endif
" 设置 viminfo：'100（100个文件标记）,>50（50行删除/复制历史）,s10（10个搜索历史）,h（禁用高亮）,n路径（viminfo文件位置）
" 使用 let 设置 viminfo 选项，路径直接拼接
let &viminfo = "'100,<50,s10,h,n" . s:viminfo_file

" 自动恢复到上次编辑位置
augroup RestoreCursorPosition
  autocmd!
  " 打开文件时，如果存在上次编辑位置，自动跳转
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif
augroup END

"==============================================================
" 5. 文件自动重新加载配置
"==============================================================
" 当文件在外部被修改时，自动重新加载文件内容
" 避免显示 W11 警告："编辑开始后，文件已变动"
" 
" 策略：
" 1. 如果文件在外部被修改且当前 buffer 没有未保存修改，自动重新加载
" 2. 如果文件在外部被修改但当前 buffer 有未保存修改，不自动重新加载（避免冲突）
" 3. 定期检查文件变更，确保及时更新

augroup AutoReload
  autocmd!

  " 自定义文件变更处理，完全避免 W11 警告
  " 当文件在外部被修改时，如果当前 buffer 没有未保存修改，自动重新加载
  " 如果当前 buffer 有未保存修改，不自动重新加载（避免冲突）
  " 注意：FileChangedShell 事件在文件变更时触发，我们可以通过执行 edit 来自动重新加载
  function! s:HandleFileChanged() abort
    if expand('<afile>') ==# '' || &buftype !=# ''
      return
    endif
    if !&modified
      " 没有未保存修改，自动重新加载（不显示警告）
      " 使用 :edit! 命令强制重新加载文件（忽略警告）
      silent! edit!
      echohl WarningMsg
      echo "文件已自动重新加载: " . expand('<afile>:t')
      echohl None
    else
      " 有未保存修改，显示警告但不自动重新加载
      echohl WarningMsg
      echo "警告: 文件 " . expand('<afile>:t') . " 在外部被修改，但当前有未保存的修改"
      echo "请使用 :checktime 手动重新加载，或先保存当前修改"
      echohl None
    endif
  endfunction
  autocmd FileChangedShell * call s:HandleFileChanged()

  " 当窗口获得焦点时，检查并重新加载已更改的文件
  " 适用于：切换窗口、切换标签页、从其他应用返回 Vim
  autocmd FocusGained,BufEnter * 
        \ if mode() !=# 'c' && expand('<afile>') !=# '' && &buftype ==# '' | 
        \   silent! checktime | 
        \ endif

  " 当离开插入模式时，检查文件是否已更改
  " 如果文件已更改且当前 buffer 没有未保存修改，自动重新加载
  autocmd InsertLeave * 
        \ if expand('<afile>') !=# '' && &buftype ==# '' && !&modified | 
        \   silent! checktime | 
        \ endif

  " 定期检查文件变更（在光标静止时触发，由 updatetime 控制间隔）
  " 使用 CursorHold 事件，默认每 2 秒检查一次（updatetime=2000）
  autocmd CursorHold * 
        \ if expand('<afile>') !=# '' && &buftype ==# '' && !&modified | 
        \   silent! checktime | 
        \ endif

  " 当文件在外部被删除时，标记为已删除但保留 buffer
  " 使用 FileChangedRO 事件处理文件变为只读的情况
  autocmd FileChangedRO *
        \ if expand('<afile>') !=# '' && &buftype ==# '' |
        \   echohl WarningMsg |
        \   echo "警告: 文件 " . expand('<afile>:t') . " 在外部被删除或变为只读" |
        \   echohl None |
        \ endif

augroup END

"==============================================================
" 6. Tags 文件集中管理配置
"==============================================================
" 集中存储所有项目的 tags 文件到 ~/.vim/.tags/
let s:tags_dir = expand('~/.vim/.tags')
if !isdirectory(s:tags_dir)
  call mkdir(s:tags_dir, 'p', 0700)
endif

" 动态加载集中目录下的所有 .tags 文件
function! s:LoadCentralTagsFiles() abort
  if !isdirectory(s:tags_dir)
    return
  endif
  
  " 查找所有 .tags 文件
  let l:tags_files = glob(s:tags_dir . '/*.tags', 0, 1)
  if empty(l:tags_files)
    return
  endif
  
  " 构建 tags 路径字符串
  let l:tags_paths = []
  for l:file in l:tags_files
    " 使用绝对路径，确保 Vim 能找到
    let l:abs_path = fnamemodify(l:file, ':p')
    " Windows 路径转换为正斜杠（Vim 内部使用正斜杠）
    if has('win32') || has('win64') || has('win16')
      let l:abs_path = substitute(l:abs_path, '\\', '/', 'g')
    endif
    call add(l:tags_paths, l:abs_path)
  endfor
  
  " 添加到 tags 选项（放在最前面，优先级最高）
  if !empty(l:tags_paths)
    let l:central_tags = join(l:tags_paths, ',')
    " 如果 tags 选项已设置，在前面添加；否则直接设置
    if !empty(&tags)
      let &tags = l:central_tags . ',' . &tags
    else
      let &tags = l:central_tags . ',./tags,./TAGS,tags,TAGS;'
    endif
  endif
endfunction

" 设置 tags 搜索路径（按优先级顺序）：
" 1. 集中管理的 tags 目录（所有项目的 tags，优先级最高）
"   动态加载所有 .tags 文件
" 2. 当前文件所在目录的 tags 文件（项目本地）
" 3. 向上递归查找父目录的 tags 文件（传统方式）
" 注意：使用 ; 表示向上递归查找，直到找到或到达根目录
" 先设置基础路径
if has('win32') || has('win64') || has('win16')
  " Windows 下，将路径中的反斜杠转换为正斜杠（Vim 内部统一使用正斜杠）
  let s:tags_dir_normalized = substitute(s:tags_dir, '\\', '/', 'g')
  execute 'set tags=' . fnameescape(s:tags_dir_normalized . '//') . ',./tags,./TAGS,tags,TAGS;'
else
  execute 'set tags=' . fnameescape(s:tags_dir . '//') . ',./tags,./TAGS,tags,TAGS;'
endif

" 动态加载所有 .tags 文件
call s:LoadCentralTagsFiles()

" 在打开文件时重新加载（确保新生成的 tags 文件能被找到）
augroup LoadCentralTags
  autocmd! BufReadPost * call s:LoadCentralTagsFiles()
augroup END

" 说明：
" - ~/.vim/.tags/ 目录用于存储所有项目的 tags 文件
" - 建议为每个项目生成独立的 tags 文件，命名为：项目名.tags
" - 例如：~/.vim/.tags/myproject.tags
" - 生成命令示例：
"   ctags -R --output=~/.vim/.tags/myproject.tags /path/to/myproject
"   或使用相对路径：
"   cd /path/to/myproject && ctags -R --output=~/.vim/.tags/myproject.tags .

"==============================================================
" 7. Tags 文件自动更新配置
"==============================================================
" 配置选项
let g:tags_auto_update = get(g:, 'tags_auto_update', 1)           " 是否启用自动更新（默认启用）
let g:tags_update_on_save = get(g:, 'tags_update_on_save', 1)      " 保存时更新（默认启用）
let g:tags_update_interval = get(g:, 'tags_update_interval', 300) " 定期更新间隔（秒，默认5分钟）
let g:tags_update_delay = get(g:, 'tags_update_delay', 2)          " 防抖延迟（秒，避免频繁更新）

" 检测项目根目录（通过查找 .git、.svn、Makefile 等标记）
function! s:FindProjectRoot(file) abort
  let l:dir = fnamemodify(a:file, ':p:h')
  let l:root_markers = ['.git', '.svn', '.hg', 'Makefile', 'CMakeLists.txt', 'package.json', 'Cargo.toml', 'go.mod', 'pom.xml', 'build.gradle']
  
  " 向上查找项目根目录
  let l:current = l:dir
  let l:prev = ''
  while l:current !=# l:prev
    for l:marker in l:root_markers
      if isdirectory(l:current . '/' . l:marker) || filereadable(l:current . '/' . l:marker)
        return l:current
      endif
    endfor
    let l:prev = l:current
    let l:current = fnamemodify(l:current, ':h')
  endwhile
  
  " 如果找不到项目根目录，使用文件所在目录
  return l:dir
endfunction

" 生成项目 tags 文件名（基于项目根目录名）
function! s:GetProjectTagsFile(project_root) abort
  let l:project_name = fnamemodify(a:project_root, ':t')
  if empty(l:project_name) || l:project_name ==# '.'
    " 如果项目名称为空或为 '.'，使用父目录名
    let l:project_name = fnamemodify(a:project_root, ':h:t')
  endif
  if empty(l:project_name)
    " 如果还是为空，使用默认名称
    let l:project_name = 'default'
  endif
  return s:tags_dir . '/' . l:project_name . '.tags'
endfunction

" 检测 ctags 可执行文件（Windows 兼容）
function! s:FindCtagsExecutable() abort
  " Windows 下可能需要检测 ctags.exe
  if has('win32') || has('win64') || has('win16')
    " 先尝试检测 ctags（可能在 PATH 中）
    if executable('ctags')
      return 'ctags'
    endif
    " 再尝试检测 ctags.exe
    if executable('ctags.exe')
      return 'ctags.exe'
    endif
    " 尝试检测 Universal Ctags（uctags）
    if executable('uctags')
      return 'uctags'
    endif
    if executable('uctags.exe')
      return 'uctags.exe'
    endif
  else
    " Unix/Linux/macOS 下检测
    if executable('ctags')
      return 'ctags'
    endif
    " 尝试检测 Universal Ctags
    if executable('uctags')
      return 'uctags'
    endif
  endif
  return ''
endfunction

" 更新 tags 文件（异步执行，不阻塞 Vim）
function! s:UpdateTagsFile(file) abort
  if !g:tags_auto_update
    return
  endif
  
  " 检查 ctags 是否可用（Windows 兼容）
  let l:ctags_cmd = s:FindCtagsExecutable()
  if empty(l:ctags_cmd)
    return
  endif
  
  let l:project_root = s:FindProjectRoot(a:file)
  let l:tags_file = s:GetProjectTagsFile(l:project_root)
  
  " 构建 ctags 命令
  " 根据 ctags 版本选择不同的选项
  " 检测是否支持 --output（Universal Ctags）
  let l:version_output = system(l:ctags_cmd . ' --version 2>&1')
  let l:supports_output = l:version_output =~# 'Universal Ctags' || system(l:ctags_cmd . ' --help 2>&1') =~# '--output'
  
  if l:supports_output
    " Universal Ctags 或支持 --output 的版本
    if has('win32') || has('win64') || has('win16')
      " Windows 下使用双引号包裹路径
      let l:cmd = printf('%s -R --output="%s" --append=no "%s"',
            \ l:ctags_cmd,
            \ l:tags_file,
            \ l:project_root)
    else
      " Unix/Linux/macOS 使用 shellescape
      let l:cmd = printf('%s -R --output=%s --append=no %s',
            \ l:ctags_cmd,
            \ shellescape(l:tags_file),
            \ shellescape(l:project_root))
    endif
  else
    " Exuberant Ctags 或旧版本，使用 -f 选项
    if has('win32') || has('win64') || has('win16')
      " Windows 下使用双引号包裹路径
      let l:cmd = printf('%s -R -f "%s" "%s"',
            \ l:ctags_cmd,
            \ l:tags_file,
            \ l:project_root)
    else
      " Unix/Linux/macOS 使用 shellescape
      let l:cmd = printf('%s -R -f %s %s',
            \ l:ctags_cmd,
            \ shellescape(l:tags_file),
            \ shellescape(l:project_root))
    endif
  endif
  
  " 在后台异步执行（不阻塞 Vim）
  if has('job') && has('patch-8.0.0027')
    " 使用 job_start 异步执行（Vim 8.0+）
    call job_start([&shell, &shellcmdflag, l:cmd], {
          \ 'out_io': 'null',
          \ 'err_io': 'null',
          \ 'exit_cb': {job, status -> execute('echo "Tags 已更新: ' . fnamemodify(l:tags_file, ':t') . '"', '')}
          \})
  elseif has('nvim')
    " Neovim 使用 jobstart
    call jobstart([&shell, &shellcmdflag, l:cmd], {
          \ 'stdout_buffered': v:false,
          \ 'stderr_buffered': v:false,
          \ 'on_exit': {job, code -> execute('echo "Tags 已更新: ' . fnamemodify(l:tags_file, ':t') . '"', '')}
          \})
  else
    " 旧版本 Vim，使用同步方式（但使用 silent 减少干扰）
    silent! call system(l:cmd)
    if v:shell_error == 0
      echo "Tags 已更新: " . fnamemodify(l:tags_file, ':t')
    endif
  endif
endfunction

" 防抖更新（避免频繁更新）
let s:tags_update_timer = -1
function! s:UpdateTagsFileDebounced(file) abort
  if !g:tags_auto_update
    return
  endif
  
  " 停止之前的定时器
  if s:tags_update_timer != -1
    if has('timers')
      call timer_stop(s:tags_update_timer)
    endif
    let s:tags_update_timer = -1
  endif
  
  " 设置新的定时器（防抖）
  if has('timers')
    let s:tags_update_timer = timer_start(g:tags_update_delay * 1000, { -> s:UpdateTagsFile(a:file) })
  else
    " 不支持定时器，直接更新
    call s:UpdateTagsFile(a:file)
  endif
endfunction

" 手动更新 tags 命令
command! -nargs=0 UpdateTags call s:UpdateTagsFile(expand('%:p'))

" 检查 tags 文件是否可被找到
function! s:CheckTagsFiles() abort
  echohl Title
  echomsg '========================================'
  echomsg '  Tags 文件检查'
  echomsg '========================================'
  echohl None
  echo ''
  
  " 1. 检查 tags 搜索路径
  echohl Question
  echomsg '[1] Tags 搜索路径:'
  echohl None
  echo '  ' . &tags
  echo ''
  
  " 2. 检查集中目录
  echohl Question
  echomsg '[2] 集中 tags 目录:'
  echohl None
  echo '  路径: ' . s:tags_dir
  echo '  存在: ' . (isdirectory(s:tags_dir) ? '是' : '否')
  
  " 列出目录下的所有 tags 文件
  if isdirectory(s:tags_dir)
    let l:tags_files = glob(s:tags_dir . '/*.tags', 0, 1)
    if !empty(l:tags_files)
      echohl MoreMsg
      echomsg '  找到的 tags 文件:'
      echohl None
      for l:file in l:tags_files
        let l:file_size = getfsize(l:file)
        echo '    - ' . fnamemodify(l:file, ':t') . ' (' . l:file_size . ' 字节)'
      endfor
    else
      echohl WarningMsg
      echomsg '  ⚠ 未找到任何 .tags 文件'
      echohl None
    endif
  endif
  echo ''
  
  " 3. 测试 tags 文件是否可读
  echohl Question
  echomsg '[3] 测试 tags 文件读取:'
  echohl None
  let l:test_files = glob(s:tags_dir . '/*.tags', 0, 1)
  if !empty(l:test_files)
    for l:file in l:test_files[:2]  " 只测试前 3 个
      let l:readable = filereadable(l:file)
      echo '  ' . fnamemodify(l:file, ':t') . ': ' . (l:readable ? '可读' : '不可读')
      if l:readable
        let l:lines = readfile(l:file, '', 5)  " 读取前 5 行
        if !empty(l:lines)
          echo '    首行: ' . l:lines[0]
        endif
      endif
    endfor
  else
    echohl WarningMsg
    echomsg '  ⚠ 没有找到 tags 文件进行测试'
    echohl None
  endif
  echo ''
  
  " 4. 检查当前文件的 tags
  echohl Question
  echomsg '[4] 当前文件信息:'
  echohl None
  let l:current_file = expand('%:p')
  if !empty(l:current_file)
    echo '  文件: ' . l:current_file
    let l:project_root = s:FindProjectRoot(l:current_file)
    echo '  项目根目录: ' . l:project_root
    let l:expected_tags = s:GetProjectTagsFile(l:project_root)
    echo '  预期 tags 文件: ' . l:expected_tags
    echo '  存在: ' . (filereadable(l:expected_tags) ? '是' : '否')
  else
    echohl WarningMsg
    echomsg '  ⚠ 没有打开的文件'
    echohl None
  endif
  echo ''
  
  " 5. 测试 tag 查找
  echohl Question
  echomsg '[5] 测试 tag 查找:'
  echohl None
  let l:tagfiles = tagfiles()
  if !empty(l:tagfiles)
    echohl MoreMsg
    echomsg '  ✓ 找到 ' . len(l:tagfiles) . ' 个 tags 文件:'
    echohl None
    for l:tagfile in l:tagfiles
      echo '    - ' . l:tagfile
    endfor
  else
    echohl WarningMsg
    echomsg '  ✗ 未找到任何 tags 文件'
    echohl None
    echohl Question
    echomsg '[提示] 请检查：'
    echomsg '  1. tags 文件是否在 ~/.vim/.tags/ 目录下'
    echomsg '  2. 文件扩展名是否为 .tags'
    echomsg '  3. 运行 :UpdateTags 生成 tags 文件'
    echohl None
  endif
  
  echohl Title
  echomsg '========================================'
  echohl None
endfunction

command! -nargs=0 CheckTagsFiles call s:CheckTagsFiles()

" 自动更新 tags 的 autocmd
if g:tags_auto_update
  augroup AutoUpdateTags
    autocmd!
    
    " 保存文件时更新 tags（如果启用）
    if g:tags_update_on_save
      autocmd BufWritePost *
            \ if expand('<afile>') !=# '' && &buftype ==# '' |
            \   call s:UpdateTagsFileDebounced(expand('<afile>:p')) |
            \ endif
    endif
    
    " 定期更新 tags（使用 CursorHold 事件，由 updatetime 控制）
    " 注意：这会在光标静止时触发，频率由 updatetime 控制
    " 为了避免过于频繁，我们使用一个计数器
    let s:tags_update_counter = 0
    function! s:PeriodicUpdateTags() abort
      if !g:tags_auto_update
        return
      endif
      let s:tags_update_counter += 1
      " 每 300 秒（5分钟）更新一次（假设 updatetime=2000ms，需要 150 次）
      let l:update_threshold = g:tags_update_interval * 1000 / &updatetime
      if s:tags_update_counter >= l:update_threshold
        let s:tags_update_counter = 0
        if expand('%:p') !=# ''
          call s:UpdateTagsFile(expand('%:p'))
        endif
      endif
    endfunction
    
    autocmd CursorHold *
          \ if expand('<afile>') !=# '' && &buftype ==# '' && mode() !=# 'c' |
          \   call s:PeriodicUpdateTags() |
          \ endif
  augroup END
endif

