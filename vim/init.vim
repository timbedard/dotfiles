"-----------------------------------------------------------------------------"
"    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    "
"                           Tim Bedard's Vim Config                           "
"    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    "
"-----------------------------------------------------------------------------"

"     "Make for yourself a definition or description of the thing which is
"  presented to you, so as to see distinctly what kind of a thing it is in its
"   substance, in its nudity, in its complete entirety, and tell yourself its
"   proper name, and the names of the things of which it has been compounded,
" and into which it will be resolved. For nothing is so productive of elevation
" of mind as to be able to examine methodically and truly every object that is
"  presented to you in life, and always to look at things so as to see at the
"   same time what kind of universe this is, and what kind of use everything
"  performs in it, and what value everything has with reference to the whole."
"
"                               - Marcus Aurelius, Meditations, iii. 11.

"-----------------------------------------------------------------------------"
"                                   General                                   "
"-----------------------------------------------------------------------------"
"-------------------------------- Directories --------------------------------"
if $XDG_CONFIG_HOME ==? ''
  let $XDG_CONFIG_HOME = expand('$HOME/.config')
endif
let $RUNTIME_DIR = expand('$XDG_CONFIG_HOME/nvim')  " ~/.config/nvim

if $XDG_DATA_HOME ==? ''
  let $XDG_DATA_HOME = expand('$HOME/.local/share')
endif
let $DATA_DIR = $XDG_DATA_HOME . '/nvim'  " ~/.local/share/nvim

"------------------------------ Neovim Defaults ------------------------------"
" If we're not in Neovim, make sure all the defaults are the same.
if !has('nvim')
  runtime! plugin/neovim-defaults.vim
  let &runtimepath.=expand(',$DATA_DIR/site')
endif

"-------------------------------- The Basics ---------------------------------"
let g:mapleader=' '

" TODO: find out what this breaks
set autochdir  " automatically set working directory

if executable('zsh')
  set shell=zsh
endif

set hidden  " switch buffers without saving
set splitbelow
set splitright

if has('autocmd')
  filetype plugin indent on
endif

" prevent delay when changing modes
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=50
endif

" speed up screen updating
set updatetime=100

" persistent undo
if has('persistent_undo')
  set undofile
endif

" no netrwhist
let g:netrw_dirhistmax = 0

"---------------------------- Tabs & Indentation -----------------------------"
set smartindent
set expandtab  " tab inserts spaces

" Wrap a line around visually if it's too long.
set wrap
set linebreak
set textwidth=0
set wrapmargin=0

"----------------------------- Line Numbers, Etc -----------------------------"
set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"--------------------------------- Searching ---------------------------------"
set ignorecase smartcase

