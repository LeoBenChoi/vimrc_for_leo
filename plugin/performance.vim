if exists('g:loaded_performance') || &compatible
  finish
else
  let g:loaded_performance = 'yes'
endif

" 单个缓冲区(Buffer)最大允许使用内存：4GB (单位 KB)
set maxmem=4194304

" 所有缓冲区总内存限制：16GB (单位 KB)
set maxmemtot=16777216

" 虽然 Vim 主要是 CPU 渲染，但 GVim 在 Windows 下支持 DirectX。

if has("gui_running") && has("win32")
    try
        " type:directx : 开启 DX 渲染
        " level:0.75   : 字体抗锯齿强度 (0.5~1.0，推荐 0.75)
        " gamma:1.0    : 伽马校正，让字体看起来更黑更实
        set renderoptions=type:directx,level:0.75,gamma:1.0,contrast:0.5,geek:1
    catch
    endtry
endif

set updatetime=100

set ttyfast          " 告诉 Vim 终端很快
set lazyredraw       " 执行宏时不重绘 (提升脚本执行效率)

" 正则引擎自动选择
set re=0