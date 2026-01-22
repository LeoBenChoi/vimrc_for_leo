" ============================================================================
" 折叠配置
" 文件位置: ~/.vim/plugin/fold.vim
" 说明: 此文件会在 Vim 启动时自动加载，用于配置代码折叠功能
" ============================================================================

" 防止重复加载
if exists('g:loaded_fold_config')
    finish
endif
let g:loaded_fold_config = 1

" ============================================================================
" 1. 基础折叠设置
" ============================================================================

" 启用折叠功能
set foldenable

" 默认折叠方法：手动折叠（manual）
" 注意：已配置的文件类型会通过 autocmd 覆盖此设置
" manual - 性能最好，不会自动折叠，需要手动创建折叠（使用 zf）
" 如果未配置的文件类型需要自动折叠，可以改为 indent 或 syntax
set foldmethod=manual

" 默认折叠级别：99（几乎不折叠，保持代码可见）
" 可以通过 zc/zo 手动折叠/展开
set foldlevel=99

" 打开文件时的初始折叠级别（99 表示默认展开所有折叠）
" 可以根据需要调整：0=全部折叠，99=全部展开
set foldlevelstart=99

" 最大折叠嵌套深度（避免过度折叠）
set foldnestmax=10

" 保存和恢复折叠状态
" cursor - 保存光标位置
" folds - 保存折叠状态
" slash - 使用正斜杠作为路径分隔符（Unix 风格）
" unix - 使用 Unix 风格的换行符
set viewoptions=cursor,folds,slash,unix

" 自动保存/加载折叠状态
augroup AutoFold
    autocmd!
    " 关闭文件时保存折叠状态
    autocmd BufWinLeave *.* mkview
    " 打开文件时加载折叠状态
    autocmd BufWinEnter *.* silent! loadview
augroup END

" ============================================================================
" 2. 折叠快捷键
" ============================================================================

" Space 键切换折叠（在普通模式下）
" 注意：虽然 Space 是 Leader 键，但单独的 <space> 映射仍然可以工作
" 按 Space 后会短暂等待，如果没有后续键则执行折叠切换
" za - 切换当前折叠
nnoremap <space> za

" Space 键创建折叠（在可视模式下）
" zf - 创建折叠
vnoremap <space> zf

" 备用快捷键（如果不想等待 Space 的延迟）：
" 使用 Leader + z 组合键
" nnoremap <Leader>z za
" vnoremap <Leader>z zf

" 其他常用折叠快捷键（Vim 内置）：
" zc - 折叠当前代码块
" zo - 展开当前代码块
" zR - 展开所有折叠
" zM - 折叠所有代码块
" zj - 移动到下一个折叠
" zk - 移动到上一个折叠

" ============================================================================
" 3. 不同文件类型的折叠设置
" ============================================================================

augroup FileTypeFold
    autocmd!

    " ================================================================
    " 注意：Go 语言的折叠配置已移至 ftplugin/go.vim
    " ================================================================

    " ================================================================
    " Python 折叠配置
    " ================================================================
    " 使用缩进折叠（indent folding）
    " Python 使用缩进来表示代码块，非常适合缩进折叠
    autocmd FileType python setlocal foldmethod=indent
                \ | setlocal foldnestmax=5
                \ | setlocal foldlevelstart=99

    " ================================================================
    " JavaScript/TypeScript 折叠配置
    " ================================================================
    " 使用语法折叠
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact
                \ setlocal foldmethod=syntax
                \ | setlocal foldnestmax=5
                \ | setlocal foldlevelstart=99

    " ================================================================
    " Vue.js 折叠配置
    " ================================================================
    " 使用语法折叠
    autocmd FileType vue setlocal foldmethod=syntax
                \ | setlocal foldnestmax=5
                \ | setlocal foldlevelstart=99

    " ================================================================
    " CSS/SCSS/LESS 折叠配置
    " ================================================================
    " 使用标记折叠（marker folding）
    " 可以在代码中使用 {{{ 和 }}} 标记来定义折叠区域
    autocmd FileType css,scss,less,sass setlocal foldmethod=marker
                \ | setlocal foldmarker={{{,}}}
                \ | setlocal foldlevelstart=99

    " ================================================================
    " HTML 折叠配置
    " ================================================================
    " 使用语法折叠
    autocmd FileType html,htm,xhtml setlocal foldmethod=syntax
                \ | setlocal foldnestmax=5
                \ | setlocal foldlevelstart=99

    " ================================================================
    " JSON 折叠配置
    " ================================================================
    " 使用语法折叠
    autocmd FileType json,jsonc setlocal foldmethod=syntax
                \ | setlocal foldnestmax=5
                \ | setlocal foldlevelstart=99

    " ================================================================
    " Markdown 折叠配置
    " ================================================================
    " 使用语法折叠（支持标题折叠）
    autocmd FileType markdown setlocal foldmethod=syntax
                \ | setlocal foldnestmax=6
                \ | setlocal foldlevelstart=99

    " ================================================================
    " Vim 脚本折叠配置
    " ================================================================
    " 使用标记折叠
    autocmd FileType vim setlocal foldmethod=marker
                \ | setlocal foldmarker={{{,}}}
                \ | setlocal foldlevelstart=0
