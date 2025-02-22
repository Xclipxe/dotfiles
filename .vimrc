" plugin vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-surround'
Plugin 'preservim/nerdtree'
Plugin 'preservim/tagbar'
Plugin 'tpope/vim-commentary'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'luochen1990/rainbow'
Plugin 'dense-analysis/ale'
Plugin 'Yggdroot/LeaderF'
Plugin 'lervag/vimtex', { 'tag': 'v2.15' }
Plugin 'morhetz/gruvbox'

call vundle#end()            " required
filetype plugin indent on    " required

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
" set shortmess+=I

" Show line numbers.
set number

set relativenumber

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
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
" nnoremap <Left>  :echoe "Use h"<CR>
" nnoremap <Right> :echoe "Use l"<CR>
" nnoremap <Up>    :echoe "Use k"<CR>
" nnoremap <Down>  :echoe "Use j"<CR>
" " ...and in insert mode
" inoremap <Left>  <ESC>:echoe "Use h"<CR>
" inoremap <Right> <ESC>:echoe "Use l"<CR>
" inoremap <Up>    <ESC>:echoe "Use k"<CR>
" inoremap <Down>  <ESC>:echoe "Use j"<CR>
" now I don't need this!

" plugin CtrlP, remap shortcut
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'

" set autoindent
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" use colorscheme gruvbox
" let g:solarized_termcolors=256
syntax enable
set background=dark
colorscheme gruvbox

" show current position
set ruler

" allow copy to clipboard, so that you can paste to other apps
set clipboard=unnamed

" set tags path
set tags=./.tags;,.tags;

" set auto bracket
" inoremap ' ''<ESC>i
" inoremap " ""<ESC>i
" inoremap ( ()<ESC>i
" inoremap [ []<ESC>i
" iabbrev {i {<CR><CR>}<esc>ki<tab><BS>

" delete one space when press backspace
set softtabstop=0

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

" remap <esc>
inoremap jk <esc>

" better ctrl d and ctrl u
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

" use ag instead of ack, because the fucking apple's silly update
" let g:ackprg = 'ag --vimgrep'
let g:ackprg = 'ag --nogroup --nocolor --column'

" highlight when use *
set hls

" default use demical when <C-a>
set nrformats=

" show what I've input when in normal mode
set showcmd

" use * could search selected text in visual mode
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" tags setting
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" new try for {} thing
iabbrev {i {}<Left><CR><esc>O<BS>

" fix when open matlab file read random char if it's Chinese
" autocmd BufRead,BufNewFile *.m execute 'edit ++enc=gbk'
set fileencodings=ucs-bom,gbk,utf-8,latin1

" open .vimrc quickly
nnoremap <leader>rc :tabedit ~/.vimrc<CR>

" leaderf best match be the bottom
let g:Lf_ReverseOrder = 1

" bind ctrlp to leaderf
nnoremap <c-p> :Leaderf file --no-auto-preview

" disable vimtex
let g:vimtex_enabled = 0

" paste from OS easier
inoremap <c-v> <c-r>+
