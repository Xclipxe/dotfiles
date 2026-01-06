call plug#begin()

" List your plugins here
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'morhetz/gruvbox'
Plug 'nvim-lua/plenary.nvim'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'justinmk/vim-sneak'
Plug 'stevearc/oil.nvim'
Plug 'vuciv/golf'
Plug 'aphroteus/vim-uefi'
Plug 'ibhagwan/fzf-lua'
Plug 'nvim-treesitter/nvim-treesitter', {'tag' : 'v0.10.0'}
Plug 'nvim-treesitter/nvim-treesitter-context'

" lsp
Plug 'mason-org/mason.nvim'
Plug 'neovim/nvim-lspconfig', { 'tag': 'v1.0.0' }

" auto completion
" somethings may goes wrong if press <C-p> to the completion menu
" rm blink and its dependency, remove .local/share/nvim/blink
" install blink, remember to add a tag
Plug 'saghen/blink.cmp', { 'tag': 'v1.8.0' } " always add a tag
Plug 'rafamadriz/friendly-snippets'

" markdown preview
Plug 'echasnovski/mini.icons'
Plug 'OXY2DEV/markview.nvim'

" symbol table
Plug 'stevearc/aerial.nvim'

Plug 'sitiom/nvim-numbertoggle'
Plug 'nvim-lualine/lualine.nvim'
call plug#end()

let mapleader = " "

set ignorecase

set incsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> 
" 'Q' in normal mode enters Ex mode. You almost never want this.

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
autocmd FileType c,cpp,dts setlocal shiftwidth=4 noexpandtab
autocmd FileType c setlocal tabstop=8 shiftwidth=8

" use colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark="hard"
colorscheme gruvbox

" allow copy to clipboard, so that you can paste to other apps
set clipboard=unnamed

" set tags path
set tags=./.tags;,.tags;,./tags;,tags;

" set path
set path+=**

augroup HelpSettings
    autocmd!
    autocmd FileType help setlocal iskeyword+=-,#,(,)
augroup END

" delete one space when press backspace
set softtabstop=0

" keep cursor stay above from bottom of the screen
set scrolloff=5

" set cursor line highlight
set cursorline

" auto comment setting
" autocmd FileType c set commentstring=//\ %s
autocmd FileType dts set commentstring=/*\ %s\ */
autocmd FileType asl set commentstring=//\ %s
" remap <esc>
inoremap jk <esc>

" better ctrl d and ctrl u
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

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

" auto { expand
inoremap {<cr> {}<Left><CR><esc>O

" fix when open matlab file read random char if it's Chinese
" autocmd BufRead,BufNewFile *.m execute 'edit ++enc=gbk'
set fileencodings=ucs-bom,gbk,utf-8,latin1

" open init.vim quickly
nnoremap <leader>rc :tabedit ~/.config/nvim/init.lua<CR>

" terminal mode settings
" To map <Esc> to exit terminal-mode
tnoremap <Esc><Esc> <C-\><C-n>
" map <M-e> to <esc>
tnoremap <M-e> <Esc>
" " To use `ALT+{h,j,k,l}` to navigate windows from any mode >vim
tnoremap <M-h> <C-\><C-N><C-w>h
tnoremap <M-j> <C-\><C-N><C-w>j
tnoremap <M-k> <C-\><C-N><C-w>k
tnoremap <M-l> <C-\><C-N><C-w>l
inoremap <M-h> <C-\><C-N><C-w>h
inoremap <M-j> <C-\><C-N><C-w>j
inoremap <M-k> <C-\><C-N><C-w>k
inoremap <M-l> <C-\><C-N><C-w>l
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l

" map tab navigate
nnoremap H gT
nnoremap L gt

