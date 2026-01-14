" ============================================================================
" YAML 文件类型缩进配置
" 文件位置: ~/.vim/ftplugin/yaml.vim
" 说明: YAML 文件推荐使用 2 个空格缩进（业界标准）
" ============================================================================

" 防止重复加载
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" YAML 推荐 2 空格缩进
setlocal expandtab
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
