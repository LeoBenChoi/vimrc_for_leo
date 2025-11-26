"==============================================================
" config/mappings/a.vim
" LSP 代码操作相关快捷键：所有 a 开头的快捷键统一管理
"==============================================================

if exists('g:loaded_a_mappings')
  finish
endif
let g:loaded_a_mappings = 1

"==============================================================
" a / A - Action / 代码操作
"==============================================================
" 规范：小写 a 用于 LSP 代码操作（修复、重构等）

" aq -> Quick Fix：快速修复当前问题（光标所在位置的快速修复）
nmap <silent> <leader>aq <Plug>(coc-fix-current)

" ac -> Code Action Cursor：光标处的代码操作（修复/重构）
nmap <silent> <leader>ac <Plug>(coc-codeaction-cursor)

" a -> Code Action Selected：选中区域的代码操作（可视化模式）
" 选中区域的代码操作（可视化模式）
xmap <silent> <leader>a <Plug>(coc-codeaction-selected)
" 选中区域的代码操作（普通模式）
nmap <silent> <leader>a <Plug>(coc-codeaction-selected)

" as -> Code Action Source：源代码级别的代码操作（模块管理、批量重构、导入优化）
nmap <silent> <leader>as <Plug>(coc-codeaction-source)

"==============================================================
" Python 导入辅助功能（当 LSP 自动导入失败时使用）
"==============================================================
" ai -> Add Import：手动添加 Python 导入
function! s:AddPythonImport() abort
  let module = input('输入要导入的模块名: ')
  if empty(module)
    return
  endif
  
  " 查找文件开头的导入区域
  let import_line = 0
  let last_import = 0
  let in_import_block = 0
  
  " 查找第一个非注释、非空行
  for i in range(1, line('$'))
    let line = getline(i)
    if line =~# '^from\s\+\|^import\s\+'
      let in_import_block = 1
      let last_import = i
    elseif in_import_block && line !~# '^\s*\(#\|$\)'
      break
    endif
  endfor
  
  " 确定插入位置
  if last_import > 0
    let insert_line = last_import + 1
  else
    " 查找文件开头的注释和空行后
    let insert_line = 1
    for i in range(1, min([20, line('$')]))
      let line = getline(i)
      if line !~# '^\s*\(#\|$\)'
        let insert_line = i
        break
      endif
    endfor
  endif
  
  " 插入导入语句
  let import_stmt = 'import ' . module
  call append(insert_line - 1, import_stmt)
  echo '已添加: ' . import_stmt
endfunction

" ad -> Add Import Diagnostic：诊断 Python 导入问题
function! s:PythonImportDiagnostic() abort
  if &filetype != 'python'
    echohl ErrorMsg
    echomsg '当前文件不是 Python 文件'
    echohl None
    return
  endif
  
  echo "\n=== Python 导入诊断 ==="
  
  " 检查 coc 是否运行
  if !exists('*coc#rpc#start_server')
    echo "[-] coc.nvim 未安装或未启动"
    return
  endif
  
  " 检查扩展
  try
    let extensions = CocAction('extensionStats')
    let has_pyright = 0
    if type(extensions) == type([])
      for ext in extensions
        if has_key(ext, 'id') && ext.id =~# 'pyright\|python\|pylsp'
          let has_pyright = 1
          echo "[+] 找到 Python 扩展: " . ext.id
          break
        endif
      endfor
    endif
    
    if !has_pyright
      echo "[-] 未找到 Python LSP 扩展"
      echo "   请执行: :CocInstall coc-pyright"
      echo "   或尝试: :CocInstall @yaegassy/coc-pylsp"
      echo "   注意：pylsp 扩展名是 @yaegassy/coc-pylsp"
    endif
  catch
    echo "[!]  无法检查扩展状态，请手动执行 :CocList extensions"
  endtry
  
  " 检查 LSP 状态
  echo "\n检查 LSP 服务器状态..."
  echo "执行 :CocInfo 查看详细信息"
  
  " 检查当前行的符号
  let word = expand('<cword>')
  if !empty(word)
    echo "\n当前光标下的词: " . word
    echo "尝试跳转到定义: gd"
    echo "查看文档: K"
  endif
endfunction

" Python 导入辅助快捷键（仅 Python 文件）
augroup PythonImportHelper
  autocmd!
  " ai -> Add Import：手动添加 Python 导入
  autocmd FileType python nnoremap <silent> <buffer> <leader>ai :call <SID>AddPythonImport()<CR>
  " ad -> Add Import Diagnostic：诊断 Python 导入问题
  autocmd FileType python nnoremap <silent> <buffer> <leader>ad :call <SID>PythonImportDiagnostic()<CR>
augroup END

