" 语义化 Todo 备用：进入 Go 窗口后重设（与 after/syntax/go.vim 逻辑一致）
function! s:apply_go_todo_highlight() abort
	syn clear goTodo
	syn match goTodo  contained "\v<(TODO)(\([^)]+\))?:?" containedin=goComment
	syn match goFixme contained "\v<(FIXME|BUG|XXX)(\([^)]+\))?:?" containedin=goComment
	syn match goNote  contained "\v<(NOTE|INFO)(\([^)]+\))?:?" containedin=goComment
	syn match goUser  contained "\v(\([^)]+\))\ze:" containedin=goTodo,goFixme,goNote
	syn match goColon contained "\v:\ze(\s|$)" containedin=goTodo,goFixme,goNote
	hi! goTodo   cterm=bold gui=bold ctermbg=214 ctermfg=0    guibg=#fabd2f guifg=#282828
	hi! goFixme  cterm=bold gui=bold ctermbg=167 ctermfg=255  guibg=#fb4934 guifg=#ffffff
	hi! goNote   cterm=bold gui=bold ctermbg=109 ctermfg=255  guibg=#83a598 guifg=#ffffff
	hi! goUser   cterm=italic gui=italic ctermfg=109 guifg=#83a598
	hi! goColon  cterm=bold gui=bold ctermfg=245 guifg=#928374
endfunction
augroup GoPureTodo
	au!
	autocmd BufWinEnter * if &ft ==# 'go' | call s:apply_go_todo_highlight() | endif
augroup END
if &ft ==# 'go'
	call s:apply_go_todo_highlight()
endif

" Go 语义化 Todo 高亮：清除原生 goTodo 再自建，避免 FIXME/NOTE 被当成 goTodo
" 在 runtime syntax/go.vim 之后加载

" 1. 清除 goTodo 组内所有语法项（含 runtime 的 keyword TODO/FIXME/XXX/BUG/NOTE）
syn clear goTodo
" 2. 高优先级正则（仅注释内），含可选 (name) 与 :
syn match goTodo  contained "\v<(TODO)(\([^)]+\))?:?" containedin=goComment
syn match goFixme contained "\v<(FIXME|BUG|XXX)(\([^)]+\))?:?" containedin=goComment
syn match goNote  contained "\v<(NOTE|INFO)(\([^)]+\))?:?" containedin=goComment
" 姓名标识：括号内容且后跟冒号
syn match goUser  contained "\v(\([^)]+\))\ze:" containedin=goTodo,goFixme,goNote
" 冒号：后接空白或行尾
syn match goColon contained "\v:\ze(\s|$)" containedin=goTodo,goFixme,goNote

" 3. 颜色组（cterm/gui 双兼容）
hi goTodo   cterm=bold gui=bold ctermbg=214 ctermfg=0    guibg=#fabd2f guifg=#282828
hi goFixme  cterm=bold gui=bold ctermbg=167 ctermfg=255  guibg=#fb4934 guifg=#ffffff
hi goNote   cterm=bold gui=bold ctermbg=109 ctermfg=255  guibg=#83a598 guifg=#ffffff
hi goUser   cterm=italic gui=italic ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE
hi goColon  cterm=bold gui=bold ctermfg=245 ctermbg=NONE guifg=#928374 guibg=NONE

syn sync fromstart
