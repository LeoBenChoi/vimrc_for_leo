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
" vue
function! SmartVueCommentary() range
    if &filetype != 'vue'
        " 非 Vue 文件使用默认注释
        if mode() == 'n'
            execute "normal! \<Plug>CommentaryLine"
        else
            execute "normal! gv\<Plug>Commentary"
        endif
        return
    endif
    " 保存原始 commentstring 以便恢复
    let l:original_cms = &commentstring
    " 获取当前行和光标位置
    let l:line = line('.')
    let l:col = col('.')
    " 更精确的语法组检测
    let synGroup = map(synstack(l:line, l:col), 'synIDattr(v:val, "name")')
    " 调试信息：显示检测到的语法组
    echom "Detected syntax groups: " . string(synGroup)
    " 检测当前区域类型
    if index(synGroup, 'vueTemplate') >= 0 ||
                \ index(synGroup, 'htmlTagName') >= 0 ||
                \ index(synGroup, 'xmlTagName') >= 0
        setlocal commentstring=<!--\ %s\ -->
        echom "Setting HTML comment"
    " 处理 CSS 区域 - 优先检测
    elseif index(synGroup, 'vueStyle') >= 0 ||
                \ index(synGroup, 'cssStyle') >= 0 ||
                \ index(synGroup, 'cssDefinition') >= 0 ||
                \ index(synGroup, 'css') >= 0 ||
                \ search('<style\>', 'bnW') > 0
        setlocal commentstring=/*\ %s\ */
        echom "Setting CSS comment"
    " 处理 script 区域
    elseif index(synGroup, 'vueScript') >= 0 ||
                \ index(synGroup, 'typescript') >= 0 ||
                \ index(synGroup, 'ts') >= 0 ||
                \ index(synGroup, 'javaScript') >= 0 ||
                \ search('<script\>', 'bnW') > 0
        setlocal commentstring=//\ %s
        echom "Setting JS/TS comment"
    else
        " 回退到原始 commentstring
        setlocal commentstring=<!--\ %s\ -->
        echom "Falling back to HTML comment"
    endif
    " 调试信息：显示最终使用的 commentstring
    " echom "Using commentstring: " . &commentstring
    " 执行原始 Commentary 操作
    if mode() == 'n'
        execute "normal! \<Plug>CommentaryLine"
    else
        execute "normal! gv\<Plug>Commentary"
    endif
    " 恢复原始 commentstring
    let &commentstring = l:original_cms
endfunction
autocmd FileType vue nnoremap <buffer> <C-/> :call SmartVueCommentary()<CR>
autocmd FileType vue xnoremap <buffer> <C-/> :call SmartVueCommentary()<CR>
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
