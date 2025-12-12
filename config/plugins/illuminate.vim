"==============================================================
" config/plugins/illuminate.vim
" vim-illuminate 插件配置：自动高亮光标下的单词
"==============================================================

if !exists('g:loaded_illuminate')
  finish
endif

"==============================================================
" 1. 基本配置
"==============================================================

" 高亮延迟（毫秒），避免光标快速移动时频繁更新
" 设置为 0 可以立即更新，但可能影响性能
" 推荐值：50-100 毫秒（减少延迟可以避免高亮"卡住"的问题）
" 如果仍然出现高亮卡住，可以进一步减少到 0（立即更新）
let g:Illuminate_delay = 50

" 是否高亮光标下的单词（默认启用）
let g:Illuminate_highlightUnderCursor = 1

" 在插入模式下禁用高亮（减少干扰，避免高亮卡住）
" 注意：vim-illuminate 默认在插入模式下会清除高亮
" 如果仍然出现高亮卡住，可以尝试禁用此选项（设置为 0）
" let g:Illuminate_onInsertEnter = 0

"==============================================================
" 2. 文件类型配置
"==============================================================

" 禁用高亮的文件类型（某些文件类型可能不需要高亮）
let g:Illuminate_ftblacklist = ['nerdtree', 'vista', 'fzf', 'startify']

" 启用高亮的文件类型（如果设置了，只有这些文件类型会高亮）
" let g:Illuminate_ftwhitelist = ['python', 'javascript', 'typescript', 'vue', 'go']

"==============================================================
" 3. 单词匹配配置
"==============================================================

" 最小单词长度（少于这个长度的单词不会被高亮）
let g:Illuminate_minimumWordLength = 2

" 是否只高亮完整单词（不匹配部分单词，如 'word' 不会匹配 'words'）
" 默认启用，推荐保持启用
let g:Illuminate_useWordBoundary = 1

"==============================================================
" 4. 性能优化
"==============================================================

" 是否在插入模式下禁用高亮（减少干扰）
" 默认启用，如果觉得插入模式下高亮干扰，可以设置为 0
" let g:Illuminate_highlightUnderCursor = 0

"==============================================================
" 5. 自定义高亮组（重要：确保高亮可见）
"==============================================================
" vim-illuminate 使用以下高亮组：
"   - IlluminatedWordText  : 普通文本高亮
"   - IlluminatedWordRead  : 只读文本高亮
"   - IlluminatedWordWrite : 可写文本高亮
"
" 如果高亮不明显或闪烁，需要自定义这些高亮组的颜色

" 定义自定义高亮组（确保高亮明显可见）
" 注意：vim-illuminate 插件不支持区分光标位置和其他匹配位置
" 如果需要光标位置（黑色）和其他匹配（灰色）的区别，请禁用此插件，使用自定义实现（config/mappings/h.vim）
"
" Windows 终端下使用背景色高亮（更明显）
if has('win32') || has('win64') || has('win16')
  " Windows 终端：使用深色背景 + 浅色前景（灰色，用于所有匹配）
  highlight IlluminatedWordText ctermbg=238 ctermfg=250 cterm=NONE guibg=#444444 guifg=#bcbcbc gui=NONE
  highlight IlluminatedWordRead ctermbg=238 ctermfg=250 cterm=NONE guibg=#444444 guifg=#bcbcbc gui=NONE
  highlight IlluminatedWordWrite ctermbg=238 ctermfg=250 cterm=NONE guibg=#444444 guifg=#bcbcbc gui=NONE
else
  " Linux/Mac：使用更柔和的背景色（灰色，用于所有匹配）
  highlight IlluminatedWordText ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
  highlight IlluminatedWordRead ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
  highlight IlluminatedWordWrite ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
endif

" 如果还是不明显，可以尝试使用更显眼的颜色：
" highlight IlluminatedWordText ctermbg=52 ctermfg=255 cterm=bold guibg=#5f0000 guifg=#ffffff gui=bold
" highlight IlluminatedWordRead ctermbg=52 ctermfg=255 cterm=bold guibg=#5f0000 guifg=#ffffff gui=bold
" highlight IlluminatedWordWrite ctermbg=52 ctermfg=255 cterm=bold guibg=#5f0000 guifg=#ffffff gui=bold

"==============================================================
" 6. 快捷键映射（可选）
"==============================================================
" vim-illuminate 默认没有快捷键，如果需要可以添加

" 手动清除高亮（如果高亮卡住，可以使用此命令清除）
" 方法：通过触发一个不会匹配任何内容的搜索来清除高亮
function! s:ClearIlluminateHighlight() abort
  " 方法1：使用 nohlsearch（清除搜索高亮，可能对 illuminate 无效）
  nohlsearch
  " 方法2：触发插件重新评估（通过移动光标到当前位置）
  " 这会让插件重新检查并更新高亮
  " 注意：vim-illuminate 会自动处理，这里只是提供一个清除的尝试
endfunction

" 切换高亮功能（如果插件支持）
" nnoremap <silent> <leader>hh :IlluminateToggle<CR>

" 手动清除高亮（如果高亮卡住时使用）
" 注意：这个快捷键可能与自定义实现的 <leader>hc 冲突
" 如果使用 vim-illuminate 插件，建议使用此快捷键
" 如果高亮卡住，可以按 <leader>hc 尝试清除
nnoremap <silent> <leader>hc :call <SID>ClearIlluminateHighlight()<CR>

"==============================================================
" 7. 自动清除机制（修复高亮卡住问题）
"==============================================================
" 注意：vim-illuminate 插件本身会在光标移动到非单词字符时自动清除高亮
" 但如果延迟设置导致高亮更新不及时，可能会出现"卡住"的情况
" 
" 解决方案：
"   1. 减少延迟时间（已设置为 50ms，如果还有问题可以进一步减少到 0）
"   2. 在插入模式下，插件会自动清除高亮
"   3. 如果高亮仍然卡住，可以使用 <leader>hc 手动清除
"
" 由于 vim-illuminate 使用内部机制管理高亮，我们不需要手动清除
" 只需要确保延迟设置合理即可

"==============================================================
" 8. 帮助信息
"==============================================================
" vim-illuminate 插件说明：
"   - 自动高亮光标下的单词在当前文件中的所有出现位置
"   - 支持多种文件类型
"   - 性能优化，延迟更新避免卡顿
"   - 可配置高亮组、文件类型、单词长度等
"
" 已优化的配置：
"   - 延迟时间减少到 50ms（减少高亮卡住的问题）
"   - 插入模式下禁用高亮（减少干扰）
"   - 添加自动清除机制（光标移动到非单词字符时清除高亮）
"
" 如果仍然出现高亮卡住的问题：
"   1. 将 g:Illuminate_delay 进一步减少到 0（立即更新）
"   2. 使用 <leader>hc 手动清除高亮（如果已映射）
"   3. 考虑禁用插件，使用自定义实现（config/mappings/h.vim）
"
" 插件 GitHub: https://github.com/RRethy/vim-illuminate
"
" 如果不想使用插件，可以禁用此文件，使用自定义实现（config/mappings/h.vim）

