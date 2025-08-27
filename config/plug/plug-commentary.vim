" ========================
" 配置自定义注释
" ========================

" 快捷键定义
" nnoremap <C-/> <Plug>CommentaryLine
" xnoremap <C-/> <Plug>Commentary

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
    " echo 'Syntax groups at cursor:'
    echo map(synstack(l:line, l:col), 'synIDattr(v:val, "name")')
    " echo 'Current commentstring: ' . &commentstring
endfunction
" 映射调试命令
nnoremap <leader>db :call PrintSyntaxGroup()<CR>

