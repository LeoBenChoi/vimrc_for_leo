"==============================================================
" config/init/filetype.vim
" 文件类型检测与适配：自动识别不同文件类型并设置相应的配置
"==============================================================

if exists('g:loaded_filetype_config')
  finish
endif
let g:loaded_filetype_config = 1

"==============================================================
" 文件类型检测与适配
"==============================================================

augroup FileTypeDetection
  autocmd!

  "==============================================================
  " JavaScript 文件类型检测 {{{1
  "==============================================================
  " .js 文件：根据内容判断是 JavaScript 还是 JavaScript React
  " 如果包含 React/JSX 代码，自动识别为 javascriptreact
  " 如果包含 Node.js shebang，识别为 javascript
  autocmd BufNewFile,BufRead *.js
        \ if getline(1) =~# '^#!.*node' || getline(1) =~# '^#!.*nodejs' |
        \   setfiletype javascript |
        \ elseif getline(1) =~# 'jsx' || search('React\|JSX', 'nw') > 0 |
        \   setfiletype javascriptreact |
        \ else |
        \   setfiletype javascript |
        \ endif

  " .jsx 文件：JavaScript React
  autocmd BufNewFile,BufRead *.jsx setfiletype javascriptreact

  " .mjs 文件：ES6 模块 JavaScript
  autocmd BufNewFile,BufRead *.mjs setfiletype javascript

  " .cjs 文件：CommonJS JavaScript
  autocmd BufNewFile,BufRead *.cjs setfiletype javascript

  "==============================================================
  " TypeScript 文件类型检测 {{{1
  "==============================================================
  autocmd BufNewFile,BufRead *.ts setfiletype typescript
  autocmd BufNewFile,BufRead *.tsx setfiletype typescriptreact

  "==============================================================
  " JSON 文件类型检测 {{{1
  "==============================================================
  " .jsonc 文件：JSON with Comments（支持注释的 JSON）
  autocmd BufNewFile,BufRead *.jsonc setfiletype jsonc

  " .json 文件：如果第一行是注释，则识别为 jsonc
  autocmd BufNewFile,BufRead *.json
        \ if getline(1) =~# '^\s*//' |
        \   setfiletype jsonc |
        \ else |
        \   setfiletype json |
        \ endif

  "==============================================================
  " 十六进制文件类型检测 {{{1
  "==============================================================
  " .vimhex 文件：xxd 格式的十六进制文件（Vim 专用）
  " 自动识别为 xxd 文件类型，并在 xxd.vim 中自动转换
  " 注意：使用 .vimhex 后缀避免与其他十六进制工具（如 Intel HEX）混淆
  autocmd BufNewFile,BufRead *.vimhex setfiletype xxd

  "==============================================================
  " Go 语言文件类型配置 {{{1
  "==============================================================
  " 设置 Go 语言文件的行长度限制为 120 字符
  " 使用 BufEnter 确保在进入 buffer 时也设置（覆盖可能的文件类型插件设置）
  autocmd FileType go setlocal textwidth=120
  autocmd BufEnter *.go setlocal textwidth=120
  " 显示第 120 列的视觉标记（颜色列）
  autocmd FileType go setlocal colorcolumn=120
  autocmd BufEnter *.go setlocal colorcolumn=120
  " 启用视觉换行（wrap）：当页面宽度不够时，长行会视觉换行显示
  autocmd FileType go setlocal wrap
  autocmd FileType go setlocal linebreak
  " formatoptions: 格式化选项
  "   注意：使用 = 而不是 += 来确保设置正确的值，完全覆盖基础配置
  "   t: 使用 textwidth 自动换行（对所有文本都有效，包括代码行和注释）
  "   c: 在注释中自动换行（注释专用）
  "   移除 q 选项，避免 gq 格式化时乱码
  "   移除其他可能干扰的选项（如 a, w 等）
  "   重要：t 选项对所有文本都有效，但只在输入空格或标点符号后才会触发自动换行
  "   如果输入连续字符（无空格），不会自动换行
  "   注意：确保没有其他选项（如 a, w）干扰自动换行
  "   使用 BufEnter 确保在进入 buffer 时也设置（覆盖可能的文件类型插件设置）
  autocmd FileType go setlocal formatoptions=tc
  autocmd BufEnter *.go setlocal formatoptions=tc textwidth=120
  " 确保没有禁用自动换行的选项
  autocmd FileType go setlocal formatprg=
  " 调试：显示当前配置（打开 Go 文件时会显示）
  autocmd FileType go echo 'Go 文件配置: textwidth=' . &textwidth . ' formatoptions=' . &formatoptions . ' wrap=' . &wrap
  " 在 BufEnter 时也显示配置（用于调试）
  autocmd BufEnter *.go echo 'Go 文件配置（BufEnter）: textwidth=' . &textwidth . ' formatoptions=' . &formatoptions

augroup END

" }}}1
