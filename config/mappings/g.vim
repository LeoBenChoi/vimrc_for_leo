" ============================================================================
" 映射配置 - G (Go)
" ============================================================================

" Go 相关快捷键
" 运行 Go 代码
" 注意：gr 已被 coc-references 使用，改用 gR
nnoremap <leader>gR :!go run .<CR>  " 运行当前文件
nnoremap <leader>gb :!go build<CR>  " 构建当前项目
nnoremap <leader>gt :!go test<CR>   " 运行测试

" Go 工具
nnoremap <leader>gf :Format<CR>     " 格式化代码（使用 coc.nvim）
nnoremap <leader>go :OR<CR>         " 组织导入（使用 coc.nvim）
nnoremap <leader>gl :GolangciLintPersonal<CR>  " 运行 golangci-lint
nnoremap <leader>gv :Govulncheck<CR>  " 运行 govulncheck

" Go LSP 环境检查和安装
nnoremap <leader>gc :CheckGoLSP<CR>     " 检查 Go LSP 环境
nnoremap <leader>gi :InstallGoLSP<CR>    " 安装 Go LSP 环境
