let g:which_key_vertical=1 " 设置为弹出模式


" 弹出方向，似乎不生效
" let g:which_key_position='botright'
" let g:which_key_position='topleft'

" let g:which_key_centered=1 " 1 居中显示 实际只是靠中间了一点 且1是默认值

" let g:which_key_use_floating_win = 0 " 0 切分屏幕 1 弹窗

" 实现类似nvim的右侧弹出，但是无法设置高度
" augroup ForceWhichKeyPosition
"     autocmd!
"     autocmd FileType which_key wincmd L
"     autocmd FileType which_key vertical resize 40
" augroup END

let g:which_key_ignore_outside_mappings = 1 " 隐藏字典以外的值

let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" 注册 leader 键
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

" 注册 Space 激活下方字典
call which_key#register('<Space>', "g:which_key_map")

" 初始化映射字典
let g:which_key_map = {}

" 官方示例，暂留
let g:which_key_map['w'] = {
      \ 'name' : '+windows' ,
      \ 'w' : ['<C-W>w'     , 'other-window']          ,
      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      \ 'h' : ['<C-W>h'     , 'window-left']           ,
      \ 'j' : ['<C-W>j'     , 'window-below']          ,
      \ 'l' : ['<C-W>l'     , 'window-right']          ,
      \ 'k' : ['<C-W>k'     , 'window-up']             ,
      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      \ 'J' : [':resize +5'  , 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      \ 'K' : [':resize -5'  , 'expand-window-up']      ,
      \ '=' : ['<C-W>='     , 'balance-window']        ,
      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      \ '?' : ['Windows'    , 'fzf-window']            ,
      \ }


" <Space>
" <CR>
" <Esc>
" <Tab>
" <BS>
" -
" _
" +
" =
" [
" ]
" {
" }
" ;
" :
" ,
" .
" /
" ?
" \
" |
" !
" @
" #
" $
" %
" ^
" &
" *
" (
" )
" ~
" `
" <
" >

" a
" b
" c
" d
" e
" f
" g
" h
" i
" j
" k
" l
" m
" n
" o
" p
" q
" r
" s
" t
" u
" v
" w
" x
" y
" z

" A
" B
" C
" D
" E
" F
" G
" H
" I
" J
" K
" L
" M
" N
" O
" P
" Q
" r
" S
" T
" U
" V
" W
" X
" Y
" Z