set wildmode=longest:full,full
set wildignore+=*/tmp/*,/var/*,*.so,*.swp,*.zip,*.tar,*.pyc  " macOS/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe                  " Windows

set path+=**  " add current file location to path

" use rg instead of grep if available
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

"-------------------------------- Appearance ---------------------------------"
if has('syntax')
  syntax enable
endif

set guioptions=  " remove scrollbars, etc

set cursorline
set lazyredraw

set t_Co=256  " terminal colors
set background=dark

augroup winresize
  autocmd!
  autocmd VimResized * wincmd =
augroup END

" start scrolling when near the last line/col
set scrolloff=1
set sidescrolloff=5

" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~? 'iTerm'
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
endif

" Go away, netrw!
augroup hide_netrw
    autocmd FileType netrw setl bufhidden=wipe
augroup END

"-------------------------------- Navigation ---------------------------------"
set mouse=a  " let the mouse wheel scroll page, etc

"---------------------------------- Editing ----------------------------------"
set viewoptions-=options  " keep from saving cur dir in view

" yank to system clipboard
set clipboard=unnamed

set completeopt-=preview  " preview in a buffer?! No.

"--------------------------------- Languages ---------------------------------"
" TODO: find equivalent setting for Vim8
if has('nvim')
  let g:python_host_prog  = 'python2'
  let g:python3_host_prog = 'python3'
endif

"-----------------------------------------------------------------------------"
"                                  Commands                                   "
"-----------------------------------------------------------------------------"
" I'm bad at typing.
:command! Q q
:command! W w
:command! WQ wq
:command! Wq wq

"------------------------------ vimrc Shortcuts ------------------------------"
" shortcut to edit vimrc
cnoreabbrev vr :e $RUNTIME_DIR/init.vim

" reload vimrc
cnoreabbrev vrr :source $MYVIMRC

"-----------------------------------------------------------------------------"
"                                  Mappings                                   "
"-----------------------------------------------------------------------------"
"--------------------------------- Searching ---------------------------------"
" clear search highlighting with <CR>
nnoremap <silent> <CR> :nohlsearch<CR>

" keep the above mapping from interfering with special buffers
augroup nohls_specials
  autocmd!
  " quickfix
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  " command history
  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
augroup END

"--------------------------------- Navigation --------------------------------"
" faster exiting from insert mode
inoremap jj <Esc>

" faster exiting from terminal mode
tnoremap kk <C-\><C-n>

" faster command entry
nnoremap ; :
xnoremap ; :
" but still keep the ; functionality
" nnoremap : ;
" xnoremap : ;

" easier nav in insert mode (Ctrl)
" NOTE: <C-h> doesn't work thanks to <C-h> sending <bs> in most terminals
inoremap <C-k> <C-o>gk
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <C-o>gj

" nav to begin and end of line (rather than buffer) with H/L
nnoremap H ^
nnoremap L $

" buffer switching (Shift + j/k)
nnoremap K :bn<CR>
nnoremap J :bp<CR>
xnoremap K :bn<CR>
xnoremap J :bp<CR>

" window switching (Ctrl)
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" tab switching (Ctrl+Tab)
noremap  <C-Tab>  :tabnext<CR>
inoremap <C-Tab>  <C-O>:tabnext<CR>
noremap  <M-Tab>  :tabprev<CR>
inoremap <M-Tab>  <C-O>:tabprev<CR>

"---------------------------------- Editing ----------------------------------"
" redo
nnoremap U <C-R>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" insert a single character
nnoremap  <leader>i i<Space><Esc>r
nnoremap  <leader>a a<Space><Esc>r

"-------------------------------- Completion ---------------------------------"
" <CR> to select completion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"-----------------------------------------------------------------------------"
"                                   Plugins                                   "
"-----------------------------------------------------------------------------"
"----------------------------- Install vim-plug ------------------------------"
let $PLUG_LOC = expand('$DATA_DIR/site/autoload/plug.vim')
if empty(glob($PLUG_LOC))
  silent !curl -fLo $PLUG_LOC --create-dirs
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  augroup autopluginstall
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | UpdateRemotePlugins
  augroup END
endif

"------------------------------ Install Plugins ------------------------------"
filetype off
call plug#begin('$DATA_DIR/site/plugged')
" /----------------------------- Start Plugins ------------------------------\

" ----------- GUI -----------
Plug 'morhetz/gruvbox'  " excellent theme
Plug 'vim-airline/vim-airline'  " adds metadata at the bottom
Plug 'ryanoasis/vim-devicons'  " fancy Nerd Font icons
Plug 'Yggdroot/indentLine'  " nice indentation lines (mucks with conceal, maybe JSON)
Plug 'benknoble/vim-auto-origami'  " auto-show foldcolumn

" ---------- Tags -----------
if executable('ctags')
  Plug 'ludovicchabant/vim-gutentags'  " manages tag files
  Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }  " neat tag nav UI
endif

" ------ Fuzzy Search -------
if executable('fzf')
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
endif

" --------- Motion ----------
Plug 'easymotion/vim-easymotion'  " fast finding tool
Plug 'rhysd/clever-f.vim'  " fast f/t repetition (instead of ;)

" --------- Editing ---------
Plug 'ntpeters/vim-better-whitespace'  " better whitespace stripping
Plug 'zhimsel/vim-stay'  " persist editing state when switching buffers, etc
Plug 'tpope/vim-eunuch'  " unix cmds (Move, Delete, etc)
Plug 'tpope/vim-commentary'  " commenting shortcuts
Plug 'tpope/vim-surround'  " quoting, etc
Plug 'tpope/vim-repeat'  " repeat supported plugin maps
Plug 'wellle/targets.vim'  " next/last surround pair text object
Plug 'Valloric/MatchTagAlways'  " show matching tags
Plug 'jiangmiao/auto-pairs'  " insert closing quotes, parens, etc
Plug 'junegunn/vim-easy-align'  " line stuff up
Plug 'junegunn/vim-peekaboo'  " show preview of registers

" ----------- Git -----------
Plug 'tpope/vim-fugitive'  " the defacto git standard
Plug 'tpope/vim-rhubarb'  " GitHub support for fugitive
Plug 'airblade/vim-gitgutter'  " way more than just gutter signs
Plug 'junegunn/gv.vim'  " badass commit browser
Plug 'sodapopcan/vim-twiggy'  " branch manager

" ----- Language/Syntax -----
" General "
Plug 'sheerun/vim-polyglot'  " a ton of language support
Plug 'tpope/vim-sleuth'  " detect shiftwidth and expandtab automagically
" Plug 'Konfekt/FastFold'  " faster folding by ignoring manual folding
Plug 'tpope/vim-characterize'  " extend character metadata for `ga`

" CSS "
Plug 'hail2u/vim-css3-syntax'

" Markdown "
Plug 'plasticboy/vim-markdown'  " better markdown

" Python "
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }  " fixes python indent issues
Plug 'tmhedberg/simpylfold', { 'for': 'python' }  " python folding
Plug 'raimon49/requirements.txt.vim'  " syntax highlighting for requirements.txt
Plug 'mindriot101/vim-yapf', { 'for': 'python' }  " python auto-formatting
Plug 'tell-k/vim-autopep8', { 'for': 'python' }  " python auto-formatting
Plug 'ambv/black', { 'for': 'python' }  " python auto-formatting

" Misc "
Plug 'ekalinin/Dockerfile.vim'  " Dockerfile support
Plug 'hashivim/vim-vagrant'  " Vagrant support
Plug 'tpope/vim-liquid'  " jekyll templates

" --------- Linting ---------
Plug 'neomake/neomake'  " linting/building
" Plug 'w0rp/ale'  " linting/building

" ------- Completion --------
if has('nvim')
  Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'Shougo/neco-vim'  " VimL
" TODO: figure out how to check if jedi is installed
Plug 'zchee/deoplete-jedi', { 'for': 'python' }  " python
Plug 'fszymanski/deoplete-emoji'  " deoplete support for emoji

Plug 'ervandew/supertab'  " use tab for insert completions

" -------- Snippets ---------
Plug 'mattn/emmet-vim'  " fast HTML pseudo-coding

" ---------- Notes ----------
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

" --------- Preview ---------
Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }

" --------- Writing ---------
Plug 'junegunn/goyo.vim'  " no-distractions editing
Plug 'junegunn/limelight.vim'  " highlight current block

" \------------------------------ End Plugins -------------------------------/

call plug#end()

if has('autocmd')
  filetype plugin indent on
endif


"----------------------------- Configure Plugins -----------------------------"
" TODO: better titles here

" --- airline ---
if &runtimepath =~? 'vim-airline'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1
  set noshowmode
  if &runtimepath =~? 'vim-airline-themes'
    let g:airline_theme='gruvbox'
  endif
endif

" --- auto-pairs ---
if &runtimepath =~? 'auto-pairs'
  let g:AutoPairsMapSpace = 0
endif

" --- black ---
" avoiding check wrap for now as black doesn't actually get added to runtimepath
" if &runtimepath =~? 'black'
  let g:black_virtualenv = expand('$DATA_DIR/site/venv')
  let g:black_linelength = 88
  let g:black_skip_string_normalization = 1
" endif

" --- deoplete ---
if &runtimepath =~? 'deoplete.nvim'
  call deoplete#enable()
endif

" --- EasyMotion ---
if &runtimepath =~? 'vim-easymotion'
  noremap \ <Plug>(easymotion-prefix)

  " <Leader>f{char} to move to {char}
  noremap  <Leader>f <Plug>(easymotion-bd-f)
  nnoremap <Leader>f <Plug>(easymotion-overwin-f)
endif

" --- Emmet ---
if &runtimepath =~? 'emmet-vim'
  " default is <C-Y>
  " let g:user_emmet_leader_key=','
  let g:user_emmet_install_global=1
endif

" --- fzf ---
if &runtimepath =~? 'fzf.vim'
  augroup hidefzfstatusline
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noruler
      \| autocmd BufLeave <buffer> set laststatus=2 ruler
  augroup END

  " mappings
  nnoremap <C-f> :BLines<CR>
  nnoremap <C-b> :Buffers<CR>

  " show files in a git project root (or current dir if not project)
  command! ProjectFiles execute 'Files' FindGitRoot()
  nnoremap <C-p> :ProjectFiles<CR>
endif

" --- GitGutter ---
if &runtimepath =~? 'vim-gitgutter'
  let g:gitgutter_override_sign_column_highlight = 1
  if exists('&signcolumn')  " Vim 7.4.2201
    set signcolumn=yes
  else
    let g:gitgutter_sign_column_always = 1
  endif
endif

" --- gruvbox ---
if &runtimepath =~? 'gruvbox'
  let g:gruvbox_italic=1
  colorscheme gruvbox
  highlight clear SignColumn
  highlight clear FoldColumn
  hi FoldColumn ctermfg=DarkGrey
endif

" --- Gutentags ---
if &runtimepath =~? 'vim-gutentags'
  let g:gutentags_cache_dir = expand('$DATA_DIR/tags')
endif

" --- indentLine ---
if &runtimepath =~? 'indentLine'
  let g:indentLine_char = '│'
  let g:indentLine_bufTypeExclude = ['help', 'terminal']
  let g:indentLine_fileTypeExclude = ['text', 'markdown']
endif

" --- Instant Markdown ---
if &runtimepath =~? 'vim-instant-markdown'
  let g:instant_markdown_autostart = 0
endif

" --- LimeLight ---
if &runtimepath =~? 'limelight.vim'
  nnoremap <Leader>l <Plug>(Limelight)
  xnoremap <Leader>l <Plug>(Limelight)
  let g:limelight_conceal_ctermfg = 'gray'
  let g:limelight_conceal_guifg = 'DarkGray'
endif

" --- MatchTagAlways ---
if &runtimepath =~? 'MatchTagAlways'
  " Jump to matching tags
  nnoremap <leader>% :MtaJumpToOtherTag<CR>

  let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ 'mako': 1,
    \ 'htmldjango' : 1,
    \ 'liquid': 1,
    \ }
endif

" --- NeoMake ---
if &runtimepath =~? 'neomake'
  " lint when writing a buffer.
  if has('nvim') || v:version >= 800
    call neomake#configure#automake('nrw', 500)
  else
    call neomake#configure#automake('rw')
  endif

  " luacheck (ignore implicit global definitions)
  let g:neomake_lua_luacheck_args = ['--allow-defined', '--no-color',
                                    \'--formatter=plain', '--ranges',
                                    \'--codes', '--filename', '%:p']

  let g:neomake_markdown_markdownlint_maker = {
    \ 'args': ['-r', '~MD022,~MD032'],
    \ 'errorformat': '%f: %l: %m'
    \ }

  " pylint is super noisy, so let's stick to flake8.
  let g:neomake_python_flake8_maker = {
    \ 'args': ['--max-line-length=160', '--format=default'],
    \ 'errorformat':
      \ '%E%f:%l: could not compile,%-Z%p^,' .
      \ '%A%f:%l:%c: %t%n %m,' .
      \ '%A%f:%l: %t%n %m,' .
      \ '%-G%.%#',
      \ 'postprocess': function('neomake#makers#ft#python#Flake8EntryProcess')
    \ }
  let g:neomake_python_enabled_makers = ['flake8']
  let g:neomake_python_flake8_args = ['--max-line-length=160',
                                     \'--format=default']

  let g:neomake_sh_enabled_makers = ['shellcheck']
  let g:neomake_sh_shellcheck_args = ['-x']
endif

" --- vim-polyglot ---
if &runtimepath =~? 'vim-polyglot'
  let b:python_version_2 = 1
  let g:polyglot_disabled = ['markdown']  " polyglot futz up markdown indent
endif

" --- SimplyFold ---
if &runtimepath =~? 'simpylfold'
  let g:SimpylFold_docstring_preview = 1
  set foldlevel=99
endif

" --- SuperTab ---
if &runtimepath =~? 'supertab'
  " Tabbing goes bottom-to-top and for some reason this fixes it.
  let g:SuperTabDefaultCompletionType = '<C-n>'
endif

" --- Tagbar ---
if &runtimepath =~? 'tagbar'
  nnoremap <leader>t :TagbarToggle<CR>
endif

" --- Vimwiki ---
if &runtimepath =~? 'vimwiki'
  let g:vimwiki_list = [{'path': '~/.vimwiki',
                       \ 'syntax': 'markdown', 'ext': '.wiki',
                       \ 'automatic_nested_syntaxes': 1}]
  " disable <tab> mapping provided by vimwiki, which interferes with SuperTab
  let g:vimwiki_table_mappings = 0
endif

" --- vim-auto-origami ---
if &runtimepath =~? 'vim-auto-origami'
  let g:auto_origami_foldcolumn = 3
  augroup autofoldcolumn
    au!
    au CursorHold,BufWinEnter,WinEnter * AutoOrigamiFoldColumn
  augroup END
endif

" --- vim-better-whitespace ---
if &runtimepath =~? 'vim-better-whitespace'
  let g:strip_whitelines_at_eof=1
  cnoreabbrev trim StripWhitespace
endif

" --- vim-devicons ---
if &runtimepath =~? 'vim-devicons'
  let g:webdevicons_enable_ctrlp = 1
endif

" --- vim-easy-align ---
if &runtimepath =~? 'vim-easy-align'
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xnoremap ga <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nnoremap ga <Plug>(EasyAlign)
endif