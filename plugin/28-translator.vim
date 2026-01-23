" =======================================================
" [vim-translator] 翻译插件配置
" =======================================================

" 1. 语言设置
" 目标语言（翻译结果的语言）
let g:translator_target_lang = 'zh'
" 源语言（自动检测）
let g:translator_source_lang = 'auto'

" 2. 翻译引擎（按优先级顺序）
" 可用引擎: 'bing', 'google', 'haici', 'youdao', 'sdcv', 'trans'
" 默认: 如果目标语言是 'zh'，则为 ['bing', 'google', 'haici', 'youdao']
let g:translator_default_engines = ['bing', 'google', 'haici', 'youdao']

" 3. 代理设置（如果需要）
"let g:translator_proxy_url = 'http://127.0.0.1:7897'
" 代理格式示例:
" let g:translator_proxy_url = 'socks5://127.0.0.1:1080'
" let g:translator_proxy_url = 'http://127.0.0.1:7897'

" 4. 窗口显示配置
" 窗口类型: 'popup' (悬浮窗) 或 'preview' (预览窗口)
let g:translator_window_type = 'popup'
" 窗口最大宽度（0.6 表示屏幕宽度的 60%）
let g:translator_window_max_width = 0.6
" 窗口最大高度（0.6 表示屏幕高度的 60%）
let g:translator_window_max_height = 0.6
" 窗口边框字符（上、右、下、左、左上、右上、右下、左下）
let g:translator_window_borderchars = ['─', '│', '─', '│', '┌', '┐', '┘', '└']

" 5. 历史记录（可选）
" let g:translator_history_enable = v:true

" 快捷键映射
" <Leader>t : 在悬浮窗翻译光标下的单词/选中文本 (Translate - 最常用)
nmap <silent> <Leader>t <Plug>TranslateW
vmap <silent> <Leader>t <Plug>TranslateWV

" <Leader>r : 替换光标下的单词/选中文本为翻译结果 (Replace - 写变量名神器)
nmap <silent> <Leader>r <Plug>TranslateR
vmap <silent> <Leader>r <Plug>TranslateRV

" <Leader>x : 翻译剪贴板中的文本 (Export - 英语学习党必备)
nmap <silent> <Leader>x <Plug>TranslateX

" 提示: 翻译窗口打开后，使用 <C-w>p 可以在翻译窗口和原窗口之间跳转
