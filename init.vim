" plugin vundle
set nocompatible              " be iMproved, required
filetype off                  " required
call plug#begin()

" List your plugins here
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'morhetz/gruvbox'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'justinmk/vim-sneak'
Plug 'stevearc/oil.nvim'
Plug 'vuciv/golf'
Plug 'aphroteus/vim-uefi'
Plug 'ibhagwan/fzf-lua'

" lsp
Plug 'mason-org/mason.nvim'
Plug 'neovim/nvim-lspconfig', { 'tag': 'v1.0.0' }

" auto completion
Plug 'saghen/blink.cmp', { 'tag': 'v1.5.0' } 
Plug 'rafamadriz/friendly-snippets'

" markdown preview
Plug 'echasnovski/mini.icons'
Plug 'OXY2DEV/markview.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'

" symbol table
Plug 'stevearc/aerial.nvim'

Plug 'sitiom/nvim-numbertoggle'
Plug 'nvim-lualine/lualine.nvim'
call plug#end()


let mapleader = " "

set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

set hidden

set ignorecase
set smartcase

set incsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> 
" 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

set mouse+=a

set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
autocmd FileType c,cpp,dts setlocal tabstop=4 shiftwidth=4 noexpandtab

" use colorscheme gruvbox
syntax enable
set background=dark
let g:gruvbox_contrast_dark="hard"
colorscheme gruvbox

" show current position
set ruler

" allow copy to clipboard, so that you can paste to other apps
set clipboard=unnamed

" set tags path
set tags=./.tags;,.tags;,./tags;,tags;

" set path
set path+=**

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

" delete one space when press backspace
set softtabstop=0

" keep cursor stay above from bottom of the screen
set scrolloff=5

" set cursor line highlight
set cursorline

" auto comment setting
" autocmd FileType c set commentstring=//\ %s
autocmd FileType dts set commentstring=/*\ %s\ */

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

