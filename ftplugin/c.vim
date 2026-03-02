" C 文件類型優化：縮進與編輯習慣
" 僅對 C 文件生效，不影響其他類型

if exists('b:did_ftplugin_c')
  finish
endif
let b:did_ftplugin_c = 1

" === 縮進（與 clang-format 預設 2 格一致）===
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab
setlocal cindent
" 大括號不縮進、函數體再縮一層（K&R 風格）
setlocal cinoptions=>2,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
setlocal indentkeys=0{,0},0),0],!^F,o,O,e

" === 換行與註釋 ===
setlocal textwidth=0
setlocal formatoptions-=t
setlocal formatoptions+=croql

" === 匹配括號 ===
setlocal matchpairs+=<:>

" === 關鍵字補全 ===
setlocal iskeyword+=_

" === 可選：保存時刪除行尾空格（若不想用可註釋）
" au BufWritePre <buffer> :%s/\s\+$//e
