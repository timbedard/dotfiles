scriptencoding utf-8
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
let $DATA_DIR = expand('$XDG_DATA_HOME/nvim')  " ~/.local/share/nvim

"----------------------------------- Python ----------------------------------"
set pyxversion=3

"-------------------------------- The Basics ---------------------------------"
let g:mapleader=' '

" TODO: find out what this breaks
" set autochdir  " automatically set working directory

if executable('fish')
  set shell=fish  " only needed for vim
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

" TODO: find out why the setting doesn't stick unless in an autocmd
set list
augroup set_listchars
  autocmd VimEnter * :set listchars=tab:→\ ,extends:›,precedes:‹,nbsp:·,trail:·
augroup END

set foldlevel=99  " for SimplyFold

"----------------------------- Line Numbers, Etc -----------------------------"
set number relativenumber

augroup number_toggle
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

set noshowmode  " hide the mode (airline will show instead)

set termguicolors  " true color support
let $NVIM_TERM = 1

set guioptions=  " remove scrollbars, etc

set cursorline
" set lazyredraw  " causes flickering

set background=dark

augroup win_resize
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

" fix italics with tmux
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

"-------------------------------- Navigation ---------------------------------"
set mouse=a  " let the mouse wheel scroll page, etc

"---------------------------------- Editing ----------------------------------"
set viewoptions-=options  " keep from saving cur dir in view

set clipboard=unnamed  " yank to system clipboard

set completeopt-=preview  " preview in a buffer?! No.

set nojoinspaces  " only insert one space after punction when joining lines

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

"--------------------------------- Navigation --------------------------------"
" faster exiting from insert mode (-noremap to allow for abbrevs to work)
imap jj <Esc>
" TODO: find out why <C-i> doesn't work
inoremap <C-i> <Esc>
inoremap <C-l> <Esc>

" faster exiting from terminal mode
tnoremap kk <C-\><C-n>

" faster command entry
nnoremap ; :
xnoremap ; :
" but still keep the ; functionality
" nnoremap : ;
" xnoremap : ;

" nav to begin and end of line (rather than buffer) with H/L
nnoremap H ^
nnoremap L $

" buffer switching similar to Vimium (Shift + j/k)
nnoremap K :bn<CR>
nnoremap J :bp<CR>
xnoremap K :bn<CR>
xnoremap J :bp<CR>

" tab switching (Ctrl + Tab)
noremap  <C-Tab>  :tabnext<CR>
inoremap <C-Tab>  <C-O>:tabnext<CR>
noremap  <M-Tab>  :tabprev<CR>
inoremap <M-Tab>  <C-O>:tabprev<CR>

"---------------------------------- Editing ----------------------------------"
" redo
nnoremap U <C-R>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" insert a single character  TODO: make repeatable
nnoremap  <leader>i i<Space><Esc>r
nnoremap  <leader>a a<Space><Esc>r

"--- some brilliant line movement mappings from junegunn ---"
" move current line up/down
nnoremap <silent> <M-k> :move-2<CR>
nnoremap <silent> <M-j> :move+<CR>
"indent/outdent current line
nnoremap <silent> <M-h> <<
nnoremap <silent> <M-l> >>
" move selection up/down
xnoremap <silent> <M-k> :move-2<CR>gv
xnoremap <silent> <M-j> :move'>+<CR>gv
" indent/outdent selection (and keep selection)
xnoremap <silent> <M-h> <gv
xnoremap <silent> <M-l> >gv
xnoremap < <gv
xnoremap > >gv

"-------------------------------- Completion ---------------------------------"
" <CR> to select completion (must be double quotes!)
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"-----------------------------------------------------------------------------"
"                                   Plugins                                   "
"-----------------------------------------------------------------------------"
"----------------------------- Install vim-plug ------------------------------"
let $PLUG_LOC = expand('$DATA_DIR/site/autoload/plug.vim')
if empty(glob($PLUG_LOC))
  silent !curl -fLo $PLUG_LOC --create-dirs
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  augroup auto_pluginstall
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | UpdateRemotePlugins
  augroup END
endif

let $PLUGGED = expand('$DATA_DIR/site/plugged')

