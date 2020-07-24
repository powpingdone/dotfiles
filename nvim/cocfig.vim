" Configuration related to coc.vim
set cmdheight=2 " Make bigger command zone
set shortmess+=c " 'Don't pass messages to |ins-completion-menu|', whatever that means
set updatetime=500 " Wait time before giving suggestions
set signcolumn=yes " Don't cause a earthquake when typing
autocmd CursorHold * silent call CocActionAsync('highlight') " Highlight definitions/usage of a symbol
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Autocomplete 
" Use TAB to autocomplete 
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Navigation
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> ge <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Rename current symbol
nmap <F2> <Plug>(coc-rename)

