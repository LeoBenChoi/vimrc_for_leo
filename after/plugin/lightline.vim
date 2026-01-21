" ============================================================================
" lightline.vim 状态栏插件配置
" 文件位置: ~/.vim/after/plugin/lightline.vim
" 说明: 此文件会在所有插件加载后自动执行，用于配置 lightline 状态栏
" 依赖: itchyny/lightline.vim, itchyny/vim-gitbranch, neoclide/coc.nvim, mhinz/vim-signify, ryanoasis/vim-devicons
" 图标: Powerline ( Branch \ue0a0, Lock \ue0a2 ) + Nerd Font ( Code \uf121, Cog \uf013, Plus \uf067 )，需 Nerd Font 字体
" ============================================================================

" ============================================================================
" 组件函数定义（须在 g:lightline 之前）
" ============================================================================

" 特殊窗口模式名：NERDTree、Vista、Startify、FZF 显示插件名，否则显示 NORMAL/INSERT 等
function! LightlineMode() abort
    if &filetype ==# 'nerdtree'
        return 'NERDTree'
    endif
    if &filetype ==# 'vista' || &filetype ==# 'vista_kind'
        return 'Vista'
    endif
    if &filetype ==# 'startify'
        return 'Startify'
    endif
    if &filetype ==# 'fzf'
        return 'FZF'
    endif
    return lightline#mode()
endfunction

" 只读标识：在 help、NERDTree、Vista、Startify 等只读窗口中不显示 RO，保持清爽
function! LightlineReadonly() abort
    return &readonly && &filetype !~# '\v(help|nerdtree|vista|startify)' ? "\ue0a2 RO" : ''
endfunction

" Git 分支：前加 图标（gitbranch#name 无封装，此处用 wrapper 注入图标）
function! LightlineGitbranch() abort
    if exists('*gitbranch#name') && len(gitbranch#name())
        return "\ue0a0 " . gitbranch#name()
    endif
    return ''
endfunction

" Git 增删改状态：复用 vim-signify 的 sy#repo#get_stats()，格式 +N ~N -N（新增、变更、删除）
function! LightlineGitStatus() abort
    if !exists('*sy#repo#get_stats')
        return ''
    endif
    let [l:added, l:modified, l:removed] = sy#repo#get_stats()
    if l:added < 0 || l:modified < 0 || l:removed < 0
        return ''
    endif
    let l:symbols = ['+', '~', '-']
    let l:stats = [l:added, l:modified, l:removed]
    let l:result = ''
    for i in range(3)
        let l:result .= l:symbols[i] . l:stats[i] . ' '
    endfor
    return substitute(l:result, ' $', '', '')
endfunction

" 光标下字符十六进制，固定 4 字符（0x + 2 位十六进制），保持位宽
function! CharValueHex() abort
    let l:line = getline('.')
    let l:col = col('.') - 1
    if l:col >= len(l:line) || l:col < 0
        return '0x--'
    endif
    return printf('0x%02X', char2nr(l:line[l:col]))
endfunction

" 文件名：特殊窗口不显示，普通文件显示文件名或 [No Name]（modified 由 layout 单独组件负责）
function! LightlineFilename() abort
    if &filetype =~# '\v(nerdtree|vista|startify|fzf)'
        return ''
    endif
    return expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction

" 文件格式（响应式隐藏）：字典查表，unix= Linux / dos= Windows / mac= Apple，零依赖
function! LightlineFileformat() abort
    if &filetype =~# '\v(nerdtree|vista|startify|fzf)' | return '' | endif
    if winwidth(0) < 70 | return '' | endif
    let l:icons = { 'unix': "\uf17c", 'dos': "\uf17a", 'mac': "\uf179" }
    let l:icon = get(l:icons, &fileformat, '')
    return (l:icon !=# '' ? l:icon . ' ' : '') . &fileformat
endfunction

" 文件类型（响应式隐藏）：用 vim-devicons 的 WebDevIconsGetFileTypeSymbol 按扩展名显示图标
function! LightlineFiletype() abort
    if &filetype =~# '\v(nerdtree|vista|startify|fzf)'
        return ''
    endif
    if winwidth(0) < 70
        return ''
    endif
    let l:icon = ''
    if exists('*WebDevIconsGetFileTypeSymbol')
        let l:icon = WebDevIconsGetFileTypeSymbol() . ' '
    endif
    return l:icon . (&filetype !=# '' ? &filetype : 'no ft')
endfunction

" 修改标识：未保存时显示  （Nerd Font plus）
function! LightlineModified() abort
    return &modified ? "\uf067" : ''
endfunction

" 启动时间：复用 autoload/startup_time.vim，10 秒后隐藏（不主动刷新）
function! LightlineStartup() abort
    if get(g:, 'startup_time_hide', 0) | return '' | endif
    return exists('*startup_time#get_airline_string') ? startup_time#get_airline_string() : ''
endfunction

" Coc 诊断：当前 buffer 的 error / warning 数量，格式 E2 W1，无则空
function! LightlineCocDiagnostic() abort
    if &filetype =~# '\v(nerdtree|vista|startify|fzf)'
        return ''
    endif
    let l:info = get(b:, 'coc_diagnostic_info', {})
    if empty(l:info)
        return ''
    endif
    let l:msgs = []
    if get(l:info, 'error', 0)
        call add(l:msgs, 'E' . l:info['error'])
    endif
    if get(l:info, 'warning', 0)
        call add(l:msgs, 'W' . l:info['warning'])
    endif
    return join(l:msgs, ' ')
endfunction

" ============================================================================
" 主配置
" ============================================================================

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'gitstatus', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'coc_error' ], [ 'startup' ], [ 'lineinfo' ], [ 'percent' ], [ 'charvaluehex' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component': {
      \   'lineinfo': '%3l:%-2v%<'
      \ },
      \ 'component_expand': {
      \   'coc_error': 'LightlineCocDiagnostic'
      \ },
      \ 'component_type': {
      \   'coc_error': 'error'
      \ },
      \ 'component_function': {
      \   'mode': 'LightlineMode',
      \   'gitbranch': 'LightlineGitbranch',
      \   'gitstatus': 'LightlineGitStatus',
      \   'readonly': 'LightlineReadonly',
      \   'filename': 'LightlineFilename',
      \   'modified': 'LightlineModified',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'charvaluehex': 'CharValueHex',
      \   'startup': 'LightlineStartup'
      \ },
      \ }

" 启动时间：10 秒后隐藏（随下次状态栏重绘生效，不主动 lightline#update）
if has('timers')
    call timer_start(10000, {-> execute("let g:startup_time_hide = 1")}, {'repeat': 1})
endif

" vim-signify / coc 更新时刷新状态栏
autocmd User Signify,CocStatusChange,CocDiagnosticChange call lightline#update()

" Coc 诊断块（type=error）红底：覆盖 wombat 的 error 样式为红底白字
function! s:LightlineCocRedHighlight() abort
  for m in ['normal', 'insert', 'visual', 'replace', 'inactive']
    execute 'hi! LightlineRight_' . m . '_error ctermbg=196 ctermfg=231 guibg=#cc3333 guifg=#ffffff'
  endfor
endfunction
augroup lightline_coc_red
  autocmd!
  autocmd ColorScheme * call s:LightlineCocRedHighlight()
  autocmd VimEnter * call timer_start(100, {-> s:LightlineCocRedHighlight()})
augroup END