"------------------------------ Install Plugins ------------------------------"
filetype off
call plug#begin($PLUGGED)
" /----------------------------- Start Plugins ------------------------------\
" Note: On-demand loading breaks the conditional config approach,
" so the options are:
" 1) on-demand load, unconditional config
" 2) always load, conditional config

Plug 'junegunn/vim-plug'  " add docs

" ----------- GUI -----------
Plug 'gruvbox-community/gruvbox'  " excellent theme
Plug 'vim-airline/vim-airline'  " adds metadata at the bottom
Plug 'vim-airline/vim-airline-themes'  " themes for airline
Plug 'justinmk/vim-dirvish'  " file browser
Plug 'romainl/vim-cool'  " nohls after searching
Plug 'Yggdroot/indentLine'  " nice indentation lines (mucks with conceal, maybe JSON)
" Plug 'liuchengxu/vim-which-key'  " show maps TODO: fix map breaking gq

" ---------- Tags -----------
if executable('ctags')
  Plug 'ludovicchabant/vim-gutentags'  " manages tag files
  Plug 'majutsushi/tagbar'  " neat tag nav UI
endif

" ------ Fuzzy Search -------
if executable('fzf')
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
endif

" --------- Motion ----------
" Plug 'christoomey/vim-tmux-navigator'  " tmux nav integration
Plug 'sunaku/tmux-navigate'  " tmux nav integration
" TODO: adjust mappings to support this
" Plug 'RyanMillerC/better-vim-tmux-resizer'  " resizing like vim-tmux-navigator
" Plug 'easymotion/vim-easymotion'  " fast finding tool TODO: not working, investigate
Plug 'kshenoy/vim-signature'  " show marks in the sign column
Plug 'tpope/vim-unimpaired'  " handy ]x/[x mappings
Plug 'unblevable/quick-scope'  " highlight unique letters in words for f/t

" --------- Editing ---------
Plug 'ntpeters/vim-better-whitespace'  " better whitespace stripping
" Plug 'zhimsel/vim-stay'  " persist editing state when switching buffers, etc
Plug 'farmergreg/vim-lastplace'  " remember cursor position
" Plug 'cometsong/CommentFrame.vim'  " fancy comment title frame generator TODO: set up
Plug 'tpope/vim-commentary'  " commenting shortcuts
Plug 'tpope/vim-eunuch'  " unix cmds (Move, Delete, etc)
Plug 'tpope/vim-surround'  " quoting, etc
Plug 'tpope/vim-repeat'  " repeat supported plugin maps
Plug 'tpope/vim-abolish'  " abbreviation, substitution, coercion
Plug 'wellle/targets.vim'  " next/last surround pair text object
Plug 'michaeljsmith/vim-indent-object'  " [i]ndentation level text object
Plug 'kana/vim-textobj-user'  " user-created text objects
Plug 'kana/vim-textobj-line'  " [l]ine text object
Plug 'terryma/vim-expand-region'  " expand visual selection
" Plug 'Valloric/MatchTagAlways'  " show matching tags TODO: fix bugging out
Plug 'jiangmiao/auto-pairs'  " insert closing quotes, parens, etc
Plug 'junegunn/vim-peekaboo'  " show preview of registers
Plug 'junegunn/vim-easy-align'  " line stuff up with ga motion
Plug 'AndrewRadev/splitjoin.vim'  " single-line <-> multi-line
Plug 'AndrewRadev/switch.vim'  " true <-> false, etc with gs
Plug 'AndrewRadev/sideways.vim'  " swap arguments with SidewaysLeft/SidewaysRight
Plug 'stefandtw/quickfix-reflector.vim'  " editable quickfix
Plug 'kkoomen/vim-doge'  " generate docs with with <leader>d, TODO: broken for js

" ----------- Git -----------
Plug 'tpope/vim-fugitive'  " the defacto git standard
Plug 'tpope/vim-rhubarb'  " GitHub support for fugitive
Plug 'junegunn/gv.vim'  " badass commit browser
" Plug 'sodapopcan/vim-twiggy'  " branch manager TODO: busted, solve

Plug 'mhinz/vim-signify'  " scm gutter signs
Plug 'APZelos/blamer.nvim'  " inline blame (virtual text)
Plug 'rhysd/git-messenger.vim'  " popup commit message for cursor (:GitMessenger)

