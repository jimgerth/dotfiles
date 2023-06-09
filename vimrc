" PLUGINS {{{
" If needed, install Plug by running
" ```sh
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
" ```
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Dart/Flutter specific plugins.
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

" Install color schemes.
Plug 'arzg/vim-colors-xcode'
Plug 'sainnhe/sonokai'
call plug#end()
" }}} PLUGINS

" SELF HELP {{{
" This is just a collection of useful vim tricks I want to remember.
" - * and # to jump to next/previous occurence of word under cursor
" - <c-i> and <c-o> for navigating In and Out of the jump stack
" }}} SELF HELP

" GENERAL {{{
filetype plugin on
syntax on

" Enable using the mouse for pointing, selecting, etc.
set mouse=a

set incsearch

" Enable default command line completion popup window.
set wildmenu
set wildignorecase
set wildmode=longest:full,full
set wildoptions=fuzzy,pum
set pumheight=25

set number
set relativenumber
" Show signs (e.g. linter warnings indicated by >>) in the number column.
set signcolumn=number

set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent
set smartindent

set wrapmargin=80
set textwidth=80

set noswapfile

" Make search case-insensitive if search term is all lowercase.
set ignorecase
set smartcase

nnoremap j gj
nnoremap k gk

" Quickly write and/or close all buffers.
command W :wall
command Q :qall
command WQ :wqall
" }}} GENERAL

" VIMRC MANAGEMENT {{{
command EditVimrc :tabe $MYVIMRC
command SourceVimrc :source $MYVIMRC
command ERC :tabe $MYVIMRC
command RC :tabe $MYVIMRC
command Config :tabe $MYVIMRC
command SRC :source $MYVIMRC
" Re-source the vimrc file whenever it is saved.
augroup autosource
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup end
" }}} VIMRC MANAGEMENT

" COLORSCHEME {{{
let g:xcodedark_green_comments = 1
let g:xcodedark_match_paren_style = 1
"colorscheme xcodedark

let g:sonokai_better_performance = 1
let g:sonokai_disable_italic_comment=1
let g:sonokai_colors_override={'bg0': ['#1e222a', '234']}
colorscheme sonokai
" }}} COLORSCHEME

" WINDOW MANAGEMENT {{{
" When trying to open a file, that is already opened in another window (which is
" possibly in another tab), into a new window (or tab), abort opening it again
" (i.e. close it again) and jump to the window (or tab) in which it is already
" opened.
function! MaybeOpen() abort
    " The name and window ID of the file that is trying to be newly opened.
    let l:new_name = bufname()
    let l:new_id = win_getid()

    " A list of IDs of the windows with the same name as the new file.
    let l:matched_ids = []
    tabdo
        \ windo
            \ if win_getid() != l:new_id && bufname() ==# l:new_name |
                \ call add(l:matched_ids, win_getid()) |
            \ endif

    if len(l:matched_ids) == 0
        " If there were no matches, leave the new window open and go back to it.
        call win_gotoid(l:new_id)
    else
        " Otherwise, the file is already opened in another window, so close the
        " new window and go to the window with the file already opened in it.
        call win_execute(l:new_id, 'close')
        " FIXME: What to do when the file is alreay opened in mutliple windows?
        " Should this function close all of them but one? What if there are
        " local changes to the buffer in the windows?
        call win_gotoid(l:matched_ids[0])
    endif
endfunction
augroup dontopentwice
    autocmd!
    " Filter out empty path from opening a new, empty tab.
    autocmd BufWinEnter ?* call MaybeOpen()
augroup end

" Tab management.
function! TabPrev() abort
    " TODO: len(expand('%')) only checks for the buffer in the selected window
    " to be empty. Rather, all windows should be checked as in
    " https://stackoverflow.com/questions/5025558/check-if-current-tab-is-empty-in-vim.
    if tabpagenr() == tabpagenr('$') && len(expand('%')) == 0
        tabclose
    else
        tabprev
    endif
