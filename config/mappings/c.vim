" ============================================================================
" 映射配置 - C (Coc List)
" ============================================================================

" CoCList 快捷键映射
" 显示所有诊断
nnoremap <silent><nowait> <leader>cd  :<C-u>CocList diagnostics<cr>
" 管理扩展
nnoremap <silent><nowait> <leader>ce  :<C-u>CocList extensions<cr>
" 显示命令列表
nnoremap <silent><nowait> <leader>cc  :<C-u>CocList commands<cr>
" 查找当前文档符号
nnoremap <silent><nowait> <leader>co  :<C-u>CocList outline<cr>
" 全局查找工作区符号
nnoremap <silent><nowait> <leader>cs  :<C-u>CocList -I symbols<cr>
" 下一个项目
nnoremap <silent><nowait> <leader>cj  :<C-u>CocNext<CR>
" 上一个项目
nnoremap <silent><nowait> <leader>ck  :<C-u>CocPrev<CR>
" 恢复最近一次的 coc 列表
nnoremap <silent><nowait> <leader>cp  :<C-u>CocListResume<CR>
" 运行当前行的 Code Lens
nmap <leader>cl  <Plug>(coc-codelens-action)
