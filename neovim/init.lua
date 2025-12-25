vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- color scheme
vim.pack.add({
  { src = 'https://github.com/catppuccin/nvim' },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/sphamba/smear-cursor.nvim" },
  { src = "https://github.com/gbprod/yanky.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = 'https://github.com/NvChad/nvim-colorizer.lua' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/karb94/neoscroll.nvim' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/folke/noice.nvim' },
})

require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    float = {
        transparent = false, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
    },
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
        virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
        },
        underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
        },
        inlay_hints = {
            background = true,
        },
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    auto_integrations = false,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

vim.lsp.enable({ "lua_ls", "clangd", "rust_analyzer" })


-- Diagnostic
require("tiny-inline-diagnostic").setup({})
vim.diagnostic.config({ virtual_text = false })


-- CMP
require("blink.cmp").setup({
  keymap = { preset = "enter" },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = { documentation = { auto_show = false } },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = { implementation = "lua" }
})

-- Formatter
vim.keymap.set(
  { "n" },
  "<leader>cf",
  function()
    require("conform").format({
      async = true,
      lsp_fallback = true,
      timeout_ms = 500,
    })
  end,
  { desc = "Format file" }
)

require("conform").setup(
  {
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
    -- formatters_by_ft = language_config.FORMATTER_MAP,
  }
)

require("smear_cursor").setup({
  smear_between_buffers = true,
})

-- custom paste function
local function paste_from_unnamed()
  local lines = vim.split(vim.fn.getreg(""), "\n", { plain = true })
  if #lines == 0 then
    lines = { "" }
  end
  local rtype = vim.fn.getregtype(""):sub(1, 1)
  return { lines, rtype }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste_from_unnamed,
    ["*"] = paste_from_unnamed,
  },
}

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local ev = vim.v.event
    if ev.operator == "y" and ev.regname == "" then
      vim.fn.setreg("+", ev.regcontents, ev.regtype)
    end
  end,
})

require("yanky").setup({
  system_clipboard = {
    sync_with_ring = false,
  }
})


-- options

-- show the absolute line number for the current line
vim.opt.number = true
-- show relative line numbers
vim.opt.relativenumber = true

-- Confirm before quitting unsaved changes
vim.opt.confirm = true
-- Persistent undo across sessions
vim.opt.undofile = true
-- Practically infinite undo (safe)
vim.opt.undolevels = 1000000
-- Enable mouse in all modes
vim.opt.mouse = "a"

-- Use spaces instead of tabs
vim.opt.expandtab = true
-- Indent size
vim.opt.shiftwidth = 2
-- Tab character width
vim.opt.tabstop = 2
-- Round indent to nearest multiple of shiftwidth
vim.opt.shiftround = true
-- Auto-indent new lines intelligently
vim.opt.smartindent = true

-- Keep comments, wrap text, autoformat when possible
vim.opt.formatoptions = "jcroqlnt"

-- Case-insensitive by default
vim.opt.ignorecase = true
-- But smart if uppercase is used
vim.opt.smartcase = true

-- Live preview for :substitute
vim.opt.inccommand = "nosplit"
vim.opt.grepprg = "rg --vimgrep" -- Use ripgrep for :grep
-- Match file:line:col:message format
vim.opt.grepformat = "%f:%l:%c:%m"

-- Highlight current line
vim.opt.cursorline = true
-- Always show sign column
vim.opt.signcolumn = "yes"
-- Show cursor position in statusline
vim.opt.ruler = true
-- Global statusline (once you add one)
vim.opt.laststatus = 3
-- Enable true colors
vim.opt.termguicolors = true
-- Prevent tiny splits
vim.opt.winminwidth = 5
-- Keep 4 lines visible around cursor
vim.opt.scrolloff = 4
-- Keep 8 columns visible horizontally
vim.opt.sidescrolloff = 8
-- Disable line wrapping
vim.opt.wrap = false
-- (If wrapping) break at words
vim.opt.linebreak = true
-- Show invisible characters (tabs, etc.)
vim.opt.list = false
vim.opt.showmode = false
vim.opt.colorcolumn = "80"

-- Fold by indentation level
vim.opt.foldmethod = "indent"
-- Start unfolded
vim.opt.foldlevel = 99
-- Simple fold indicator (first line + …)
vim.opt.foldtext = "v:lua.vim.fn.getline(v:foldstart) .. ' …'"

