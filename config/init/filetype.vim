" ============================================================================
" 文件类型配置
" ============================================================================

" 检测文件类型
autocmd BufNewFile,BufRead *.json set filetype=json
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.go set filetype=go
autocmd BufNewFile,BufRead *.py set filetype=python
autocmd BufNewFile,BufRead *.js set filetype=javascript
autocmd BufNewFile,BufRead *.ts set filetype=typescript
autocmd BufNewFile,BufRead *.vue set filetype=vue
autocmd BufNewFile,BufRead *.html set filetype=html
autocmd BufNewFile,BufRead *.css set filetype=css
autocmd BufNewFile,BufRead *.scss set filetype=scss
autocmd BufNewFile,BufRead *.yml,*.yaml set filetype=yaml
autocmd BufNewFile,BufRead *.toml set filetype=toml
autocmd BufNewFile,BufRead *.rs set filetype=rust
autocmd BufNewFile,BufRead *.cpp,*.cc,*.cxx,*.hpp set filetype=cpp
autocmd BufNewFile,BufRead *.c,*.h set filetype=c

" 特定文件类型的设置
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType json setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType css setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
autocmd FileType make setlocal tabstop=4 shiftwidth=4 noexpandtab

" 自动去除行尾空格
autocmd BufWritePre * %s/\s\+$//e

" 自动添加文件头注释（可选）
function! InsertFileHeader()
    let comment_char = '#'
    if &filetype == 'vim'
        let comment_char = '"'
    elseif &filetype == 'c' || &filetype == 'cpp'
        let comment_char = '//'
    elseif &filetype == 'javascript' || &filetype == 'typescript'
        let comment_char = '//'
    endif
    call append(0, comment_char . ' ' . expand('%:t'))
    call append(1, comment_char . ' Created: ' . strftime('%Y-%m-%d %H:%M:%S'))
endfunction
