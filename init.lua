local vim_config = vim.fn.stdpath("config") .. "/config.vim"
vim.cmd("source " .. vim_config)
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
    },
    float = {
        border = "rounded",
    },

})
vim.keymap.set("n", "<leader>e.", "<cmd>lua require('oil').toggle_float()<CR>", { noremap = true })
vim.keymap.set("n", "<leader>ec", "<cmd>lua require('oil').toggle_float(vim.fn.getcwd())<CR>", { noremap = true })


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
        ['<C-f>'] = { 'show_signature', 'hide_signature', 'fallback' },
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

    signature = {
        window = {
            border = 'bold',
        }
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
lspconfig['checkmake'].setup({})

-- lsp keymap
vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true })
vim.keymap.set("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { noremap = true })
vim.keymap.set("n", "gn", "<Cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })
vim.keymap.set("n", "g]", "<Cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true })
vim.keymap.set("n", "g[", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true })

--local status, treesitter = pcall(require, "nvim-treesitter.configs")
--if not status then
--    return
--end

-- treesitter config
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
  options = {
      theme  = 'gruvbox',
      globalstatus = true,
  },
  -- winbar = {
  --     lualine_c = {'filename'},
  -- },
  -- inactive_winbar = {
  --     lualine_c = {'filename'},
  -- },
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

-- fzf-lua
require("fzf-lua").setup {
  winopts = {
    on_create = function()
      vim.keymap.set("t", "<C-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true, buffer = true })
    end,
  }
}

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua resume<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fj", "<cmd>FzfLua jumps<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<CR>", { noremap = true })

-- window separator
require("colorful-winsep").setup {

}

-- fugitive
local function toggle_fugitive_vertical()
    local fugitive_win = nil
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'fugitive' then
            fugitive_win = win
            break
        end
    end

    if fugitive_win then
        vim.api.nvim_win_close(fugitive_win, false)
    else
        vim.cmd('vertical Git')
    end
end

local function toggle_fugitive_blame()
    local fugitive_win = nil
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'fugitiveblame' then
            fugitive_win = win
            break
        end
    end

    if fugitive_win then
        vim.api.nvim_win_close(fugitive_win, false)
    else
        vim.cmd('G blame')
    end
end

local function toggle_fugitive_log()
    local fugitive_win = nil
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'git' then
            fugitive_win = win
            break
        end
    end

    if fugitive_win then
        vim.api.nvim_win_close(fugitive_win, false)
    else
        vim.cmd('G log -50 --decorate')
    end
end
vim.keymap.set('n', '<leader>gg', toggle_fugitive_vertical, { desc = 'Toggle Fugitive Vertical' })
vim.keymap.set('n', '<leader>gb', toggle_fugitive_blame, { desc = 'Toggle Fugitive Vertical' })
vim.keymap.set('n', '<leader>gl', toggle_fugitive_log, { desc = 'Toggle Fugitive Vertical' })

-- scope
require("scope").setup({})

-- flash
require("flash").setup({
    modes = {
        char = {
            enabled = false,
        },
    },
})
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash Jump" })

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

-- Helper function to strictly check for Ubuntu
local function is_ubuntu()
  local file = io.open("/etc/os-release", "r")
  if not file then return false end

  local found_ubuntu = false

  -- Read line by line for an exact match
  for line in file:lines() do
    if line == "ID=ubuntu" or line == 'ID="ubuntu"' then
      found_ubuntu = true
      break -- Stop reading once we find it
    end
  end

  file:close()
  return found_ubuntu
end

-- for old tmux versions, need this to pass clipboard content to windows
if is_ubuntu() then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

vim.opt.clipboard = "unnamedplus"
