"==============================================================
" config/ui/theme.vim
" 主题相关：支持昼夜切换，并可扩展
"==============================================================

if exists('g:loaded_theme_config')
  finish
endif
let g:loaded_theme_config = 1

let g:theme_day = get(g:, 'theme_day', '')
let g:theme_night = get(g:, 'theme_night', 'gruvbox')
let g:theme_mode = 'auto'
let s:theme_fallback_day = 'retrobox'
let s:theme_fallback_night = 'retrobox'
let s:theme_default = 'default'

function! s:has_colorscheme(name) abort
  return !empty(globpath(&runtimepath, 'colors/' . a:name . '.vim'))
endfunction

" 主题切换时间
function! s:is_daytime() abort
  let hour = str2nr(strftime('%H'))
  return hour >= 7 && hour < 19
endfunction

function! ToggleThemeMode()
  if g:theme_mode ==# 'day'
    let g:theme_mode = 'night'
  else
    let g:theme_mode = 'day'
  endif
  call s:apply_theme()
endfunction

function! s:apply_theme() abort
  if g:theme_mode ==# 'auto'
    let l:mode = s:is_daytime() ? 'day' : 'night'
  else
    let l:mode = g:theme_mode
  endif
  let &background = l:mode ==# 'day' ? 'light' : 'dark'
  let l:preferred = l:mode ==# 'day' ? g:theme_day : g:theme_night
  let l:fallback = l:mode ==# 'day' ? s:theme_fallback_day : s:theme_fallback_night
  let l:candidates = [l:preferred, l:fallback, s:theme_default]
  for scheme in l:candidates
    if s:has_colorscheme(scheme)
      let l:target = scheme
      break
    endif
  endfor
  execute 'colorscheme ' . l:target
endfunction

call s:apply_theme()

