"==============================================================
" config/ui/statusline.vim
" 状态栏配置：vim-airline 与相关插件集成
"==============================================================

if exists('g:loaded_statusline_config')
  finish
endif
let g:loaded_statusline_config = 1

"==============================================================
" 0. Vista 扩展配置（必须在 vim-airline 加载前设置）
"==============================================================
" 确保 Vista 扩展被禁用（已在 .vimrc 中设置，这里再次确认）
let g:airline#extensions#vista#enabled = 0

" 仅在 vim-airline 已加载时配置
if !exists(':AirlineRefresh')
  finish
endif

"==============================================================
" 1. Airline 基础配置
"==============================================================
let g:airline#extensions#tabline#enabled = 1          " 启用标签栏（显示所有 buffer）
let g:airline#extensions#tabline#formatter = 'unique_tail' " 标签栏显示文件名（不含路径）
let g:airline#extensions#tabline#buffer_nr_show = 0   " 不显示 buffer 编号
let g:airline_powerline_fonts = 1                     " 使用 Powerline 字体（如果已安装）

"==============================================================
" 2. 插件集成
"==============================================================
" coc.nvim 集成（显示 LSP 状态和诊断信息）
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#coc#error_symbol = 'E:'
let g:airline#extensions#coc#warning_symbol = 'W:'
let g:airline#extensions#coc#show_line_numbers = 0

" vim-fugitive 集成（显示 Git 分支和状态）
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#vcs_priority = ['git', 'mercurial']

" fzf 集成（在 fzf 窗口中禁用 airline）
let g:airline#extensions#fzf#enabled = 0

"==============================================================
" 3. 主题配置
"==============================================================
" vim-airline-themes 所有可用主题列表（按分类）：
"
" 【基础主题】
"   dark, light, simple, term, term_light, transparent
"
" 【经典配色】
"   molokai, solarized, solarized_flood, zenburn, wombat, seoul256
"   tomorrow, jellybeans, distinguished, lucius, peaksea, desertink
"
" 【现代风格】
"   onedark, nord-minimal, papercolor, gruvbox (需 base16_gruvbox_*)
"   ayu_dark, ayu_light, ayu_mirage, night_owl, cobalt2
"
" 【极简风格】
"   minimalist, dark_minimal, understated, lessnoise, monochrome
"
" 【彩色主题】
"   bubblegum, blood_red, fruit_punch, cyberpunk, cool, jet
"   violet, silver, serene, raven, ravenpower, supernova
"
" 【特殊风格】
"   powerlineish, hybrid, hybridline, kalisi, kolor, luna
"   murmur, ouo, owo, qwq, behelit, biogoo, durant
"
" 【Google 风格】
"   google_dark, google_light
"
" 【Base16 系列（共 150+ 个主题）】
"   基础：base16, base16_vim, base16_shell, base16color
"   经典：base16_solarized, base16_tomorrow, base16_tomorrow_night
"   Gruvbox：base16_gruvbox_dark_*, base16_gruvbox_light_*
"   Material：base16_material, base16_material_darker, base16_material_lighter
"   Nord：base16_nord
"   Dracula：base16_dracula
"   OneDark：base16_onedark
"   PaperColor：base16_papercolor_dark, base16_papercolor_light
"   其他：base16_3024, base16_adwaita, base16_apathy, base16_ashes
"         base16_atelier_*, base16_atlas, base16_bespin, base16_black_metal_*
"         base16_brewer, base16_bright, base16_brogrammer, base16_brushtrees
"         base16_chalk, base16_circus, base16_classic, base16_codeschool
"         base16_colors, base16_cupcake, base16_cupertino, base16_darktooth
"         base16_decaf, base16_default, base16_edge_*, base16_eighties
"         base16_embers, base16_espresso, base16_flat, base16_framer
"         base16_fruit_soda, base16_gigavolt, base16_github, base16_google_*
"         base16_grayscale_*, base16_greenscreen, base16_harmonic_*
"         base16_heetch_*, base16_helios, base16_hopscotch, base16_horizon_*
"         base16_ia_*, base16_icy, base16_irblack, base16_isotope
"         base16_londontube, base16_macintosh, base16_marrakesh
"         base16_materia, base16_mellow_purple, base16_mexico_light
"         base16_mocha, base16_monokai, base16_nova, base16_ocean
"         base16_oceanicnext, base16_one_light, base16_outrun_dark
"         base16_paraiso, base16_phd, base16_pico, base16_pop
"         base16_porple, base16_railscasts, base16_rebecca
"         base16_sandcastle, base16_seti, base16_shapeshifter
"         base16_snazzy, base16_solarflare, base16_spacemacs
"         base16_summerfruit_*, base16_synth_midnight_dark
"         base16_tube, base16_twilight, base16_unikitty_*
"         base16_woodland, base16_xcode_dusk
"
" 【其他主题】
"   alduin, angr, apprentice, atomic, badwolf, deus, faryfloss
"   jay, laederon, lighthaus, seagull, selenized, selenized_bw
"   sierra, soda, sol, ubaryd, xtermlight
"
" 使用方法：
"   1. 在 Vim 中切换：:AirlineTheme <theme_name>
"   2. 在配置中设置：let g:airline_theme = '<theme_name>'
"
" 根据当前主题模式自动选择 airline 主题
" 可通过 g:airline_theme 手动覆盖
if !exists('g:airline_theme')
  if exists('g:theme_mode')
    if g:theme_mode ==# 'day' || (g:theme_mode ==# 'auto' && str2nr(strftime('%H')) >= 7 && str2nr(strftime('%H')) < 19)
      let g:airline_theme = 'papercolor'        " 白天主题（或使用 light, ayu_light, base16_papercolor_light 等）
    else
      let g:airline_theme = 'base16_gruvbox_dark_soft'  " 夜间主题（或使用 dark, onedark, base16_onedark 等）
    endif
  else
    let g:airline_theme = 'dark'          " 默认暗色主题
  endif
endif

"==============================================================
" 4. 自定义组件（可选）
"==============================================================
" 如果需要自定义状态栏组件，可在此添加
" 示例：显示当前函数名（需要 LSP 支持）
" function! AirlineInit()
"   let g:airline_section_b = airline#section#create(['branch', ' ', '%{get(b:,"coc_current_function","")}'])
" endfunction
" autocmd User AirlineAfterInit call AirlineInit()

"==============================================================
" 5. 自动刷新
"==============================================================
" 当 coc 状态改变时自动刷新状态栏
if exists('*coc#status')
  autocmd User CocStatusChange,CocDiagnosticChange call airline#refresh()
endif


