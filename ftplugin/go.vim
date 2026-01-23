" =======================================================
" Go 语言专用快捷键 (vim-go 🛠️ 工具箱功能)
" =======================================================
" 注意：智能补全、跳转、诊断等功能由 coc-go 🧠 负责
" 使用 gd 跳转定义、K 查看文档、自动补全等功能

" --- [vim-go] 运行与测试 ---
" 运行当前文件
nmap <buffer> <leader>gr :GoRun<CR>

" 编译当前文件
nmap <buffer> <leader>gb :GoBuild<CR>

" 测试
nmap <buffer> <leader>gt :GoTestFunc<CR>  " 测试当前函数
nmap <buffer> <leader>gT :GoTest<CR>      " 测试当前文件

" --- [vim-go] 代码生成工具 ---
" 自动生成 JSON tags (结构体标签)
nmap <buffer> <leader>at :GoAddTags<CR>    " 添加 tags
nmap <buffer> <leader>rt :GoRemoveTags<CR> " 移除 tags

" --- [coc-go] LSP 功能快捷键 (默认) ---
" gd          - 跳转到定义 (coc-go)
" K           - 查看文档悬浮 (coc-go)
" <C-Space>   - 触发补全 (coc-go)
" [g / ]g     - 跳转到上一个/下一个诊断错误 (coc-go)
" 更多快捷键请查看 :h coc-key-mappings  