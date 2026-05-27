" call LspOptionsSet(#{
"         " --- 1. 外部插件与集成配置 ---
"         \   aleSupport: v:false,               " 是否将诊断信息发送给 ALE 插件（若为 true 则交由 ALE 统一显示，当前关闭）
"         \   ultisnipsSupport: v:false,         " 是否启用 SirVer/ultisnips 代码片段插件支持（当前关闭）
"         \   vsnipSupport: v:false,             " 是否启用 hrsh7th/vim-vsnip 代码片段插件支持（当前关闭）
"         \   snippetSupport: v:false,           " 是否开启通用的代码片段补全支持（当前关闭）

"         " --- 2. 自动补全 (Completion) 核心配置 ---
"         \   autoComplete: v:true,              " 是否在插入模式下自动弹出补全菜单（若关闭则需手动触发 omni-completion）
"         \   omniComplete: v:null,              " 手动全能补全(omni)开关（v:null 表示如果 autoComplete 为真则不强制覆盖）
"         \   omniCompleteAllowBare: v:false,    " 是否允许在光标前没有触发字符（如点号或逗号）时也触发 omni 补全（设为 true 会有很多空格造成的干扰）
"         \   completionMatcher: 'case',         " 客户端补全过滤匹配模式：'case'(区分大小写, 默认), 'icase'(忽略大小写), 'fuzzy'(模糊匹配)
"         \   completionMatcherValue: 1,         " 补全匹配器的附加权重值/行为设定
"         \   completionTextEdit: v:true,        " 补全选中后，是否应用 LSP 服务器提供的文本修改（若使用外部片段插件则需设为 false 避免二次修改）
"         \   noNewlineInCompletion: v:false,    " 是否禁止在选中补全项并按下回车 <CR> 时自动插入新行
"         \   useBufferCompletion: v:false,      " 是否将当前 buffer 里的普通单词也提取出来加入到自动补全列表中（当前关闭）
"         \   bufferCompletionTimeout: 100,      " 提取当前 buffer 单词的超时时间（毫秒），避免大文件卡顿
"         \   filterCompletionDuplicates: v:false," 是否过滤由 LSP 服务器返回的重复补全条目
"         \   condensedCompletionMenu: v:false,  " 精简补全菜单：只显示单词和类型，将详细文档等内容移到 info 弹窗中

"         " --- 3. 补全菜单/弹窗的外观与高亮 ---
"         \   customCompletionKinds: v:false,    " 是否开启自定义补全类型图标/文本
"         \   completionKinds: {},               " 配合 customCompletionKinds 使用的自定义图标映射字典
"         \   documentationFormat: ['markdown', 'plaintext'], " 向 LSP 服务器申明的文档接收格式优先级（优先 Markdown）

"         " --- 4. 诊断信息 (Diagnostics/错误与警告) 核心配置 ---
"         \   maxDiagnostics: 200,               " 限制接收和处理来自服务器的最大诊断信息数量，防止百千个错误解析拖慢 Vim
"         \   autoHighlightDiags: v:true,         " 是否自动在含有错误/警告的行号左侧放置标记(Signs)
"         \   autoPopulateDiags: v:false,        " 是否自动将所有的 LSP 错误和警告填充到 Vim 的 Location List 窗口中
"         \   showDiagWithSign: v:true,          " 是否通过左侧行号边栏的标记(Sign)来展示代码有错误
"         \   showDiagWithVirtualText: v:false,  " 是否在代码行右侧或上方显示虚拟文本(Virtual Text)来提示错误（需要 Vim 9.0.1157+）
"         \   diagVirtualTextAlign: 'above',     " 虚拟文本错误信息的对齐方式：'above'(行上方, 默认), 'below'(下方), 'after'(行尾)
"         \   diagVirtualTextWrap: 'default',    " 虚拟文本错误信息的换行方式：'default', 'wrap'(折行), 'truncate'(截断)
"         \   showDiagInBalloon: v:true,         " 当鼠标悬停在错误文本上时，是否在气泡弹窗(Balloon)中显示错误详情（GUI或支持鼠标的终端）
"         \   showDiagInPopup: v:true,           " 当执行 `:LspDiag current` 时，是否使用弹窗(Popup)而不是在底部命令行回显错误
"         \   showDiagOnStatusLine: v:false,     " 是否在 Vim 底部状态栏(StatusLine)显示当前的诊断信息
"         \   highlightDiagInline: v:true,       " 是否在代码内部对错误/警告文本进行下划线或背景色高亮

