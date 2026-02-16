" Lua 文件类型：缩进、折叠及折叠状态保存/恢复
" 常见风格：2 空格缩进（LuaRocks / 多数风格指南）
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal foldmethod=indent

" 注释格式（便于 vim-commentary 等）
setlocal commentstring=--\ %s

" Lua 缓冲区：保存/恢复视图时包含折叠
augroup luaViewFold
	au!
	autocmd BufWinLeave <buffer> set viewoptions+=folds | silent! mkview | set viewoptions-=folds
	autocmd BufWinEnter <buffer> set viewoptions+=folds | silent! loadview | set viewoptions-=folds
	autocmd BufWritePost <buffer> set viewoptions+=folds | silent! mkview | set viewoptions-=folds
augroup END

" --- ~/.vim/ftplugin/lua.vim ---

" 1. 基础编辑器设置
setlocal shiftwidth=2 tabstop=2 expandtab
setlocal foldmethod=manual

" 2. 动态 LSP 路径判定（与 plugins.vim 中 vim-plug 安装路径一致）
if has('win32') || has('win64')
    let s:lua_lsp_path = expand(g:vim_dir . '/plugged/lua-language-server/bin/lua-language-server.exe')
    
    " 如果该二进制文件确实存在，则注入到 CoC 配置中
    if filereadable(s:lua_lsp_path)
        let b:coc_user_config = {
            \ 'languageserver': {
            \   'lua': {
            \     'command': s:lua_lsp_path,
            \     'filetypes': ['lua'],
            \     'rootPatterns': ['.git/', '.luarc.json', 'init.lua']
            \   }
            \  }
            \ }
        
        " 将 Buffer 级别的配置同步到全局，并触发 CoC 刷新
        call coc#config('languageserver.lua', b:coc_user_config['languageserver']['lua'])
    endif
endif

" 3. 设置折叠快捷键
nnoremap <buffer> <leader>zf :call CocAction('fold')<CR>