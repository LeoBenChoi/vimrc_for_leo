" ========================================================================
" Global Base set
" ========================================================================

" misc
set nocompatible " Disable compatibility with old vi
set number
set relativenumber
set backspace=2     
set numberwidth=4       " Column width
set fileformat=unix 
set encoding=utf-8
set fileencodings=utf-8,gb2312,gb18030,cp936,latin1
set shortmess+=I " default startup screen 
set list lcs=tab:\|\ 
set showmatch           " Highlight bracket
set cursorline "highlights the current line
set cursorcolumn "highlights the current column
set colorcolumn=80      " Set column 80 to be highlighted
set textwidth=80       " Automatically wrap lines at 80 characters
set formatoptions+=t   " Enable automatic text wrapping
set showfulltag
set signcolumn=yes " Enable the sign column to always show
set noshowmode
set wildoptions=pum "pum = popup menu
set pumheight=10 " 限制最大显示行数

" about line
set showtabline=2       
set laststatus=2        
set cmdheight=2   
set wildmenu            
set pumheight=20	
set wildmode=longest:full,full
"set wildoptions=pum 

" bak 
"set nobackup          
"set nowritebackup     
"set noswapfile        
"set noundofile      

" bak
" edit file
set backup
set backupdir=~/.vim/.backup//
if !isdirectory(expand('~/.vim/.backup'))
    call mkdir(expand('~/.vim/.backup'), 'p')
endif
set backupext=.bak
" write and undo
set undofile
set undodir=~/.vim/.undofile//
if !isdirectory(expand('~/.vim/.undofile'))
    call mkdir(expand('~/.vim/.undofile'), 'p')
endif
" save and swap
set swapfile
set directory=~/.vim/.swapfile//
if !isdirectory(expand('~/.vim/.swapfile'))
    call mkdir(expand('~/.vim/.swapfile'), 'p')
endif

" When you open the file, go back to where you last edited it
autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif 

" Indent setting
set shiftwidth=4    " Automatically indent to 4 Spaces
set softtabstop=4

" about file&path
filetype plugin on      
filetype indent on      
set autochdir     

" about syntax 
syntax enable	
syntax on 

" about search
set incsearch          
set hlsearch            
set ignorecase          
set smartcase           

" Automatically set background
let hour = strftime("%H")
if hour >= 7 && hour < 19
	set background=light
else
	set background=dark
endif

" ========================================================================
"  keymap
" ========================================================================

" F5
autocmd FileType python,go nnoremap <buffer> <C-F5> :call DeBugCode()<CR>
autocmd FileType python,go nnoremap <buffer> <F5> :call RunCode()<CR>
" F8
nnoremap <F8> :call ToggleTheme()<CR>

function! ToggleTheme()
	if &background == "dark"
		set background=light
	else
		set background=dark
	endif
endfunction

function! DeBugCode()
	if &filetype == 'python'
		:!python %
	endif
	if &filetype == 'go'
		:!go run %
	endif
endfunction

function! RunCode()
	if &filetype == 'python'
		:!python %
	endif
	if &filetype == 'go'
		:!go build %
	endif
endfunction

" TODO: next 
"let mapleader = "\\"
nnoremap <leader>q :q<CR>

" ========================================================================
"  Flag and env 
" ========================================================================

" Example Initialize the environment flag
let g:flag_git = 0
let g:flag_install = 0

" Checking the flag status
if filereadable(expand('$VIM\vimfiles\flag\flag_install')) || filereadable(expand('~/.vim/vimfiles/flag/flag_install'))
	let g:flag_install = 1
endif

function! InstallPlugins()
	"if (has('win32') || has('win64')) == 1
	"	source ~/.vim/vimfiles/vimscript/InstallPlugins.vim
	"elseif has('unix') == 1
	"	source ~/.vim/vimfiles/vimscript/InstallPlugins.vim
	"endif
	source ~/.vim/vimfiles/vimscript/InstallPlugins.vim
endfunction

