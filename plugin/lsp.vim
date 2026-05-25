" from https://github.com/jclsn/vimconfig "
let lspOpts = #{
			\   aleSupport: v:false,
			\   autoComplete: v:true,
			\   autoHighlight: v:true,
			\   autoHighlightDiags: v:true,
			\   autoPopulateDiags: v:true,
			\   codeActionPopupStyle: 'full',
			\   completionMatcher: 'case',
			\   completionMatcherValue: 1,
			\   definitionFallback: v:true,
			\   diagSignErrorText: '❗',
			\   diagSignHintText: '💡',
			\   diagSignInfoText: '💡',
			\   diagSignWarningText: '💡',
			\   diagSignPriority: {
			\       'Error': 100,
			\       'Warning': 99,
			\       'Information': 98,
			\       'Hint': 97
			\   },
			\   echoSignature: v:false,
			\   hideDisabledCodeActions: v:false,
			\   highlightDiagInline: v:true,
			\   hoverInPreview: v:false,
			\   hoverFallback: v:true,
			\   ignoreMissingServer: v:true,
			\   keepFocusInDiags: v:true,
			\   keepFocusInReferences: v:true,
			\   completionTextEdit: v:true,
			\   diagVirtualTextAlign: 'above',
			\   noNewlineInCompletion: v:true,
			\   popupBorder: v:true,
			\	popupBorderSignatureHelp: v:true,
			\   omniComplete: v:null,
			\   outlineOnRight: v:true,
			\   outlineWinSize: 50,
			\   semanticHighlight: v:true,
			\   showDiagInBalloon: v:false,
			\   showDiagInPopup: v:true,
			\   showDiagOnStatusLine: v:false,
			\   showDiagWithSign: v:true,
			\   showDiagWithVirtualText: v:false,
			\   showInlayHints: v:false,
			\   showSignature: v:true,
			\   snippetSupport: v:true,
			\   ultisnipsSupport: v:true,
			\   useBufferCompletion: v:false,
			\   usePopupInCodeAction: v:true,
			\   vsnipSupport: v:false,
			\   useQuickfixForLocations: v:false,
			\   bufferCompletionTimeout: 100,
			\   customCompletionKinds: v:false,
			\   completionKinds: {},
			\   filterCompletionDuplicates: v:true,
			\ }

autocmd User LspSetup call LspOptionsSet(lspOpts)

" let lspServers = [#{
" 	\	  name: 'clang',
" 	\	  filetype: ['c', 'cpp'],
" 	\	  path: '/usr/local/bin/clangd',
" 	\	  args: ['--background-index']
" 	\ }]

let lspServers = [#{
			\   name: 'gopls',
			\   filetype: 'go',
			\   path: 'gopls',
			\   args: ['serve'],
			\   workspaceConfig: #{
			\     gopls: #{
			\       hints: #{
			\         assignVariableTypes: v:true,
			\         compositeLiteralFields: v:true,
			\         compositeLiteralTypes: v:true,
			\         constantValues: v:true,
			\         functionTypeParameters: v:true,
			\         parameterNames: v:true,
			\         rangeVariableTypes: v:true
			\       }
			\     }
			\   }
	\ }]


autocmd User LspSetup call LspAddServer(lspServers)

autocmd User LspAttached {
	nnoremap <buffer> <silent> gd <cmd>LspGotoDefinition<cr>
	nnoremap <buffer> <silent> K  <cmd>LspHover<cr>
	nnoremap <buffer> <silent> [d <cmd>LspDiag prev<cr>
	nnoremap <buffer> <silent> ]d <cmd>LspDiag next<cr>
	nnoremap <buffer> <silent> <leader>rn <cmd>LspRename<cr>
	nnoremap <buffer> <silent> <leader>ca <cmd>LspCodeAction<cr>
}

inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" nnoremap <silent> <leader>pe :LspDiagPrev<CR>
" nnoremap <silent> <leader>ne :LspDiagNext<CR>
nnoremap <silent> <leader>pd :LspPeekDefinition<CR>
nnoremap <silent> <leader>pdc :LspPeekDeclaration<CR>
nnoremap <silent> <leader>pr :LspPeekReferences<CR>
nnoremap <silent> <leader>ol :LspOutline<CR>
nnoremap <silent> <leader>di :LspDiagShow<CR>
nnoremap <leader>cl :LspCodeLens<CR>

function! s:SmartHover() abort
	let result = execute('LspHover')
	if result =~ 'Error'
		call feedkeys('K', 'n')
	endif
endfunction

nnoremap <silent> <RightMouse> :call <SID>SmartHover()<CR>
nnoremap <silent> <MiddleMouse> :LspPeekDefinition<CR>
nnoremap <silent> <C-.> :LspGotoDefinition<CR>

nnoremap <silent> gy :LspGotoTypeDef<CR>
nnoremap <silent> gi :LspGotoImpl<CR>
nnoremap <silent> gdc :LspGotoDeclaration<CR>

xnoremap <silent> <leader>f :LspFormat<CR>
nnoremap <silent> <leader>f :LspFormat<CR>

set formatexpr=lsp#lsp#FormatExpr() " Map LspFormat to the gq command

augroup LspAutoActions
    autocmd!
	autocmd BufWritePre *.go silent! LspOrganizeImports
	autocmd BufWritePre *.go silent! LspFormat
augroup END

