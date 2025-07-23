" ========================
" vim-commentary
" 功能：快速注释
" ========================

" 确保只加载一次
if exists('g:config_load_commentary')
    finish
endif
let g:config_load_commentary = 1

" ========================
" 配置自定义注释
" ========================

" 快捷键定义
nnoremap <C-/> <Plug>CommentaryLine
xnoremap <C-/> <Plug>Commentary

" .editorconfig 文件使用 # 注释
autocmd BufNewFile,BufRead *.editorconfig setlocal commentstring=#\ %s

" a
" b
" c
" d
" e
" f
" g
" h
" i
" j
" k
" l
" m
" n
" o
" p
" q
" r
" s
" t
" u
" v
" vue === ========= ========= ========= ========= ========= ========= =========
" function! SmartVueCommentary() range
"     " 保存原始 commentstring
"     let l:original_cms = &commentstring

"     " 获取选区范围
"     let l:start_line = a:firstline
"     let l:end_line = a:lastline

"     " 调试信息
"     " echom "Commenting lines: " . l:start_line . " to " . l:end_line

"     " 检查是否在 Vue 文件中
"     if &filetype == 'vue'
"         " 1. 检测选区是否跨区域
"         let l:current_region = ''
"         let l:regions = []

"         " 分析选区中的每一行
"         for l:line in range(l:start_line, l:end_line)
"             " 获取该行语法组
"             let l:col = max([col([l:line, 1]), 1])
"             let synGroup = map(synstack(l:line, l:col), 'synIDattr(v:val, "name")')

"             " 确定行类型
"             let l:type = 'html'
"             if index(synGroup, 'vueStyle') >= 0 || index(synGroup, 'css') >= 0
"                 let l:type = 'css'
"             elseif index(synGroup, 'vueScript') >= 0 || index(synGroup, 'javascript') >= 0 || index(synGroup, 'typescript') >= 0
"                 let l:type = 'js'
"             endif

"             " 添加到区域列表
"             if empty(l:regions) || l:regions[-1].type != l:type
"                 call add(l:regions, {'type': l:type, 'start': l:line, 'end': l:line})
"             else
"                 let l:regions[-1].end = l:line
"             endif
"         endfor

"         " 调试信息
"         " echom "Detected regions: " . string(l:regions)

"         " 2. 执行注释
"         if len(l:regions) == 1
"             " 单区域 - 使用对应注释风格
"             let l:region = l:regions[0]
"             call SetCommentString(l:region.type)
"             execute l:region.start . ',' . l:region.end . 'normal gcc'
"         else
"             " 多区域 - 分段注释
"             for l:region in l:regions
"                 call SetCommentString(l:region.type)
"                 execute l:region.start . ',' . l:region.end . 'normal gcc'
"             endfor
"         endif
"     else
"         " 非 Vue 文件 - 使用默认注释
"         if mode() == 'n'
"             execute "normal! gcc"
"         else
"             execute "normal! gc"
"         endif
"     endif

"     " 恢复原始 commentstring
"     let &commentstring = l:original_cms
" endfunction

" " 设置对应注释字符串的辅助函数
" function! SetCommentString(type)
"     if a:type == 'css'
"         setlocal commentstring=/*\ %s\ */
"     elseif a:type == 'js'
"         setlocal commentstring=//\ %s
"     else
"         setlocal commentstring=<!--\ %s\ -->
"     endif
" endfunction

" " 确保映射支持多行
" autocmd FileType vue nnoremap <buffer> <C-/> :call SmartVueCommentary()<CR>
" autocmd FileType vue xnoremap <buffer> <C-/> :call SmartVueCommentary()<CR>

" ======== ========= ========= ========= ========= ========= ========= =========
" w
" x
" y
" z

" ======== ========== ========== ========== ========== ========== ==========
" 调试函数
" ======== ========== ========== ========== ========== ========== ==========

" 查看当前高亮组
function! PrintSyntaxGroup()
    let l:line = line('.')
    let l:col = col('.')
    echo 'Syntax groups at cursor:'
    echo map(synstack(l:line, l:col), 'synIDattr(v:val, "name")')
    echo 'Current commentstring: ' . &commentstring
endfunction
" 映射调试命令
nnoremap <leader>db :call PrintSyntaxGroup()<CR>
