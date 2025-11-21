"==============================================================
" config/ui/outline.vim
" Vista 代码大纲配置：使用 coc 后端
"==============================================================

if exists('g:loaded_outline_config')
  finish
endif
let g:loaded_outline_config = 1

"==============================================================
" Vista 基础配置
"==============================================================
" 默认使用 coc 作为后端
let g:vista_default_executive = 'coc'

" 设置 vista.vim 在使用 coc 作为执行器时等待的毫秒数
" 建议值：100-300 毫秒，您可以根据实际情况调整
let g:vista_coc_executive_delay = 200