endfunction
function! TabNext() abort
    if tabpagenr() == tabpagenr('$')
        if len(expand('%')) == 0
            tabclose
            tabnext
        else
            tabnew
        endif
    else
        tabnext
    endif
endfunction
nnoremap <silent> T         :tabe<cr>
nnoremap <silent> <Left>    :call TabPrev()<cr>
nnoremap <silent> H         :call TabPrev()<cr>
nnoremap <silent> <Right>   :call TabNext()<cr>
nnoremap <silent> L         :call TabNext()<cr>
nnoremap <silent> <S-Left>  :tabm -1<cr>
nnoremap <silent> <C-h>     :tabm -1<cr>
nnoremap <silent> <S-Right> :tabm +1<cr>
nnoremap <silent> <C-l>     :tabm +1<cr>

" Split management.
nnoremap <silent> <C-j> :wincmd j<cr>
nnoremap <silent> <C-k> :wincmd k<cr>
" }}} WINDOW MANAGEMENT

" Enable copying to the system's clipboard in visual mode via CRTL-C.
vnoremap <C-c> "*y

" Wrap visual selection in quotes.
vnoremap " <esc>`>a"<esc>`<i"<esc>
vnoremap ' <esc>`>a'<esc>`<i'<esc>

" Move lines
" nnoremap j ddp
" nnoremap k ddkP

" Shorten the fuzzy file search command.
command F Files

"""" LEADER
set showcmd            " Visually indicate leader key press waiting for command.
let mapleader = ","    " Map the <leader> key to the comma key.
set timeoutlen=500 " Set timeout length to 500 ms

let g:dart_format_on_save = 1
" Configure vim-flutter plugin.
let g:flutter_autoscroll=1
let g:flutter_split_height=8
let g:flutter_close_on_quit=1
nnoremap ff :FlutterRun<cr>
nnoremap fr :FlutterHotReload<cr>
nnoremap fR :FlutterHotRestart<cr>
nnoremap fq :FlutterQuit<cr>

" Remove file encoding section (e.g. utf-8) from status line.
let g:airline_section_y = ''

" QUOTE/PARENS EXPANSION {{{
let g:expandables = [
            \["'", "'"],
            \['"', '"'],
            \['`', '`'],
            \['(', ')'],
            \['{', '}'],
            \['[', ']'],
            \['<', '>']]

function! MaybeInsert(char) abort
    let l:line = getline('.')
    let l:col = col('.') - 1
    return l:line[l:col] != a:char
endfunction

" TODO: When inserting an expandable character and there is text directly to the
" right of it, don't insert the counterpart right there, but rather wrap the
" text until the next whitespace in the expandable pair.
" E.g.: Some |long text -> Some "long|" text (after pressing ")
for expandable in expandables
    let left = expandable[0]
    let right = expandable[1]
    if left == right
        if left == "'"
            execute "inoremap <silent><expr>" left 'MaybeInsert("'.left.'") ? "'.left.left.'<Left>" : "<Right>"'
        else
            execute "inoremap <silent><expr>" left "MaybeInsert('".left."') ? '".left.left."<Left>' : '<Right>'"
        endif
    else
        execute "inoremap" left left.right.'<Left>'
        execute "inoremap <silent><expr>" right "MaybeInsert('".right."') ? '".right."' : '<Right>'"
    endif
endfor

function! CheckNext() abort
  let l:line = getline('.')
  let l:col = col('.') - 1
  let l:left = l:line[col - 1]
  let l:right = l:line[col]
  for expandable in g:expandables
      let expandableleft = expandable[0]
      let expandableright = expandable[1]
      if l:left == expandableleft
          return l:right == expandableright
      endif
  endfor
  return 0
endfunction
inoremap <silent><expr> <BS> CheckNext() ? '<Right><BS><BS>' : '<BS>'
" }}} QUOTE/PARENS EXPANSION

" COCVIM CONFIG {{{
let g:coc_global_extensions = [
    \'coc-flutter'
  \ ]

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience>
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                             \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Remap keys for applying code actions at the cursor position
nmap <leader>a  <Plug>(coc-codeaction-cursor)
" }}} COCVIM CONFIG