"         " --- 5. 错误边栏标记的文本自定义 (Signs Text) ---
"         \   diagSignErrorText: 'E>',           " 错误(Error)在左侧边栏显示的文本标识
"         \   diagSignWarningText: 'W>',         " 警告(Warning)在左侧边栏显示的文本标识
"         \   diagSignInfoText: 'I>',            " 信息(Info)在左侧边栏显示的文本标识
"         \   diagSignHintText: 'H>',            " 提示(Hint)在左侧边栏显示的文本标识

"         " --- 6. 悬浮提示 (Hover) 与函数签名 (Signature) ---
"         \   autoHighlight: v:false,            " 【高亮符号】是否在普通模式下，自动高亮光标下符号在当前文件里的所有出现位置
"         \   showSignature: v:true,             " 在插入模式下输入 `(` 或 `,` 时，是否自动弹出函数的参数签名提示
"         \   echoSignature: v:false,            " 是否将函数签名显示在底部命令行，而不是弹窗中（开启此项可获得极简界面）
"         \   showSignatureDocs: v:false,        " 弹出参数签名时，是否同时把函数底部的详细文档一同展示出来
"         \   hoverInPreview: v:false,           " 运行 `:LspHover` 查看文档时，是使用传统的 Preview 窗口(v:true)，还是使用现代 Popup 弹窗(v:false)
"         \   completionInPreview: v:false,      " 是否把补全项的文档强行放在 Preview 窗口里展示

"         " --- 7. 弹窗外观控制 (Popup Windows) ---
"         \   popupBorder: v:true,               " 是否为 LSP 所有的弹窗（文档、代码操作等）绘制边框
"         \   popupHighlight: 'Normal',          " 弹窗内部文本和背景所使用的基础高亮组（这里设为了普通的 Normal）
"         \   popupBorderHighlight: 'Title',     " 弹窗边框所使用的高亮组（这里用 Title 的颜色渲染边框）
"         \   popupBorderHighlightPeek: 'Special'," 使用 Peek 命令（预览定义）时，弹窗边框所使用的高亮组（这里用 Special 颜色区分）
"         \   popupBorderSignatureHelp: v:false, " 是否专门为函数参数签名(Signature Help)弹窗绘制边框（您关闭了此项）
"         \   popupHighlightSignatureHelp: 'Pmenu'," 参数签名弹窗内部文本和背景的高亮组（这里设为了补全菜单 Pmenu 的样式）
"         \   closePreviewOnComplete: v:true,    " 当补全菜单关闭时，如果开启了 Preview 窗口，是否自动关闭该 Preview 窗口

"         " --- 8. 窗口焦点与视图交互 ---
"         \   keepFocusInDiags: v:true,          " 运行 `:LspDiag show` 查看错误列表后，光标是否保持/聚焦在错误列表窗口中
"         \   keepFocusInReferences: v:true,     " 运行查看引用后，光标是否保持/聚焦在引用列表窗口中
"         \   outlineOnRight: v:false,           " 运行 `:LspOutline` 查看大纲时，是否将大纲窗口放在屏幕右侧（false 表示在左侧）
"         \   outlineWinSize: 20,                " 大纲窗口的默认宽度（列数）
"         \   usePopupInCodeAction: v:false,     " 触发 Code Action (修复建议) 时，是否使用弹窗菜单代替底部的数字输入列表(inputlist)
"         \   useQuickfixForLocations: v:false,  " 查看引用列表等位置信息时，是使用 Quickfix 列表(v:true) 还是 Location 列表(v:false)

"         " --- 9. 其他高级与兜底配置 ---
"         \   semanticHighlight: v:true,         " 是否启用语义高亮（让 LSP 根据代码逻辑对变量、结构体等进行更精准的着色）
"         \   showInlayHints: v:false,           " 是否开启内联提示（Inlay Hints，如在代码间虚拟显示参数名和推导类型，当前关闭）
"         \   ignoreMissingServer: v:false,      " 当找不到某个语言的 LSP 可执行程序时，是否静默不报错
"         \   hideDisabledCodeActions: v:false,  " 是否隐藏被语言服务器标记为“不可用/禁用”的代码修复操作
"         \ })