" ========================================================================
"  OS 
" ========================================================================
" used Linux: Kali, Ubuntu, CentOS
" used Windows: Windows 11, 10

" colorscheme color
if !has('gui_running')
	"set notermguicolors
	set t_Co=256
endif

" windows
if (has('win32') || has('win64')) == 1

	set packpath+=~/.vim/vimfiles

	if !isdirectory(expand('$VIM/vimfiles/flag'))
		call mkdir(expand('$VIM/vimfiles/flag'), 'p')
	endif

	"set guifont=Sarsa_Fixed_SC:h14:cANSI:qDRAFT,Consolas:h12:b:cANSI:qDRAFT
	"set guifont="Sarsa Fixed SC":h14:cANSI:qDRAFT
	set guifont=更纱终端书呆黑体-简:h14:cGB2312:qDRAFT,Consolas,h12:b:cANSI:qDRAFT
	set ambiwidth=double
	if g:flag_install == 1
		colorscheme gruvbox
	else
		colorscheme retrobox
	endif

	if has('gui_running') == 1
		autocmd GUIENter * simalt ~x
	endif

" Linux
elseif has('unix') == 1
	set packpath+=~/.vim/vimfiles
	if g:flag_install == 1
		colorscheme gruvbox
	else
		colorscheme retrobox
	endif
else
	echo "unknow system"
endif

" If you do not load the plug-in, you do not need to load the content
if g:flag_install == 0
	finish
endif

"  ========================================================================
"  plugins
"  ========================================================================


"Bash
"ccls - C/C++
"Clangd - C/C++
"Clojure
"Crystal
"Css/Less/Sass
"cquery - C/C++
"CWL
"Docker
if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'docker-langserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
        \ 'whitelist': ['dockerfile'],
        \ })
endif

"Erlang
"Flow - Javascript
"Go
if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls', '-remote=auto']},
        \ 'allowlist': ['go', 'gomod', 'gohtmltmpl', 'gotexttmpl'],
        \ })
    autocmd BufWritePre *.go
        \ call execute('LspDocumentFormatSync') |
        \ call execute('LspCodeActionSync source.organizeImports')
endif
"disable the completion provided by vim-go
let g:go_code_completion_enabled = 1

"Godot
"Groovy
"Hack
"Haskell
"HTML
if executable('html-languageserver')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'html-languageserver',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'html-languageserver --stdio']},
    \ 'whitelist': ['html'],
  \ })
endif

"Java
autocmd FileType java setlocal omnifunc=lsp#complete
"\ 'cmd': {server_info->['jdtls', '-data', getcwd()]},
if executable('jdtls')
    "autocmd FileType java setlocal omnifunc=lsp#complete
    au User lsp_setup call lsp#register_server({
        \ 'name': 'Eclipse JDT Language Server',
	\ 'cmd': ['cmd.exe', '/C', 'C:\\Users\\Leo\\tools\\jdtls\\start-jdtls.cmd'],
        \ 'allowlist': ['java']
        \ })
endif

"JavaScript
"Use directory with .git as root
if executable('typescript-language-server')
 "   au User lsp_setup call lsp#register_server({
 "     \ 'name': 'javascript support using typescript-language-server',
 "     \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
 "     \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
 "     \ 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact']
 "     \ })
" Use directory with package.json as root  
  au User lsp_setup call lsp#register_server({
    \ 'name': 'javascript support using typescript-language-server',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
    \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
    \ 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact'],
    \ })

endif

