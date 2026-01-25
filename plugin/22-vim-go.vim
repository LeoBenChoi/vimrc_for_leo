" =======================================================
" [vim-go] Go 语言开发工具配置
" =======================================================
"
" 插件分工说明：
" ┌─────────────┬─────────────────────────────────────────────────────────┐
" │ 插件        │ 角色          │ 负责的具体工作                           │
" ├─────────────┼───────────────┼─────────────────────────────────────────┤
" │ coc-go      │ 🧠 大脑        │ 智能补全 (IntelliSense)                  │
" │             │               │ 实时诊断 (写错代码画红线)                │
" │             │               │ 定义跳转 (gd)                            │
" │             │               │ 文档悬浮 (K)                              │
" │             │               │ ✅ 开启                                  │
" ├─────────────┼───────────────┼─────────────────────────────────────────┤
" │ vim-go      │ 🛠️ 工具箱      │ 运行/测试 (:GoRun, :GoTest)              │
" │             │               │ 二进制管理 (安装 gopls)                  │
" │             │               │ 语法高亮 (Struct 颜色)                   │
" │             │               │ 代码生成 (JSON Tags)                      │
" │             │               │ ✅ 开启 (但 LSP 功能已在配置中禁用)      │
" └─────────────┴───────────────┴─────────────────────────────────────────┘
"
" 注意：coc-go 会自动使用 vim-go 安装的 gopls 二进制文件
" 如果 gopls 未安装，运行 :GoUpdateBinaries 即可

" --- 1. 核心行为 ---
" 注意：格式化功能已交给 coc-go/gopls 处理，禁用 vim-go 的自动格式化
" coc-go 使用 gopls 进行格式化，功能更强大（支持 organizeImports）
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 0  " 禁用 vim-go 的自动格式化，由 coc.nvim 处理

" --- 2. 防止冲突 (让位给 coc-go) ---
" 关掉 vim-go 的 LSP 功能，全部交给 coc-go 处理
" 这样分工明确：vim-go 负责工具，coc-go 负责智能
let g:go_def_mapping_enabled = 0       " 不让 vim-go 接管 gd (交给 coc-go)
let g:go_code_completion_enabled = 0   " 不让 vim-go 接管补全 (交给 coc-go)
let g:go_doc_keywordprg_enabled = 0    " 不让 vim-go 接管 K (交给 coc-go)

" --- 3. 语法高亮 (颜值增强) ---
" 让结构体、函数调用、操作符显示不同颜色
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" --- 4. 其它设置 ---
" 不显示烦人的 'fmt success' 提示信息
let g:go_echo_command_info = 0
