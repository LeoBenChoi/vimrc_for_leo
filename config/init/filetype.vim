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

augroup END

" }}}1
