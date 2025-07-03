" plugin vundle
set nocompatible              " be iMproved, required
filetype off                  " required
call plug#begin()

" List your plugins here
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'terryma/vim-multiple-cursors'
Plug 'justinmk/vim-sneak'
Plug 'stevearc/oil.nvim'
Plug 'vuciv/golf'

call plug#end()

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
set tags=./.tags;,.tags;,./tags;,tags;
" augroup TxtFileSettings
"   autocmd!
"   autocmd BufRead,BufNewFile *.txt set iskeyword+=(,),-,#
"   autocmd BufLeave *.txt set iskeyword-=(,),-,#
" augroup END
" set iskeyword+=-
" set iskeyword+=#
" set iskeyword+=(
" set iskeyword+=)
augroup HelpSettings
    " 清除本组内已有的自动命令，防止重复定义
    autocmd!

    " 当文件类型是 help 时
    " 修改当前 buffer 的 iskeyword 选项
    " 这里以添加 '-' 字符为例，你可以根据需要修改
    " 比如想把 '-' 添加到现有值中：
    autocmd FileType help setlocal iskeyword+=-,#,(,)

    " 如果你想完全替换 iskeyword 的值，可以使用：
    " autocmd FileType help setlocal iskeyword=@,48-57,_,192-255,-

    " 你可以根据需要添加其他字符或范围
    " autocmd FileType help setlocal iskeyword+=-,/

augroup END

" set auto bracket
" inoremap ' ''<ESC>i
" inoremap " ""<ESC>i
" inoremap ( ()<ESC>i
" inoremap [ []<ESC>i
" iabbrev {i {<CR><CR>}<esc>ki<tab><BS>


" delete one space when press backspace
set softtabstop=0

" keep cursor stay above from bottom of the screen
set scrolloff=5

" set cursor line highlight
set cursorline

" auto comment setting
autocmd FileType c set commentstring=//\ %s

" " let vim use zsh
" set shell=/bin/zsh\ -l

" remap <esc>
inoremap jk <esc>

" better ctrl d and ctrl u
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

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

" new try for {} thing
inoremap {<cr> {}<Left><CR><esc>O

" fix when open matlab file read random char if it's Chinese
" autocmd BufRead,BufNewFile *.m execute 'edit ++enc=gbk'
set fileencodings=ucs-bom,gbk,utf-8,latin1

" open init.vim quickly
nnoremap <leader>rc :tabedit ~/.config/nvim/init.vim<CR>

" paste from OS easier, (has problem using nvim)
inoremap <silent> <c-v> <c-o>:set paste<cr><c-r>+<c-o>:set nopaste<cr>

" use for dessertation
vnoremap <leader>b c{\boldsymbol{<c-r>"}}<esc>

" settings about coc
let g:coc_global_extensions = [
            \ 'coc-clangd']
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

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap <C-j> and <C-k> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<C-j>"
  nnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<C-k>"
  inoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<cr>" : "\<C-j>"
  inoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<cr>" : "\<C-k>"
  vnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<C-j>"
  vnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<C-k>"
endif
" Make <tab> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
" inoremap <silent><expr> <tab> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" function! CheckBackspace() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" close all float window
inoremap <silent><nowait><expr> <C-c> coc#float#has_float() ? "\<c-r>=coc#float#close_all()\<cr>" : "\<C-c>"

" telescope related
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr> 

" the gf search according to the path, this is the python lib's location on my
" mac
set path+=/opt/homebrew/Cellar/python@3.13/3.13.2/Frameworks/Python.framework/Versions/3.13/lib/python3.13
set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
set path+=/opt/homebrew/include
set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX15.1.sdk/usr/include/c++/v1

" settings for toggleterm
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-\> <Cmd>exe v:count1 . "ToggleTerm"<CR>

" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><c-\> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-\> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>


lua << EOF
require("toggleterm").setup{
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  direction = 'float',
  start_in_insert = true,
}
EOF

lua << EOF
require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "query", "markdown", "python"},
-- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<cr>",
      node_incremental = "<cr>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
}
require("oil").setup({
    columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
    },
})
EOF

