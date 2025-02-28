"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
set nocompatible
set backspace=2
set encoding=utf-8
set textwidth=80
set wrapmargin=80
set linebreak
set showbreak=+++
set guifont=Consolas:h12:b:cANSI:qDRAFT
set fileformat=unix
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set lazyredraw
set ttyfast
set updatetime=300
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup
set nowritebackup
set noswapfile
set noundofile
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd! BufReadPost * if line("'\'") > 1 && line ("'\'") <= line("$") | exe "normal! g'\"" | endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set noexpandtab
set tabstop=4
set shiftwidth=4
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number
set relativenumber
set numberwidth=4
set showmatch
set cursorline
set cursorcolumn
set colorcolumn=80
set showmode
set showcmd
set ruler
set showfulltag
set showtabline=2
set laststatus=2
set cmdheight=2
set mouse=a
set ttymouse=sgr
set signcolumn=yes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on
filetype indent on
set autochdir
set foldmethod=marker
set foldlevelstart=99
set foldcolumn=3
set foldnestmax=10
autocmd BufRead,BufNewFile *.vimhex set filetype=xxd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if (has('win32') || has('win64')) == 1
	let g:LEOVIMRCPATH = $VIM 
	let flag_file = expand(LEOVIMRCPATH . '\vimfiles\init_complete_flag')
elseif has('unix') == 1
	let g:LEOVIMRCPATH = '/etc/vim/'
	let flag_file = expand(LEOVIMRCPATH . '/vimfiles/init_complete_flag')
	set runtimepath+=/etc/vim/vimfiles
	set packpath+=/etc/vim/vimfiles
	source /etc/vim/vimfiles/keymap/default.keymap.vim
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(flag_file) == 0
	echo "env not Ready"
	echo "Ready to install environment..."
	call system('sudo touch ' . flag_file)
	source /etc/vim/init.vim
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui_running') == 1
	colorscheme gruvbox
	set ambiwidth=double
		if (has('win32') || has('win64')) == 1
			autocmd GUIENter * simalt ~x
		endif
	let hour = strftime("%H")
	if hour >= 8 && hour < 18
		set background light
	else
		set background=dark
	endif
else
	let g:cyberpunk_cursorline="default"
	let hour = strftime("%H")
	if hour >= 8 && hour < 18
		colorscheme cyberpunk
		if (has('win32') || has('win64')) == 1
			call HighlightFor("CurosrColumn", "#140007", "#FF0055", "NONE")
		endif
	else
		set termguicolors
		colorscheme silverhand
		if (has('win32') || has('win64')) == 1
			call HighlightFor("CurosrColumn", "#0a0d04", "5e81f5", "NONE")
		endif
	endif
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 注册插件服务
" if executable('vim-language-server')
if executable('vim-language-server')
	augroup LspVim
		autocmd!
		autocmd User lsp_setup call lsp#register_server({
					\ 'name': 'vim-language-server',
					\ 'cmd': {server_info->['vim-language-server', '--stdio']},
					\ 'whitelist': ['vim'],
					\ 'initialization_options': {
					\   'vimruntime': $VIMRUNTIME,
					\   'runtimepath': &rtp,
					\ }})
	augroup END
endif
if executable('pylsp')
	" pip install python-lsp-server
	au User lsp_setup call lsp#register_server({
				\ 'name': 'pylsp',
				\ 'cmd': {server_info->['pylsp']},
				\ 'allowlist': ['python'],
				\ })
endif
if executable('gopls')
	" go get -u golang.org/x/tools/gopls@latest
	au User lsp_setup call lsp#register_server({
				\ 'name': 'gopls',
				\ 'cmd': {server_info->['gopls', '-remote=auto']},
				\ 'allowlist': ['go', 'gomod', 'gohtmltmpl', 'gotexttmpl'],
				\ })
	autocmd BufWritePre *.go
				\ call execute('LspDocumentFormatSync') |
				\ call execute('LspCodeActionSync source.organizeImports')
endif

function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> gs <plug>(lsp-document-symbol-search)
	nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
	nmap <buffer> gr <plug>(lsp-references)
	nmap <buffer> gi <plug>(lsp-implementation)
	nmap <buffer> gt <plug>(lsp-type-definition)
	nmap <buffer> <leader>rn <plug>(lsp-rename)
	nmap <buffer> [g <plug>(lsp-previous-diagnostic)
	nmap <buffer> ]g <plug>(lsp-next-diagnostic)
	nmap <buffer> K <plug>(lsp-hover)
	nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
	nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

	let g:lsp_format_sync_timeout = 1000
	autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

	" refer to doc to add more commands
endfunction

" 状态栏
let g:lightline = {
			\ 'colorscheme': 'wombat',
			\ 'active': {
			\   'left': [ [ 'mode', ], [ 'gitbranchstatus'], ['filename' ], [ 'readonly', 'modified'] ],
			\   'right': [ ['lineinfo'], [ 'percent' ], ['filetype', 'fileformat', 'fileencoding', 'charvaluehex' ] ]
			\ },
			\ 'component_function': {
			\   'gitbranchstatus': 'FugitiveStatusline',
			\ },
			\ 'component': {
			\   'charvaluehex': '0x%B'
			\ },
			\ }

" 侧边栏
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let g:snipMate = { 'snippet_version' : 1 }
