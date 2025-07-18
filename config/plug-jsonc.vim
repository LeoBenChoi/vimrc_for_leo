" ========================
" fzf 配置
" 功能：搜索
" ========================

" 确保只加载一次
if exists('g:plug_load_jsonc')
    finish
endif
let g:plug_load_jsonc = 1

" ========================
" 配置
" ========================

" 自动将 必要 .json 文件识别为 jsonc（允许注释）
autocmd BufRead,BufNewFile *.json set filetype=jsonc

" 如果只想对特定文件启用（如 tsconfig.json）：
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc