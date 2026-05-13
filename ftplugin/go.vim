" 保存自动格式化，并导入包
" autocmd BufWritePre <buffer> call CocAction('format')
autocmd BufWritePre *.go silent! %!goimports
