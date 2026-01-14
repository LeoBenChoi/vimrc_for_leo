" ============================================================================
" 启动时间工具函数
" 文件位置: ~/.vim/autoload/startup_time.vim
" 说明: 提供统一的启动时间计算和格式化函数，供 startify 和 airline 使用
" ============================================================================

" 说明：
" - g:start_time 在 vimrc.vim 最顶部记录（配置加载开始）
" - 如果通过命令行打开文件（如 vim file.txt），文件加载发生在启动页之后
" - 为了包含文件加载时间，我们在 VimEnter 时更新启动时间显示
" - 启动页显示的时间是配置加载完成的时间（约 100ms）
" - 打开文件后，实际启动时间会包含文件加载（约 700ms）

" ============================================================================
" 1. 获取启动时间（毫秒）
" ============================================================================
" 返回启动时间（整数毫秒），如果 g:start_time 不存在则返回 0
function! startup_time#get_ms()
    " 检查 g:start_time 是否存在（在 vimrc.vim 最顶部设置）
    if !exists('g:start_time')
        return 0
    endif

    " 计算耗时
    " reltime() 计算当前时间与 g:start_time 的差值
    " reltimestr() 将其转换为字符串 (例如 "0.123456")
    let l:total_time_str = reltimestr(reltime(g:start_time))
    
    " 将字符串转换为浮点数（秒），然后乘以 1000 得到毫秒
    let l:total_time_ms = str2float(l:total_time_str) * 1000
    
    " 格式化为整数毫秒（去掉小数部分）
    return float2nr(l:total_time_ms)
endfunction

" ============================================================================
" 2. 获取格式化的启动时间字符串（用于 Startify）
" ============================================================================
" 返回格式：'   🚀 Vim started in 89 ms.'
function! startup_time#get_formatted_string()
    let l:time_ms = startup_time#get_ms()
    if l:time_ms == 0
        return ''
    endif
    return '   🚀 Vim started in ' . l:time_ms . ' ms.'
endfunction

" ============================================================================
" 3. 获取格式化的启动时间字符串（用于 Airline）
" ============================================================================
" 返回格式：'🚀 89ms' 或 '🚀 1.234s'（根据时间长度自动选择）
function! startup_time#get_airline_string()
    if !exists('g:start_time')
        return ''
    endif
    
    " 使用 reltimefloat 获取更精确的时间
    let l:elapsed = reltimefloat(reltime(g:start_time))
    if l:elapsed < 0.001
        return ''
    endif
    
    " 格式化时间：如果小于 1 秒，显示毫秒；否则显示秒（保留 3 位小数）
    if l:elapsed < 1.0
        let l:time_str = printf('%dms', float2nr(l:elapsed * 1000))
    else
        let l:time_str = printf('%.3fs', l:elapsed)
    endif
    
    return '🚀 ' . l:time_str
endfunction
