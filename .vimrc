" plugin vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-surround'
Plugin 'preservim/nerdtree'
Plugin 'preservim/tagbar'
Plugin 'tpope/vim-commentary'
Plugin 'ludovicchabant/vim-gutentags'

call vundle#end()            " required
filetype plugin indent on    " required

" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
" set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> 
" 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
" set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" plugin CtrlP, remap shortcut
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" set autoindent
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" use colorscheme solarized
" let g:solarized_termcolors=256
syntax enable
set background=dark
colorscheme solarized

" show current position
set ruler

" allow copy to clipboard, so that you can paste to other apps
set clipboard=unnamed

" set tags path
set tags=./tags;,tags;

" set auto bracket
inoremap ' ''<ESC>i
inoremap " ""<ESC>i
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
iabbrev {i {<enter>}<esc>O<BS>

" pathogen plugin
" execute pathogen#infect()

" keep cursor stay above from bottom of the screen
set scrolloff=5

" settings about ack.vim
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" set cursor line highlight
set cursorline

" nerdtree mappings
nnoremap <C-n> :NERDTreeToggle<CR>

" auto comment setting
autocmd FileType c set commentstring=//\ %s

" tagbar mapping
nmap <leader>t :TagbarToggle<CR>

set shell=/bin/zsh\ -l