"Julia
"Kotlin
"Lua
"Perl
"PHP
if executable('intelephense')
  augroup LspPHPIntelephense
    au!
    au User lsp_setup call lsp#register_server({
        \ 'name': 'intelephense',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'intelephense --stdio']},
        \ 'whitelist': ['php'],
        \ 'initialization_options': {'storagePath': '/tmp/intelephense'},
        \ 'workspace_config': {
        \   'intelephense': {
        \     'files': {
        \       'maxSize': 1000000,
        \       'associations': ['*.php', '*.phtml'],
        \       'exclude': [],
        \     },
        \     'completion': {
        \       'insertUseDeclaration': v:true,
        \       'fullyQualifyGlobalConstantsAndFunctions': v:false,
        \       'triggerParameterHints': v:true,
        \       'maxItems': 100,
        \     },
        \     'format': {
        \       'enable': v:true
        \     },
        \   },
        \ }
        \})
   " au User lsp_setup call lsp#register_server({                                    
   "  \ 'name': 'php-language-server',                                            
   "  \ 'cmd': {server_info->['php', expand('~/.vim/plugged/php-language-server/bin/php-language-server.php')]},
   "  \ 'whitelist': ['php'],                                                     
   "  \ })
  augroup END
endif

"Python
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}}
        \ })
endif

"Ruby
"Rust
"Scala
"Swift
"Tex
"TOML
"TypeScript
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact'],
        \ })
endif

"OCaml+Reason
"VHDL
"Vim
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

"XML
if executable('java') && filereadable(expand('~/lsp/org.eclipse.lsp4xml-0.3.0-uber.jar'))
    au User lsp_setup call lsp#register_server({
        \ 'name': 'lsp4xml',
        \ 'cmd': {server_info->[
        \     'java',
        \     '-noverify',
        \     '-Xmx1G',
        \     '-XX:+UseStringDeduplication',
        \     '-Dfile.encoding=UTF-8',
        \     '-jar',
        \     expand('~/lsp/org.eclipse.lsp4xml-0.3.0-uber.jar')
        \ ]},
        \ 'whitelist': ['xml']
        \ })
endif

"YAML
if executable('yaml-language-server')
  augroup LspYaml
   autocmd!
   autocmd User lsp_setup call lsp#register_server({
       \ 'name': 'yaml-language-server',
       \ 'cmd': {server_info->['yaml-language-server', '--stdio']},
       \ 'allowlist': ['yaml', 'yaml.ansible'],
       \ 'workspace_config': {
       \   'yaml': {
       \     'validate': v:true,
       \     'hover': v:true,
       \     'completion': v:true,
       \     'customTags': [],
       \     'schemas': {},
       \     'schemaStore': { 'enable': v:true },
       \   }
       \ }
       \})
  augroup END
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
	
	set foldmethod=expr
	  \ foldexpr=lsp#ui#vim#folding#foldexpr()
	  \ foldtext=lsp#ui#vim#folding#foldtext()
endfunction

" complete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" The Vim startup time is displayed
let g:start_time = reltime()
autocmd VimEnter * ++nested call timer_start(10, { -> UpdateLightlineWithStartupTime() })
function! UpdateLightlineWithStartupTime()
	let l:elapsed_time = reltimefloat(reltime(g:start_time)) * 1000
	let g:startup_time_display = "VIM, YES! " . "🚀 " . printf('%.2f', l:elapsed_time) . " ms"
	call lightline#update()
	" It's gone in 10 seconds
	call timer_start(10000, { -> RemoveStartupTime() })
endfunction
function! RemoveStartupTime()
	let g:startup_time_display = ''
	call lightline#update()
endfunction
function! LightlineStartupTime()
	return get(g:, 'startup_time_display', '')
endfunction


" line
let g:lightline = {
			\ 'colorscheme': 'wombat',
			\ 'active': {
			\   'left': [ [ 'mode', ], [ 'gitbranchstatus', 'gitbranch' ] , ['filename', 'readonly', 'modified', 'startup_time'] ],
			\   'right': [ ['lineinfo'], [ 'percent' ], ['filetype', 'fileformat', 'fileencoding', 'charvaluehex' ] ],
			\ },
			\ 'component_function': {
			\   'gitbranchstatus': 'FugitiveStatusline',
			\   'gitbranch': 'FugitiveHead',
			\	'startup_time': 'LightlineStartupTime',
			\ },
			\ 'component': {
			\   'charvaluehex': '0x%B',
			\ },
			\ }

" rainbow 
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
"autocmd BufRead,BufNewFile * :RainbowToggle
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

finish