" --------- Testing ---------
Plug 'janko-m/vim-test'
Plug 'junegunn/vader.vim'

" --------- Environments ---------
Plug 'timbedard/vim-envelop'  " virtualenv management

" ----- Language/Syntax -----
" General "
let g:polyglot_disabled = ['helm']  " must be before plugin is loaded
Plug 'sheerun/vim-polyglot'  " a ton of language support
Plug 'tpope/vim-sleuth'  " detect shiftwidth and expandtab automagically
Plug 'Konfekt/FastFold'  " more intuitive folding
Plug 'pseewald/vim-anyfold'  " faster folding by ignoring manual folding TODO: check perf
Plug 'pierreglaser/folding-nvim'  " lua-based LSP folding

" Treesitter "
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'romgrk/nvim-treesitter-context'  " show current scope context at top
" Plug 'nvim-treesitter/nvim-treesitter-refactor'
" Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" XML/HTML "
" Plug 'alvan/vim-closetag'  " auto-close XML tags <- adds flicker

" CSS "
Plug 'hail2u/vim-css3-syntax'
Plug 'RRethy/vim-hexokinase', {'do': 'make hexokinase'}  " show hex/rgba colors

" Python "
" Plug 'tmhedberg/simpylfold'  " python folding TODO: test if needed anymore
Plug 'raimon49/requirements.txt.vim'  " syntax highlighting for requirements.txt

" Misc "
Plug 'tmux-plugins/vim-tmux'  " tmux.conf syntax
" Plug 'sophacles/vim-bundle-mako'  " mako template (while polyglot detection broken)
Plug 'tpope/vim-liquid'  " jekyll templates

" --------- Linting ---------
Plug 'sbdchd/neoformat'  " formatting

" ------- Completion --------
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
" Plug 'sumneko/lua-language-server', {
"   \ 'do': 'cd 3rd/luamake && ninja -f ninja/macos.ninja && cd ../.. &&  ./3rd/luamake/luamake rebuild'
"   \ }

" -------- Snippets ---------
" Plug 'mattn/emmet-vim'  " fast HTML pseudo-coding TODO: better mapping

" ---------- Notes ----------
Plug 'vimwiki/vimwiki', {'branch': 'dev'}  " TODO: ditch

" --------- Preview ---------
Plug 'iamcco/markdown-preview.nvim', {'do': ':call mkdp#util#install()'}

" --------- Writing ---------
Plug 'junegunn/goyo.vim'  " no-distractions editing
Plug 'junegunn/limelight.vim'  " highlight current block

" --------- Misc ---------
Plug 'ChristianChiarulli/codi.vim'  " inline REPL eval

" wants to always be loaded last
Plug 'ryanoasis/vim-devicons'  " fancy Nerd Font icons

" \------------------------------ End Plugins -------------------------------/

call plug#end()

if has('autocmd')
  filetype plugin indent on
endif


"----------------------------- Configure Plugins -----------------------------"

" --- airline ---
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''

" --- blamer.nvim ---
if &runtimepath =~? 'blamer.nvim'
  nnoremap <Leader>b :BlamerToggle<CR>
  vnoremap <Leader>b :BlamerToggle<CR>
  let g:blamer_delay = 0
  let g:blamer_template = '<author>, <committer-time> • <summary>'
endif

" --- EasyMotion ---
if &runtimepath =~? 'vim-easymotion'
  noremap \ <Plug>(easymotion-prefix)

  " <Leader>f{char} to move to {char}
  noremap  <Leader>f <Plug>(easymotion-bd-f)
  nnoremap <Leader>f <Plug>(easymotion-overwin-f)
endif

" --- Emmet ---
" default is <C-Y>  " TODO: find a better mapping
let g:user_emmet_leader_key=','
let g:user_emmet_install_global = 1

