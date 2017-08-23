set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'       " auto indentation for python
Plugin 'Valloric/YouCompleteMe'             " auto complete
Plugin 'scrooloose/syntastic'				" syntax checking/highlighting
Plugin 'nvie/vim-flake8'					" pep8 checking
Plugin 'jnurmine/Zenburn'					" color scheme for terminal mode
Plugin 'altercation/vim-colors-solarized'	" color scheme for GUI mode
Plugin 'scrooloose/nerdtree'				" file browsing
Plugin 'jistr/vim-nerdtree-tabs'			" file browsing with tabs
Plugin 'kien/ctrlp.vim'						" super searching, press Ctrl-P to enable search
Plugin 'tpope/vim-fugitive'					" git integration
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'} " powerline
Plugin 'jmcantrell/vim-virtualenv'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" enable syntax highlighting
syntax enable

" show line numbers
set number

" set tabs to have 4 spaces
set ts=4

" indent when moving to the next line while writing code
set autoindent

" expand tabs into spaces
set expandtab

" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4

" show a visual line under the cursor's current line
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

" spell checking
set spell spelllang=en_us

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" enable folding
set foldmethod=indent
set foldlevel=99

" enable folding with the spacebar
nnoremap <space> za

" see the docstrings for folded code
let g:SimpylFold_docstring_preview=1

" acess system clipboard
set clipboard=unnamed

" always show status line
set laststatus=2

" automatically remove trailing whitespaces when saving file
autocmd BufWritePre * :%s/\s\+$//e

" warning when over 80 characters
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

""" PYTHON specific
" use python3 as interpreter
let g:pymode_python = 'python3'

" pep8 indentation
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" flagging unnecessary whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" set utf8 support
set encoding=utf-8


" python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  import sys
  import os
  import site

  base = os.path.abspath(os.environ.get('VIRTUAL_ENV'))
  bin_path = os.path.join(base, 'bin')
  old_os_path = os.environ.get('PATH', '')
  os.environ['PATH'] = bin_path + os.pathsep + old_os_path
  site_packages = os.path.join(base, 'lib',
                               'python{}'.format(sys.version[:3]),
                               'site-packages')
  prev_sys_path = list(sys.path)
  site.addsitedir(site_packages)
  sys.real_prefix = sys.prefix
  sys.prefix = base

  # Move the added items to the front of the path:
  new_sys_path = []
  for item in list(sys.path):
      if item not in prev_sys_path:
          new_sys_path.append(item)
          sys.path.remove(item)
  sys.path[:0] = new_sys_path
EOF

" makes your code looks pretty
let python_highlight_all=1
syntax on

" syntastic plugin setup
" let g:syntastic_python_checkers=['python','pylint', 'pep257']
let g:syntastic_check_on_open = 0
let g:syntastic_skip_checks = 1
autocmd VimEnter * SyntasticToggleMode " disable syntastic by default

" color scheme settings
if has('gui_running')
  set background=dark
  colorscheme solarized
else
  colorscheme zenburn
endif

" ignore files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$', '.s*']

" settings for syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" settings for YCompleteMe
let g:ycm_server_python_interpreter = '/usr/bin/python3'
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