" auto { expand
inoremap {<cr> {}<Left><CR><esc>O

" fix when open matlab file read random char if it's Chinese
" autocmd BufRead,BufNewFile *.m execute 'edit ++enc=gbk'
set fileencodings=ucs-bom,gbk,utf-8,latin1

" open init.vim quickly
nnoremap <leader>rc :tabedit ~/.config/nvim/init.vim<CR>

" " the gf search according to the path, this is the python lib's location on my
" " mac
" set path+=/opt/homebrew/Cellar/python@3.13/3.13.2/Frameworks/Python.framework/Versions/3.13/lib/python3.13
" set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
" set path+=/opt/homebrew/include
" set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX15.1.sdk/usr/include/c++/v1

" ------------terminal mode settings
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
" ------------terminal mode settings

lua << EOF
require('mini.icons').setup()

require("markview").setup({
    preview = {
        icon_provider = "mini", -- "mini" or "devicons"
    }
})

-- oil
require("oil").setup({
    columns = {
        "size",
        "mtime",
    },
    keymaps = {
        ["gcd"] = {
            "actions.cd",
            desc = "change cwd to oil currently in",
        },
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
    }
})
vim.keymap.set("n", "<leader>e.", "<cmd>lua require('oil').toggle_float()<CR>", { noremap = true })

EOF

lua << EOF
require("mason").setup({

})

local cmp = require('blink.cmp')

-- my habits: no preselect
cmp.setup({
    keymap = {
        preset = 'default',
        ['<tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<C-space>'] = false,
        ['<C-j>'] ={ 'select_and_accept' },
        ['<C-k>'] = { 'show', 'show_documentation', 'hide_documentation' },
    },

    appearance = {
        nerd_font_variant = 'mono',
    },

    completion = {
        documentation = {
            auto_show = false,
        },
        list = {
            selection = {
                preselect = false,
            },
        },
    },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    fuzzy = {
        implementation = "prefer_rust_with_warning",
    },
})

local capabilities = require('blink.cmp').get_lsp_capabilities()
local lspconfig = require('lspconfig')
lspconfig['clangd'].setup({ capabilities = capabilities })
lspconfig['lua_ls'].setup({ 
    capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
lspconfig['marksman'].setup({})
lspconfig.pylsp.setup({ capabilities = capabilities })
-- lspconfig['jedi'].setup({ capabilities = capabilities })

-- lsp keymap
vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true })
vim.keymap.set("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { noremap = true })
vim.keymap.set("n", "gn", "<Cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })
vim.keymap.set("n", "g]", "<Cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true })
vim.keymap.set("n", "g[", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true })

-- treesitter config
require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "query", "markdown", "python", "asm"},
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
vim.cmd("hi link TreesitterContextBottom SpellCap")
-- require'treesitter-context'.setup{
  -- enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  -- multiwindow = false, -- Enable multiwindow support.
  -- max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  -- min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  -- line_numbers = true,
  -- multiline_threshold = 20, -- Maximum number of lines to show for a single context
  -- trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  -- mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- -- Separator between context and content. Should be a single character string, like '-'.
  -- -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  -- separator = nil,
  -- zindex = 20, -- The Z-index of the context window
  -- on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
-- }

-- local telescope = require("telescope")
-- 
-- -- telescope
-- telescope.setup({
--     defaults = {
--         mappings = {
--             n = {
--                 ['dd'] = "delete_buffer"
--             },
--         },
--     }
-- })
-- 
-- local lga_actions = require("telescope-live-grep-args.actions")
-- 
-- telescope.setup {
--   extensions = {
--     live_grep_args = {
--       auto_quoting = true, -- enable/disable auto-quoting
--       -- define mappings, e.g.
--       mappings = { -- extend mappings
--         i = {
--             ["<C-k>"] = lga_actions.quote_prompt({ postfix = " -t" }),
--         },
--       },
--     }
--   }
-- }
-- 
-- -- then load the extension
-- telescope.load_extension("live_grep_args")
-- 
-- vim.keymap.set('n', '<leader>ff', ":lua require('telescope.builtin').find_files()<CR>", { noremap = true })
-- vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
-- vim.keymap.set('n', '<leader>fb', ":lua require('telescope.builtin').buffers()<CR>", { noremap = true })
-- vim.keymap.set('n', '<leader>fh', ":lua require('telescope.builtin').help_tags()<CR>", { noremap = true })


-- toggle paste mode
local toggle_paste = function()
  if vim.opt.paste:get() then
    vim.opt.paste = false
    print('PASTE mode OFF')
  else
    vim.opt.paste = true
    print('PASTE mode ON')
  end
end

vim.keymap.set('n', '<F5>', toggle_paste, { desc = 'Toggle paste mode' })

-- aerial
require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { noremap = true })

-- toggleterm
require("toggleterm").setup({})
vim.keymap.set("n", "<c-\\>", "<cmd>ToggleTerm direction=float<cr>", { noremap = true })
vim.keymap.set("t", "<c-\\>", "<cmd>ToggleTerm direction=float<cr>", { noremap = true })

-- lualine
require('lualine').setup {
  options = { theme  = 'gruvbox' },
  sections = {
    lualine_c = {
      {
        'filename',
        file_status = true,      -- Displays file status (readonly status, modified status)
        newfile_status = false,  -- Display new file status (new file means no write after created)
        path = 1,                -- 0: Just the filename
                                 -- 1: Relative path
                                 -- 2: Absolute path
                                 -- 3: Absolute path, with tilde as the home directory
                                 -- 4: Filename and parent dir, with tilde as the home directory
  
        shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                                 -- for other components. (terrible name, any suggestions?)
        symbols = {
          modified = '[+]',      -- Text to show when the file is modified.
          readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
          newfile = '[New]',     -- Text to show for newly created file before first write
        }
      }
    }
  }
}

-- misc
vim.keymap.set("n", "<leader>tt", "<cmd>tab terminal<CR>", { noremap = true })
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = { 'utf-8', 'gbk', 'utf-16le', 'utf-16be', 'euc-jp', 'sjis', 'latin1' }
vim.opt.number = true
vim.opt.relativenumber = true
-- if wrap markview won't render middle lines of table
vim.opt.wrap = false
vim.keymap.set("n", "cc", ":cclose<cr>")
vim.opt.termguicolors = true

-- vim.api.nvim_create_user_command("ReloadFoo", function()
--   package.loaded["foo"] = nil
--   require("foo")
--   print("Reloaded foo.lua")
-- end, {})

-- terminal mode doesn't show line number
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})

-- syntax highlight support for aslc
vim.filetype.add({
  extension = {
    aslc = "aslc",
  },
})

-- add file aslc highlight support
vim.api.nvim_create_autocmd("FileType", {
  pattern = "aslc",
  callback = function()
    vim.opt_local.syntax = "c"
    vim.opt_local.commentstring = "// %s"
  end,
})

-- copy path to clipboard
vim.api.nvim_create_user_command('Path', function()
    local path = vim.fn.expand("%")
    
    vim.fn.setreg("+", path)
    
    vim.notify('Copied relative path: ' .. path, vim.log.levels.INFO)
end, { desc = "Copy relative file path to clipboard" })

-- fzf-lua
require("fzf-lua").setup {
  winopts = {
    on_create = function()
      vim.keymap.set("t", "<C-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true, buffer = true })
    end,
  }
}
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep_native<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua resume<CR>", { noremap = true })
EOF
