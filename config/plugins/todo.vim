"==============================================================
" config/plugins/todo.vim
" TODO 高亮配置：使用 Vim 原生 match 机制
"==============================================================

if exists('g:loaded_todo_config')
    finish
endif
let g:loaded_todo_config = 1

"==============================================================
" TODO 高亮配置（Vim 原生 match 机制）
"==============================================================

" 存储匹配 ID（用于清除旧匹配）
let s:todo_match_id = -1

" 应用 TODO 高亮的函数
function! s:ApplyTodoHighlight() abort
    " 清除旧的匹配
    if s:todo_match_id >= 0
        try
            call matchdelete(s:todo_match_id)
        catch
        endtry
        let s:todo_match_id = -1
    endif
    
    " 强制重新设置 Todo 高亮组颜色（使用 ! 强制覆盖主题设置）
    " 推荐颜色方案：橙色系（醒目但不会太刺眼，适合 TODO）
    " 可选方案：
    "   1. 橙色（推荐）：ctermbg=208 guibg=#FF8C00 - 醒目且柔和
    "   2. 琥珀色：ctermbg=214 guibg=#FFB000 - 温暖明亮
    "   3. 深橙色：ctermbg=166 guibg=#E67E22 - 更沉稳
    "   4. 红色（原方案）：ctermbg=196 guibg=#FF0000 - 最醒目但可能刺眼
    highlight! Todo ctermfg=white ctermbg=208 guifg=#FFFFFF guibg=#FF8C00 cterm=bold gui=bold
    
    " 添加 TODO 匹配
    try
        let s:todo_match_id = matchadd('Todo', '\v\C<TODO', 10)
    catch
        " 如果失败，忽略错误
    endtry
endfunction

" 原生 TODO 高亮
" 定义一个自动命令组
augroup HighlightTodo
    autocmd!
    " 打开任何窗口或文件时，自动匹配 TODO 关键词
    autocmd WinEnter,VimEnter * call s:ApplyTodoHighlight()
    " 在颜色方案改变时重新应用（确保在主题加载后生效）
    autocmd ColorScheme * call s:ApplyTodoHighlight()
augroup END

" 立即应用一次（如果已有文件打开）
if expand('%') != ''
    call s:ApplyTodoHighlight()
endif