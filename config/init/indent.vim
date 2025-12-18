"==============================================================
" config/init/indent.vim
" 文件类型特定缩进配置：不同文件类型使用不同的缩进格式
"==============================================================

if exists('g:loaded_indent_config')
  finish
endif
let g:loaded_indent_config = 1

augroup FileTypeIndent
  autocmd!
  "==============================================================
  " 2 空格缩进（Web 开发常用）
  "==============================================================
  " Vue.js：Vue 项目标准使用 2 个空格
  " 确保 Vue 文件中的所有部分（template、script、style）都使用 2 空格
  " softtabstop=2 确保按 Tab/Backspace 时使用 2 空格
  " autoindent 和 smartindent 确保换行时自动缩进
  autocmd FileType vue setlocal tabstop=2 shiftwidth=2 softtabstop=2
        \ | setlocal autoindent smartindent

  " JavaScript/TypeScript：大多数前端项目使用 2 个空格
  " 包括 Vue 项目中的独立 .js/.ts 文件
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact
        \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
        \ | setlocal autoindent smartindent

  " JSON：JSON 文件通常使用 2 个空格
  autocmd FileType json setlocal tabstop=2 shiftwidth=2

  " YAML：YAML 文件通常使用 2 个空格
  autocmd FileType yaml,yml setlocal tabstop=2 shiftwidth=2

  " CSS/SCSS/LESS：样式文件通常使用 2 个空格
  autocmd FileType css,scss,less,sass setlocal tabstop=2 shiftwidth=2

  " HTML：HTML 文件通常使用 2 个空格
  autocmd FileType html,htm setlocal tabstop=2 shiftwidth=2

  " Markdown：Markdown 文件通常使用 2 个空格
  autocmd FileType markdown setlocal tabstop=2 shiftwidth=2

  "==============================================================
  " 其他缩进配置（按需添加）
  "==============================================================
  " Python：4 空格缩进（PEP 8 标准）
  autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

  " Go：使用 Tab，4 宽度（Go 官方标准）
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

  " Makefile：必须使用 Tab
  autocmd FileType make setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END