" --- fzf ---
if &runtimepath =~? 'fzf.vim'
  augroup hide_fzf_statusline
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noruler
      \| autocmd BufLeave <buffer> set laststatus=2 ruler
  augroup END

  " mappings
  nnoremap <C-f> :BLines<CR>
  nnoremap <C-b> :Buffers<CR>
  nnoremap <C-c> :Commands<CR>

  " show files in a git project root (or current dir if not project)
  command! ProjectFiles execute 'Files' FindGitRoot()
  nnoremap <C-p> :ProjectFiles<CR>

  " don't highlight the current line and selection column
  let g:fzf_colors = {'bg+': ['bg', 'Normal']}
endif

" --- Goyo ---
let g:goyo_width = 100
let g:goyo_height = '100%'

"- from junegunn ---
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1

function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
  Limelight
  let &l:statusline = '%M'
  highlight StatusLine ctermfg=red guifg=red cterm=NONE gui=NONE
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  Limelight!
endfunction

augroup goyo_enter_leave
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

nnoremap <Leader>G :Goyo<CR>
"- end from junegunn ---

" --- gruvbox ---
if &runtimepath =~? 'plugged/gruvbox'
  let g:airline_theme='gruvbox'
  let g:gruvbox_italic = 1
  let g:gruvbox_sign_column = 'bg0'

  colorscheme gruvbox  " must come after gruvbox_italic

  " match the fold column colors to the line number column
  " must come after colorscheme gruvbox
  highlight clear FoldColumn
  highlight! link FoldColumn LineNr
endif

" --- Gutentags ---
let g:gutentags_cache_dir = expand('$DATA_DIR/tags')
let g:gutentags_exclude_filetypes = [
  \ 'cfg',
  \ 'dosini',
  \ 'envrc',
  \ 'git',
  \ 'gitcommit',
  \ 'gitconfig',
  \ 'gitrebase',
  \ 'gitsendemail',
  \ 'yaml',
  \ ]

" --- hexokinase ---
let g:Hexokinase_ftEnabled = ['css', 'less', 'scss', 'xml']

" --- indentLine ---
let g:indentLine_char = '│'
let g:indentLine_bufTypeExclude = ['help', 'terminal']
let g:indentLine_fileTypeExclude = ['text', 'markdown']

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

" --- Neoformat ---
if &runtimepath =~? 'neoformat'
  let g:neoformat_mysql_sqlformat = {
    \ 'exe': 'sqlformat',
    \ 'args': ['--reindent', '-'],
    \ 'stdin': 1,
    \ }
  let g:neoformat_enabled_mysql = ['sqlformat']

  command! Fix Neoformat
  " nmap <silent> gf :Neoformat<CR>
endif

" --- vim-quickscope --- "
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" --- vim-envelop --- "
let g:envelop_enabled = ['lua', 'node', 'python3']
let g:envelop_lua_packages = [
  \ 'lua-lsp',
  \ 'luaformatter',
  \ ]
let g:envelop_lua_link = [
  \ 'luaformatter',
  \ 'lua_modules/bin/lua-format',
  \ ]
let g:envelop_node_link = [
  \ 'node_modules/.bin/bash-language-server',
  \ 'node_modules/.bin/css-languageserver',
  \ 'node_modules/.bin/docker-langserver',
  \ 'node_modules/.bin/eslint',
  \ 'node_modules/.bin/html-languageserver',
  \ 'node_modules/.bin/prettier',
  \ 'node_modules/.bin/typescript-language-server',
  \ 'node_modules/.bin/vim-language-server',
  \ 'node_modules/.bin/vscode-json-languageserver',
  \ 'node_modules/.bin/yaml-language-server',
  \ ]
  " \ 'node_modules/.bin/sql-language-server',
  " \ 'node_modules/.bin/stylelint',
let g:envelop_node_packages = [
  \ 'bash-language-server',
  \ 'dockerfile-language-server-nodejs',
  \ 'eslint',
  \ 'neovim',
  \ 'prettier',
  \ 'typescript-language-server',
  \ 'vim-language-server',
  \ 'vscode-css-languageserver-bin',
  \ 'vscode-html-languageserver-bin',
  \ 'vscode-json-languageserver',
  \ 'yaml-language-server',
  \ ]
  " \ 'sql-language-server',
  " \ 'stylelint',
  " \ 'stylelint-config-standard',
