" ============================================================================
" UI 配置 - 主题、字体和界面设置
" 文件位置: ~/.vim/plugin/ui.vim
" 说明: 此文件会在 Vim 启动时自动加载
" ============================================================================

" ============================================================================
" 颜色方案配置
" ============================================================================

" 启用语法高亮
syntax enable

" 设置背景色（dark/light）
" 注意：某些颜色方案会自动设置，这里作为默认值
set background=dark

" ============================================================================
" 颜色方案列表 - 根据运行模式选择
" ============================================================================

" GUI 模式（gvim）使用的颜色方案列表（按优先级顺序）
let s:gui_colorschemes = [
    \ 'retrobox',
    \ 'desert',
    \ 'solarized',
    \ 'molokai',
    \ 'gruvbox',
    \ 'onedark',
    \ 'dracula',
    \ 'tokyonight',
    \ 'default'
    \ ]

" 终端模式使用的颜色方案列表（按优先级顺序）
" 推荐使用适合 256 色终端的颜色方案
let s:term_colorschemes = [
    \ 'seoul256',
    \ 'retrobox',
    \ 'desert',
    \ 'default'
    \ ]

" 根据运行模式选择颜色方案列表
if has('gui_running')
    let s:colorschemes = s:gui_colorschemes
else
    let s:colorschemes = s:term_colorschemes
endif

" 尝试加载颜色方案（按优先级顺序）
" 如果系统中有这些颜色方案，会按顺序尝试加载第一个可用的
for s:cs in s:colorschemes
    try
        execute 'colorscheme ' . s:cs
        break
    catch /^Vim\%((\a\+)\)\=:E185/
        " 颜色方案不存在，继续尝试下一个
        continue
    endtry
endfor

" 如果所有颜色方案都不可用，使用默认方案
if !exists('g:colors_name')
    colorscheme default
endif

" ============================================================================
" 主题相关显示设置
" ============================================================================

" 启用真彩色支持（终端模式，如果支持）
if has('termguicolors')
    set termguicolors
endif

" 高亮当前行
"set cursorline

" 高亮当前列（可选，取消注释启用）
"set cursorcolumn

" 高亮匹配的括号
set showmatch
set matchtime=1

" 行号颜色设置（通过高亮组）
highlight LineNr ctermfg=gray guifg=gray
highlight CursorLineNr ctermfg=yellow guifg=yellow

" ============================================================================
" GUI 字体配置（仅 GUI 模式生效）
" ============================================================================

if has('gui_running')
    " Windows 字体配置
    if has('win32') || has('win64')
        " 使用 Maple Mono NL NF Mono CN 字体
        set guifont=Maple_Mono_NL_NFMono_CN:h12
        " 备选方案（取消注释使用）：
        " set guifont=Consolas:h12
        " set guifont=Cascadia_Code:h11
        " set guifont=Fira_Code:h11
        " set guifont=JetBrains_Mono:h11
        
    " Linux 字体配置
    elseif has('unix')
        " 使用 Maple Mono NL NF Mono CN 字体
        set guifont=Maple_Mono_NL_NFMono_CN\ 12
        " 备选方案（取消注释使用）：
        " set guifont=DejaVu\ Sans\ Mono\ 12
        " set guifont=Fira\ Code\ 11
        " set guifont=Source\ Code\ Pro\ 12
        
    " macOS 字体配置
    elseif has('mac') || has('macunix')
        " 使用 Maple Mono NL NF Mono CN 字体
        set guifont=Maple_Mono_NL_NFMono_CN:h14
        " 备选方案（取消注释使用）：
        " set guifont=Menlo:h14
        " set guifont=Monaco:h13
        " set guifont=SF\ Mono:h13
    endif
    
    " GUI 界面优化
    " 禁用工具栏
    set guioptions-=T
    
    " 禁用菜单栏（可选，取消注释启用）
    " set guioptions-=m
    
    " 禁用滚动条
    set guioptions-=r
    set guioptions-=R
    set guioptions-=b
    
    " 使用系统剪贴板
    set guioptions+=a
endif

" ============================================================================
" 自动换行与行宽限制配置
" ============================================================================

" 1. 设置标准行宽为 80（默认值）
" 注意：某些文件类型（如 Go）会在 ftplugin 中覆盖此设置
set textwidth=80

" 2. 设置参考线（ColorColumn）
" 在 textwidth+1 列显示竖线，提醒不要超过推荐的行长度
" +1 表示相对于 textwidth 的值加 1，会自动跟随 textwidth 的变化
set colorcolumn=+1

" 自定义参考线的颜色（深灰色，以免太刺眼）
highlight ColorColumn ctermbg=237 guibg=#2c2d27

" 3. 配置自动换行行为（FormatOptions）
" 智能混合模式：代码只提示，注释自动换行
" t - 自动换行文本（代码中很少生效，除非是在字符串里）
" c - 自动换行注释（写长注释时非常有用！）
" q - 允许用 gq 命令手动格式化注释
" n - 识别编号列表（比如 1. xxx 换行后自动缩进）
" j - 删除行时如果那是注释，自动去掉注释符
set formatoptions+=t
set formatoptions+=c
set formatoptions+=q
set formatoptions+=n
set formatoptions+=j
