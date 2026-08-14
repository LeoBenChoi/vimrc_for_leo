" ========== 缩进:tab = 4 空格 ==========
setlocal tabstop=4          " 一个 tab 显示为 4 格
setlocal softtabstop=4      " 按 Tab 键实际缩进 4 格
setlocal shiftwidth=4       " >> / << 缩进 4 格
setlocal expandtab          " Tab 转空格(关键!)

" ========== 自动缩进 ==========
setlocal autoindent         " 保持上一行的缩进
setlocal nosmartindent      " 关掉 smartindent(汇编会误判)
setlocal nocindent          " 关掉 cindent(同上)

" ========== 其他优化 ==========
setlocal nowrap             " 汇编一行一条,不折行
setlocal colorcolumn=0      " 汇编行长短不一,不设列标线