let g:envelop_python3_link = [
  \ 'bin/black',
  \ 'bin/flake8',
  \ 'bin/isort',
  \ 'bin/pip3',
  \ 'bin/pyls',
  \ 'bin/python3',
  \ 'bin/sqlformat',
  \ 'bin/vint',
  \ ]
let g:envelop_python3_packages = [
  \ 'black',
  \ 'flake8',
  \ 'flake8-bugbear',
  \ 'isort',
  \ 'pep8-naming',
  \ 'pip',
  \ 'pyls-black',
  \ 'pyls-isort',
  \ 'pynvim',
  \ 'python-language-server[all]',
  \ 'sqlparse',
  \ 'vim-vint',
  \ ]

" --- nvim-lsp ---
if &runtimepath =~? 'nvim-lsp'
  lua require'init'.setup_nvim_lsp()

  nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
  " nnoremap <silent> gd <cmd>lua vim.lsp.buf.declaration()<CR>
  " nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
  " nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
  " nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent> 1gD <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
  " nnoremap <silent> g0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> gf <cmd>lua vim.lsp.buf.formatting()<CR>

  " --- completion-nvim ---
  let g:completion_enable_auto_signature = 0  " crazy slow

  set completeopt=menuone,noinsert,noselect
  set shortmess+=c
  " let g:completion_enable_auto_popup = 0

  let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'snippet', 'path']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'},
    \]

  " check previous cols
  function! s:check_behind() abort
    function! s:col_is_space(col)
      return a:col && getline('.')[a:col - 1] =~# '\s'
    endfunction
    let prev = col('.') - 1
    return !prev || s:col_is_space(prev) && s:col_is_space(prev - 1)
  endfunction

  " <TAB>/<S-TAB> through completeopts
  inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_behind() ? "\<TAB>" :
    \ completion#trigger_completion()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  " prevent completion-nvim from conflicting with auto-pairs
  let g:completion_confirm_key = ""
  inoremap <expr> <CR> pumvisible() ? "\<Plug>(completion_confirm_completion)" : "\<CR>"

  " --- diagnostic-nvim ---
  let g:diagnostic_insert_delay = 1
  let g:diagnostic_enable_virtual_text = 1
  let g:diagnostic_virtual_text_prefix = ''

  " sign define LspDiagnosticsErrorSign text=✖
  " sign define LspDiagnosticsWarningSign text=
  " sign define LspDiagnosticsInformationSign text=➤
  sign define LspDiagnosticsErrorSign text=
  sign define LspDiagnosticsWarningSign text=
  sign define LspDiagnosticsInformationSign text=
  sign define LspDiagnosticsHintSign text=➤
endif

" --- nvim-treesitter ---
if &runtimepath =~? 'nvim-treesitter'
  lua require'init'.setup_nvim_treesitter()
endif

" --- SimplyFold ---
let g:SimpylFold_docstring_preview = 1

" --- Tagbar ---
if &runtimepath =~? 'tagbar'
  nnoremap <leader>t :TagbarToggle<CR>
endif

" --- Vimwiki ---
if &runtimepath =~? 'fzf.vim'
  " going for maximum GitHub compatibility here
  let g:vimwiki_list = [
    \ {
      \ 'path': '~/.vimwiki',
      \ 'syntax': 'markdown', 'ext': '.md',
      \ 'auto_diary_index': 1,
      \ 'automatic_nested_syntaxes': 1,
      \ 'index': 'home',
      \ 'links_space_char': '-'
      \ },
    \ {
      \ 'path': '~/.vimwiki-personal',
      \ 'syntax': 'markdown', 'ext': '.md',
      \ 'auto_diary_index': 1,
      \ 'automatic_nested_syntaxes': 1,
      \ 'index': 'home',
      \ 'links_space_char': '-'
      \ }
    \ ]
  let g:vimwiki_global_ext = 0
  let g:vimwiki_auto_chdir = 1
  let g:vimwiki_hl_headers = 1
  " let g:vimwiki_folding = 'syntax:quick'  " not working
  " let g:vimwiki_listsyms = ' ○◐●✓'

  command! Wiki :Files ~/.vimwiki
endif

" --- vim-anyfold ---
if &runtimepath =~? 'vim-anyfold'
  let g:anyfold_motion = 0
  augroup anyfold_activate
    autocmd! Filetype * AnyFoldActivate
  augroup END
