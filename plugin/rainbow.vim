" ============================================================================
" 彩虹括号（rainbow_parentheses.vim）设置
" ============================================================================

" 防止重复加载本文件
if exists("g:loaded_rainbow")
  finish
endif
let g:loaded_rainbow = 1

" 最大嵌套级别（默认16）
let g:rainbow#max_level = 16

" 要高亮的括号对：圆括号、方括号、花括号
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

" 黑名单：排除的颜色（ANSI 代码或 #RRGGBB 格式）
" 可以根据你的配色方案调整，避免括号颜色与背景色太接近
let g:rainbow#blacklist = [233, 234, 235]

" 自动为特定文件类型启用彩虹括号
augroup rainbow_parentheses
  autocmd!
  " 为 Lisp 系列语言自动启用
  autocmd FileType lisp,clojure,scheme RainbowParentheses
  " 为编程语言自动启用（可根据需要调整）
  autocmd FileType python,javascript,typescript,go,rust,c,cpp,java RainbowParentheses
augroup END

" 全局启用（可选，如果希望所有文件都启用，取消下面的注释）
" autocmd VimEnter * RainbowParentheses