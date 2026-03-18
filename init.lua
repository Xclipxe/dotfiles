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
-- require higher version of glibc
-- lspconfig['checkmake'].setup({})

-- lsp keymap
vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true })
vim.keymap.set("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { noremap = true })
vim.keymap.set("n", "gn", "<Cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })
vim.keymap.set("n", "g]", "<Cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true })
vim.keymap.set("n", "g[", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true })

local function filter_lsp_duplicates()
    local original_definition_handler = vim.lsp.handlers["textDocument/definition"]

    vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
        -- 如果没有结果，直接走默认逻辑
        if err or not result or vim.tbl_isempty(result) then
            return original_definition_handler(err, result, ctx, config)
        end

        -- 如果返回的是一个列表，进行去重
        if vim.islist(result) then
            local seen = {}
            local filtered_result = {}

            for _, res in ipairs(result) do
                local uri = res.uri or res.targetUri
                local range = res.range or res.targetSelectionRange

                if uri and range then
                    -- 用 URI 和行号列号生成唯一 Key
                    local key = uri .. ':' .. range.start.line .. ':' .. range.start.character
                    if not seen[key] then
                        seen[key] = true
                        table.insert(filtered_result, res)
                    end
                end
            end

            -- 将去重后的结果重新赋值
            result = filtered_result
        end

        -- 调用原始的 handler 传入去重后的结果
        original_definition_handler(err, result, ctx, config)
    end
end

-- 启用过滤器
filter_lsp_duplicates()

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
        -- vertical Git 执行后，焦点会自动跳到新打开的 fugitive 窗口
        local win = vim.api.nvim_get_current_win()
        local current_width = vim.api.nvim_win_get_width(win)

        -- 如果当前宽度大于 80，则将其限制为 80
        if current_width > 80 then
            vim.api.nvim_win_set_width(win, 80)
        end
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

vim.o.timeoutlen = 2000


-- ==========================================================================
-- 完美比例版：30行高 x 129列宽的终极巨型 FUCK
-- ==========================================================================

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("PerfectRatioFuck", { clear = true }),
    callback = function()
        if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
            
            -- 高度：严格 30 行
            -- 宽度：每个字母 30 字符宽，极度粗壮，比例完美协调
            local logo = {
                "██████████████████████████████   ██████████          ██████████   ██████████████████████████████   ██████████          ██████████",
                "██████████████████████████████   ██████████          ██████████   ██████████████████████████████   ██████████          ██████████",
                "██████████████████████████████   ██████████          ██████████   ██████████████████████████████   ██████████          ██████████",
                "██████████████████████████████   ██████████          ██████████   ██████████████████████████████   ██████████        ██████████  ",
                "██████████████████████████████   ██████████          ██████████   ██████████████████████████████   ██████████        ██████████  ",
                "██████████████████████████████   ██████████          ██████████   ██████████████████████████████   ██████████      ██████████    ",
                "██████████                       ██████████          ██████████   ██████████                       ██████████      ██████████    ",
                "██████████                       ██████████          ██████████   ██████████                       ██████████    ██████████      ",
                "██████████                       ██████████          ██████████   ██████████                       ██████████    ██████████      ",
                "██████████                       ██████████          ██████████   ██████████                       ██████████  ██████████        ",
                "██████████                       ██████████          ██████████   ██████████                       ██████████  ██████████        ",
                "██████████                       ██████████          ██████████   ██████████                       ████████████████████          ",
                "████████████████████████         ██████████          ██████████   ██████████                       ████████████████████          ",
                "████████████████████████         ██████████          ██████████   ██████████                       ████████████████████          ",
                "████████████████████████         ██████████          ██████████   ██████████                       ████████████████████          ",
                "████████████████████████         ██████████          ██████████   ██████████                       ████████████████████          ",
                "████████████████████████         ██████████          ██████████   ██████████                       ████████████████████          ",
                "████████████████████████         ██████████          ██████████   ██████████                       ████████████████████          ",
                "██████████                       ██████████          ██████████   ██████████                       ████████████████████          ",
                "██████████                       ██████████          ██████████   ██████████                       ██████████  ██████████        ",
                "██████████                       ██████████          ██████████   ██████████                       ██████████  ██████████        ",
                "██████████                       ██████████          ██████████   ██████████                       ██████████    ██████████      ",
                "██████████                       ██████████          ██████████   ██████████                       ██████████    ██████████      ",
                "██████████                       ██████████          ██████████   ██████████                       ██████████      ██████████    ",
                "██████████                       ██████████████████████████████   ██████████████████████████████   ██████████      ██████████    ",
                "██████████                       ██████████████████████████████   ██████████████████████████████   ██████████        ██████████  ",
                "██████████                       ██████████████████████████████   ██████████████████████████████   ██████████        ██████████  ",
                "██████████                       ██████████████████████████████   ██████████████████████████████   ██████████          ██████████",
                "██████████                       ██████████████████████████████   ██████████████████████████████   ██████████          ██████████",
                "██████████                       ██████████████████████████████   ██████████████████████████████   ██████████          ██████████",
                "                                                                                                                                 ",
                "                                                                                                                                 ",
                "                                                              nvidia                                                             "
            }

            local buf = vim.api.nvim_get_current_buf()
            
            vim.opt_local.bufhidden = "wipe"
            vim.opt_local.buftype = "nofile"
            vim.opt_local.swapfile = false
            vim.opt_local.buflisted = false
            vim.opt_local.statusline = " "
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.wrap = false
            vim.opt.laststatus = 0

            local function draw()
                local screen_width = vim.api.nvim_get_option("columns")
                local screen_height = vim.api.nvim_get_option("lines")
                local centered_content = {}

                -- 垂直居中
                local v_padding = math.floor((screen_height - #logo) / 2)
                for _ = 1, math.max(0, v_padding) do table.insert(centered_content, "") end

                -- 水平居中 (当前精确宽度为 129 字符)
                for _, line in ipairs(logo) do
                    local shift = math.floor((screen_width - 129) / 2)
                    table.insert(centered_content, string.rep(" ", math.max(0, shift)) .. line)
                end

                vim.api.nvim_buf_set_option(buf, "modifiable", true)
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, centered_content)
                vim.api.nvim_buf_set_option(buf, "modifiable", false)
            end

            draw()

            vim.keymap.set("n", "q", ":qa<CR>", { buffer = buf, silent = true })
            
            vim.api.nvim_create_autocmd("VimResized", {
                buffer = buf,
                callback = draw
            })
        end
    end,
})

vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        vim.opt.laststatus = 2
    end,
})