augroup END

" ============================================================================
" 5. 自定义折叠文本显示
" ============================================================================

" 自定义折叠文本显示函数
" 显示折叠的详细信息：起始行、结束行、行数、以及折叠内容的预览
" 根据窗口宽度自动调整，确保信息部分右对齐
function! CustomFoldText() abort
    " 获取折叠的起始和结束行号
    let l:start_line_num = v:foldstart
    let l:end_line_num = v:foldend

    " 计算折叠包含的行数
    let l:line_count = l:end_line_num - l:start_line_num + 1

    " 获取折叠起始行和结束行的内容
    let l:start_line_content = getline(l:start_line_num)
    let l:end_line_content = getline(l:end_line_num)

    " 处理行内容：将制表符替换为空格，并移除结束行的前导空白
    let l:processed_start = substitute(l:start_line_content, '\t', '    ', 'g')
    let l:processed_end = substitute(l:end_line_content, '\t', '    ', 'g')
    let l:processed_end_no_indent = substitute(l:processed_end, '^\s*', '', '')

    " 构建折叠内容的显示部分
    let l:folded_display_text = empty(l:processed_end_no_indent) 
                \ ? l:processed_start 
                \ : l:processed_start . ' ... ' . l:processed_end_no_indent

    " 构建信息部分的显示内容
    let l:info_display_text = printf('[%d-%d] %d lines', l:start_line_num, l:end_line_num, l:line_count)

    " 计算行号列宽度（如果显示行号）
    " numberwidth 默认为 4，但如果行号很大可能会更宽
    let l:number_width = &number ? max([&numberwidth, len(string(line('$'))) + 1]) : 0
    
    " 计算可用宽度：窗口宽度减去行号列宽度和折叠标记列
    let l:available_width = &columns - l:number_width - 1  " -1 为折叠标记列

    " 获取行宽（textwidth），如果为0则使用可用宽度
    let l:textwidth = &textwidth > 0 ? &textwidth : l:available_width

    " 确定对齐目标宽度：
    " - 如果窗口宽度低于行宽，则对齐到窗口边缘（可用宽度）
    " - 如果行宽足够（窗口宽度 >= 行宽），则对齐到行宽
    let l:align_width = min([l:available_width, l:textwidth])

    " 计算信息部分的宽度
    let l:info_width = strwidth(l:info_display_text)

    " 计算折叠文本部分的最大可用宽度
    " 预留一些空间给信息部分和分隔
    let l:min_info_space = l:info_width + 2  " 信息部分 + 最小间距
    let l:max_folded_width = l:align_width - l:min_info_space

    " 如果可用宽度太小，优先显示信息部分
    if l:max_folded_width < 10
        let l:folded_display_text = ''
        let l:max_folded_width = 0
    " 如果折叠文本太长，截断它
    elseif strwidth(l:folded_display_text) > l:max_folded_width
        let l:folded_display_text = strcharpart(l:folded_display_text, 0, l:max_folded_width - 3) . '...'
    endif

    " 计算填充空格的数量，确保信息部分右对齐到目标宽度
    let l:current_display_width = strwidth(l:folded_display_text) + strwidth(l:info_display_text)
    let l:spacing = max([l:align_width - l:current_display_width, 1])

    " 返回最终的折叠文本
    return l:folded_display_text . repeat(' ', l:spacing) . l:info_display_text
endfunction

" 设置自定义折叠文本
set foldtext=CustomFoldText()

" ============================================================================
" 6. 帮助信息
" ============================================================================
"
" 折叠快捷键：
"   zc / zo  : 关闭 / 打开当前折叠
"   zC / zO  : 递归关闭 / 打开（包含所有嵌套）
"   za / zA  : 切换当前折叠 / 递归切换
"   zm / zr  : 调整折叠级别（折叠更多 / 更少）
"   zM / zR  : 关闭全部折叠 / 展开全部折叠
"   [z / ]z  : 跳到上一个 / 下一个折叠起点
"   zj / zk  : 在折叠块间快速跳转
"   zf{motion}: 按 motion 创建折叠（如 zfap, zf%）
"   zd / zD  : 删除当前折叠 / 递归删除
"   zi       : 启用或禁用折叠功能
"   //       : 切换当前折叠（普通模式）/ 创建折叠（可视模式）
"
" 已配置的文件类型：
"   - Go: 语法折叠（自动折叠函数、结构体、接口等）
"   - Python: 缩进折叠
"   - JavaScript/TypeScript: 语法折叠
"   - Vue.js: 语法折叠
"   - CSS/SCSS/LESS: 标记折叠（使用 {{{ 和 }}}）
"   - HTML: 语法折叠
"   - JSON: 语法折叠
"   - Markdown: 语法折叠（支持标题折叠）
"   - Vim 脚本: 标记折叠（使用 {{{ 和 }}}）
"
" 折叠状态会自动保存和恢复（关闭文件时保存，打开文件时恢复）
