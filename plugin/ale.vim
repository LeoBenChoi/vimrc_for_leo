let g:ale_disable_lsp = 1 " 禁用ale的lsp功能
let g:ale_lint_on_text_changed = 'never' " 不要边输入边检查
let g:ale_lint_on_insert_leave = 0 " 输入时不检查
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠️'
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = "🔧 "
let g:ale_floating_preview = 1
let g:ale_floating_window_border = []
let g:ale_linters = #{
			\	python: [], 
			\	rust: []
			\	}
nmap <LocalLeader>i <Cmd>ALEDetail<CR>