endif

" --- vim-better-whitespace ---
if &runtimepath =~? 'vim-better-whitespace'
  let g:better_whitespace_enabled = 0
  let g:strip_whitelines_at_eof = 1
  command! Trim StripWhitespace
endif

" --- vim-devicons ---
let g:webdevicons_enable_ctrlp = 1

" --- vim-easy-align ---
if &runtimepath =~? 'vim-easy-align'
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
endif

" --- vim-expand-region ---
if &runtimepath =~? 'vim-expand-region'
  vmap v <Plug>(expand_region_expand)
  vmap <M-v> <Plug>(expand_region_shrink)
  let g:expand_region_text_objects = {
    \ 'i_'  :0,
    \ 'i-'  :0,
    \ 'iw'  :0,
    \ 'iW'  :0,
    \ 'i"'  :0,
    \ 'i''' :0,
    \ 'i]'  :1,
    \ 'ib'  :1,
    \ 'iB'  :1,
    \ 'il'  :0,
    \ 'V'   :0,
    \ 'ip'  :0,
    \ 'ie'  :0,
    \ }
endif

" --- vim-javascript (polyglot) ---
let g:javascript_plugin_jsdoc = 1

" --- vim-markdown (polyglot) ---
let g:vim_markdown_new_list_item_indent = 2

" --- vim-signature ---
let g:SignatureMarkTextHLDynamic = 1

" --- vim-signify ---
if &runtimepath =~? 'vim-signify'
  set signcolumn=yes
  let g:signify_priority = 0

  let g:signify_sign_add = ''
  let g:signify_sign_delete = ''
  let g:signify_sign_delete_first_line = ''
  let g:signify_sign_change = ''

  " let g:signify_sign_change = '~'
  highlight! link SignifySignChange GruvboxBlueSign

  " nifty hunk motions
  omap ic <Plug>(signify-motion-inner-pending)
  xmap ic <Plug>(signify-motion-inner-visual)
  omap ac <Plug>(signify-motion-outer-pending)
  xmap ac <Plug>(signify-motion-outer-visual)
endif

" --- vim-which-key ---
if &runtimepath =~? 'vim-which-key'
  set timeoutlen=500

  nnoremap <silent> g :<c-u>WhichKey 'g'<CR>
  nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

  " hide the statusline for vim-which-key buffers
  augroup which_key_hide_statusline
    autocmd! FileType which_key
    autocmd  FileType which_key set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  augroup END

  let g:which_key_fallback_to_native_key=1
  let g:which_key_use_floating_win = 0
  " highlight default link WhichKeyFloating  Normal

  let g:which_key_map_g = {
    \ 'name' : '+g' ,
    \ '%' : ['g%', 'matchit-backward'],
    \ 'a' : ['ga', 'easy-align'],
    \ 'c' : ['gc', 'comment'],
    \ 'cc' : ['gcc', 'comment-line'],
    \ 'd' : ['gd', 'lsp-definition'],
    \ 'D' : ['gD', 'lsp-implementation'],
    \ 'f' : ['gf', 'lsp-format'],
    \ 'J' : ['gJ', 'join'],
    \ 'r' : ['gr', 'lsp-references'],
    \ 'S' : ['gS', 'split'],
    \ 'x' : ['gx', 'which_key_ignore'],
    \ }
  call which_key#register('g', 'g:which_key_map_g')

  let g:which_key_map_space = {
    \ 'name' : '+<space>' ,
    \ 'a' : ['<Space>a', 'append-char'],
    \ 'b' : ['<Space>b', 'blamer-toggle'],
    \ 'd' : ['<Space>d', 'generate-docs'],
    \ 'G' : ['<Space>G', 'Goyo'],
    \ 'g' : ['<Space>g', 'which_key_ignore'],
    \ 'i' : ['<Space>i', 'insert-char'],
    \ 'l' : ['<Space>l', 'Limelight'],
    \ 't' : ['<Space>t', 'tagbar-toggle'],
    \ }
  let g:which_key_map_space.w = {
    \ 'name' : '+wiki' ,
    \ }
  call which_key#register('<Space>', 'g:which_key_map_space')
endif