let lspOpts = #{
			\		completionMatcher: 'case',
			\		useBufferCompletion: v:true,
			\		filterCompletionDuplicates: v:true,
			\		condensedCompletionMenu: v:true,
			\		autoPopulateDiags: v:true,
			\		diagVirtualTextAlign: 'after',
			\		diagVirtualTextWrap: 'truncate',
			\		autoHighlight: v:true,
			\		showSignature: v:false,
			\		hoverInPreview: v:false,
			\		outlineOnRight: v:true,
			\		usePopupInCodeAction: v:true,
			\		noNewlineInCompletion: v:true,
			\		popupBorderSignatureHelp: v:true,
			\		outlineWinSize: 30,
			\		ultisnipsSupport: v:true,
			\	}
autocmd User LspSetup call LspOptionsSet(lspOpts)

set updatetime=4000

let lspServers = []

" let lspServers = [#{
" 	\	  name: 'clang',
" 	\	  filetype: ['c', 'cpp'],
" 	\	  path: '/usr/local/bin/clangd',
" 	\	  args: ['--background-index']
" 	\ }]

if executable('clangd')
	let lspServers += [#{
				\		filetype: ['c', 'cpp'],
				\		name: 'clangd',
				\		path: 'clangd',
				\		args: ['--background-index', '--clang-tidy'],
				\	}]
endif

if executable('gopls')
	let lspServers += [#{
				\		filetype: ['go', 'gomod'],
				\		name: 'golang',
				\		path: 'gopls',
				\		args: ['serve'],
				\		workspaceConfig: #{
				\			gopls: #{
				\				hints: #{
				\					assignVariableTypes: v:true,
				\					compositeLiteralFields: v:true,
				\					compositeLiteralTypes: v:true,
				\					constantValues: v:true,
				\					functionTypeParameters: v:true,
				\					parameterNames: v:true,
				\					rangeVariableTypes: v:true,
				\				}
				\			}
				\		}
				\	}]
endif

if executable('basedpyright')
	let lspServers += [#{
				\		filetype: ['python'],
				\		name: 'basedpyright',
				\		path: 'basedpyright-langserver',
				\		args: ['--stdio'],
				\		syncInit: v:true
				\	}]
endif

if executable('ruff')
	let lspServers += [#{
			\		filetype: ['python'],
			\		name: 'ruff',
			\		path: 'ruff',
			\		args: ['server'],
			\		syncInit: v:true
			\	}]
endif

if executable('ruff')
	let lspServers += [#{
			\		filetype: 'vim',
			\		name: 'vim-language-server',
			\		path: 'vim-language-server',
			\		args: ['--stdio']
			\	}]
endif

autocmd User LspSetup call LspAddServer(lspServers)

" autocmd User LspAttached {
" 	nnoremap <buffer> <silent> gd <cmd>LspGotoDefinition<cr>
" 	nnoremap <buffer> <silent> K  <cmd>LspHover<cr>
" 	nnoremap <buffer> <silent> [d <cmd>LspDiag prev<cr>
" 	nnoremap <buffer> <silent> ]d <cmd>LspDiag next<cr>
" 	nnoremap <buffer> <silent> <leader>rn <cmd>LspRename<cr>
" 	nnoremap <buffer> <silent> <leader>ca <cmd>LspCodeAction<cr> 
" }

nnoremap <buffer> <silent> gd <cmd>LspGotoDefinition<cr>
nnoremap <buffer> <silent> K  <cmd>LspHover<cr>
nnoremap <buffer> <silent> [d <cmd>LspDiag prev<cr>
nnoremap <buffer> <silent> ]d <cmd>LspDiag next<cr>
nnoremap <buffer> <silent> <leader>rn <cmd>LspRename<cr>
nnoremap <buffer> <silent> <leader>ca <cmd>LspCodeAction<cr>

inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

nnoremap <silent> gy :LspGotoTypeDef<CR>
nnoremap <silent> gi :LspGotoImpl<CR>
nnoremap <silent> gdc :LspGotoDeclaration<CR>

xnoremap <silent> <leader>f :LspFormat<CR>
nnoremap <silent> <leader>f :LspFormat<CR>

nmap <LocalLeader>qf <Cmd>LspCodeAction<CR>
" nmap gd <Cmd>LspGotoDefinition<CR>
nmap <LocalLeader>gd <Cmd>tab LspGotoDefinition<CR>
nmap gr <Cmd>LspPeekReferences<CR>
nmap <LocalLeader>gr <Cmd>LspShowReferences<CR>
nmap <LocalLeader>rn <Cmd>LspRename<CR>
nmap <Leader>o <Cmd>LspDocumentSymbol<CR>
nmap <Leader>O <Cmd>LspSymbolSearch<CR>

