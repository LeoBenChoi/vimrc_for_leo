""""""""
" 映射 "
""""""""
"" <F1> 帮助文档
"" <C-F1> 常用内容记录
"" <F2> 显示/关闭行号，默认为显示
"" <F3> vim二进制模式切换
"" <F4> 重新载入当前文件
"" <F5> 运行文件（如果可以的话）
"" <C-F5>和<S-F5>暂时不确定用哪一个比较顺手，所以两个都设置为了编译
"" <C-F5> 编译文件（如果可以的话）
"" <S-F5> 编译文件（如果可以的话）
"" <F7> 浅色模式
"" <F8> 深色模式
"" <F12> 打开配置文件

"" 定义映射
nnoremap <C-F1> :call OpenNotebook()<CR>
nnoremap <F2> :set number!<CR>
nnoremap <F3> :call ToggleHex()<CR>
nnoremap <F4> :source %<CR>
nnoremap <F5> :call RunFile()<CR>
nnoremap <S-F5> :call CompileRunFile()<CR>
nnoremap <C-F5> :call CompileRunFile()<CR>
nnoremap <F7> :set background=light<CR>
nnoremap <F8> :set background=dark<CR>
nnoremap <F12> :e $MYVIMRC<CR> 

"" 定义函数
"" F1 键打开帮助文档
func OpenNotebook()
	:e $VIM\vimfiles\doc\notebook.txt
endfunc

"" F3 键切换二进制显示（十六进制显示）
""切换显示模式：文本 <-> 十六进制
function! ToggleHex()
		"" 如果当前是普通文本模式，则转换为十六进制显示
  		execute ":%!xxd"
		execute ":w! %" . ".vimhex"
  		execute ":%!xxd -r"
  		execute ":w!"
  		execute ":e %" . ".vimhex"
	else
		"" 如果当前是xxd模式(即十六进制显示),则转换回普通文本
		execute ":%!xxd -r"
		execute "w! " . expand('%:r')
  		execute ":%!xxd"
  		execute ":w!"
  		execute ":e " . expand('%:r')
	endif
endfunction


"" 将 F5 键映射为检测并运行文件
"" 定义 RunFile 函数
function! RunFile()
    "" 获取当前文件的文件类型
    let filetype = &filetype
    "" 根据文件类型执行对应操作
    if filetype ==? 'python'
        "" 执行 Python 文件
		execute 'w!'
        execute '!python' shellescape(@%, 1)
    elseif filetype ==? 'go'
        "" 执行 Go 文件
		execute 'w!'
        execute '!go run' shellescape(@%, 1)
    else
        "" 提示不支持的文件类型
        echo "这个文件暂不能运行!"
    endif
endfunction

"" 定义 CompileRunFile 函数
function! CompileRunFile()
    "" 获取当前文件的文件类型
    let filetype = &filetype
    "" 如果是 Python 文件，直接执行
    if filetype ==? 'python'
        exec '!python' shellescape(@%, 1)
    "" 如果是 Go 文件，先编译再执行
    elseif filetype ==? 'go'
        "" 编译 Go 文件
        exec '!go build' shellescape(@%,1)
	else
        "" 提示不支持的文件类型
        echo "这个文件暂不支持编译!"
    endif
endfunction