-- Restore view after jump
vim.opt.jumpoptions = "view"
-- Allow cursor past EOL in block mode
vim.opt.virtualedit = "block"
-- Enhanced command completion
vim.opt.wildmode = "longest:full,full"
-- Horizontal splits below
vim.opt.splitbelow = true
-- Vertical splits to the right
vim.opt.splitright = true
-- Preserve layout when splitting
vim.opt.splitkeep = "screen"




-- keymaps
local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bd", function()
  local cur = vim.api.nvim_get_current_buf()
  local alt = vim.fn.bufnr("#")
  if alt > 0 and vim.api.nvim_buf_is_loaded(alt) then
    vim.cmd("buffer #")
  else
    vim.cmd("bnext")
  end
  vim.cmd("bdelete " .. cur)
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and buf ~= current then
      vim.cmd("bdelete " .. buf)
    end
  end
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- quick save
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- location list
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- quickfix list
map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- windows
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
-- map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
-- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- LSP (when attached)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspKepmap", {}),
  callback = function(ev)
    -- Use buffer-local keymaps
    local opts = function(desc)
      return { buffer = ev.buf, desc = desc }
    end

    -- LSP keymaps
    map("n", "K", vim.lsp.buf.hover, opts("LSP Hover"))
    map("n", "gd", vim.lsp.buf.definition, opts("Goto Definition"))
    map("n", "gD", vim.lsp.buf.declaration, opts("Goto Declaration"))
    map("n", "gr", vim.lsp.buf.references, opts("List References"))
    map("n", "gi", vim.lsp.buf.implementation, opts("Goto Implementation"))
    map("n", "gt", vim.lsp.buf.type_definition, opts("Type Definition"))
    map("n", "<leader>cr", vim.lsp.buf.rename, opts("Rename Symbol"))
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code Action"))
    map("i", "<C-k>", vim.lsp.buf.signature_help, opts("Signature Help"))
  end,
})

map("n", "<leader><space>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { desc = "Grep in files" })
map("n", "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
  { desc = "Switch buffers" })
map("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })


require("bufferline").setup({
  options = {
    close_command = function(bufnr)
      vim.cmd("bdelete " .. bufnr)
    end,
    right_mouse_command = function(bufnr)
      vim.cmd("bdelete " .. bufnr)
    end,

    diagnostics = "nvim_lsp",
    always_show_bufferline = true,

    diagnostics_indicator = function(_, _, diag)
      local icons = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }
      local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
      return vim.trim(ret)
    end,

    offsets = {
      {
        filetype = "neo-tree",
        text = "Neo-tree",
        highlight = "Directory",
        text_align = "left",
      },
    },

    get_element_icon = function(opts)
      -- fallback to nvim-web-devicons if available
      local ok, devicons = pcall(require, "nvim-web-devicons")
      if ok then
        local icon, _ = devicons.get_icon_by_filetype(opts.filetype)
        return icon
      end
      return ""
    end,
  }
}
)


map("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
map("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })



map("n", "<leader>e", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
end, { desc = "Explorer NeoTree (cwd)" })

require("colorizer").setup({
  filetypes = { "*" },
  user_default_options = {
    RGB = true,
    RRGGBB = true,
    names = false,
    mode = "background",
  },
}
)

-- require("lualine").setup({
--   options = {
--     theme = "dracula",
--     globalstatus = true,
--   },
-- })


require('neoscroll').setup({
  mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
    '<C-u>', '<C-d>',
    '<C-b>', '<C-f>',
    '<C-y>', '<C-e>',
    'zt', 'zz', 'zb',
  },
  hide_cursor = true,          -- Hide cursor while scrolling
  stop_eof = true,             -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  duration_multiplier = 1.0,   -- Global duration multiplier
  easing = 'linear',           -- Default easing function
  pre_hook = nil,              -- Function to run before the scrolling animation starts
  post_hook = nil,             -- Function to run after the scrolling animation ends
  performance_mode = false,    -- Disable "Performance Mode" on all buffers.
  ignored_events = {           -- Events ignored while scrolling
      'WinScrolled', 'CursorMoved'
  },
})

local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')
require('nvim-autopairs').setup({
    check_ts = true,
    ts_config = {
        lua = {'string'},-- it will not add a pair on that treesitter node
        javascript = {'template_string'},
        java = false,-- don't check treesitter on java
    }
})

local ts_conds = require('nvim-autopairs.ts-conds')


-- press % => %% only while inside a comment or string
npairs.add_rules({
  Rule("%", "%", "lua")
    :with_pair(ts_conds.is_ts_node({'string','comment'})),
  Rule("$", "$", "lua")
    :with_pair(ts_conds.is_not_ts_node({'function'}))
})

require('lualine').setup({ options = { theme = 'catppuccin' }})

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})