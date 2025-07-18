" ~/.vim/config/plug-lsp.vim
" ========================
" compat 加载后配置
" 功能：兼容性配置以及优化
" ========================

" 确保只加载一次
if exists('g:config_load_compat')
    finish
endif
let g:config_load_compat = 1

" ========================
" 目录兼容性
" ========================

let config_dir = has('win32') ? '$HOME/vimfiles' : '~/.vim'
let plugin_path = expand(config_dir . '/plugins')
" coc config 路径
let $COC_CONFIG_HOME = 'D:\configs\coc'

" ========================
" 文件编码兼容
" ========================

" 强制统一换行格式
set fileformat=unix
set fileformats=unix,dos

" ======================== ======================== ========================
" 兼容 coc 前加载 
" 这里必须在coc.nvim 前加载
" ======================== ======================== ========================

" 设置 cocconfig 路径
let g:coc_config_home = expand('~/.vim')
" 设置 coc.nvim 的 Go 专用配置（替代 coc-settings.json）
" - command: gopls 路径（自动从 PATH 查找）
" - rootPatterns: 识别项目根目录的标记文件
" - initializationOptions: gopls 专属配置
let g:coc_user_config = {
  \ "languageserver": {
  \   "golang": {
  \     "command": "gopls",
  \     "rootPatterns": ["go.mod", ".git/"],
  \     "filetypes": ["go"],
  \     "initializationOptions": {
  \       "build.experimentalWorkspaceModule": v:true,
  \       "analyses": {
  \         "unusedparams": v:true,
  \         "unusedwrite": v:false
  \       }
  \     }
  \   }
  \ },
  \ "go.goplsOptions": {
  \   "staticcheck": v:true,
  \   "completeUnimported": v:true
  \ }
\ }
" ======================== ======================== ========================
" ======================== ======================== ========================