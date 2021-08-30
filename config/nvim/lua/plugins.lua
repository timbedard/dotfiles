local packer_path =
  vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(packer_path)) then
  vim.fn.system {
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    packer_path
  }
  vim.cmd("packadd packer.nvim")
end

return require("packer").startup {
  function()
    use {"wbthomason/packer.nvim", opt = true}

    use {
      "nvim-treesitter/nvim-treesitter",
      requires = {
        -- "romgrk/nvim-treesitter-context", -- This is rad, but stupid slow right now.
        -- "nvim-treesitter/playground",
        -- "nvim-treesitter/nvim-treesitter-refactor",
        "nvim-treesitter/nvim-treesitter-textobjects",
        "windwp/nvim-ts-autotag"
      },
      run = ":TSUpdate",
      config = function()
        require("tb.treesitter")
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      end
    }

    use {
      "npxbr/gruvbox.nvim",
      requires = "rktjmp/lush.nvim",
      config = function()
        vim.g.gruvbox_sign_column = "bg0"
        vim.cmd("colorscheme gruvbox")

        -- require("tb.gruvbox")  -- for ref, but inline works on PackerCompile

        -- treesitter highlights
        vim.cmd("highlight! link TSConstBuiltin Constant") -- None
        vim.cmd("highlight! link TSKeywordOperator Keyword") -- not, in
        vim.cmd("highlight! link TSOperator GruvboxRed")
        vim.cmd("highlight! link TSFunction GruvboxAqua")
        vim.cmd("highlight! link TSMethod GruvboxAqua")
        vim.cmd("highlight! clear TSError")

        -- misc
        vim.cmd("highlight! link DiffChange GruvboxBlue") -- for gitsigns
      end
    }
    use {
      "Murtaza-Udaipurwala/gruvqueen",
      config = function()
        -- require("gruvqueen").setup {
        --   config = {
        --     invert_selection = true,
        --     style = "original",
        --     -- transparent_background = true
        --   },
        --   palette = {
        --     bg1 = "#282828",
        --     grey0 = "#7c6f64"
        --   }
        -- }
        -- vim.cmd("colorscheme gruvqueen")
      end
    }

    -- use { "romgrk/barbar.nvim",
    --   requires = "kyazdani42/nvim-web-devicons",
    --   config = function()
    --     local map = require("tb.utils").map
    --     map("nx", "K", ":BufferNext<CR>")
    --     map("nx", "J", ":BufferPrevious<CR>")
    --   end
    -- }
    use {
      "akinsho/nvim-bufferline.lua",
      requires = "kyazdani42/nvim-web-devicons",
      after = {"gruvbox.nvim", "gruvqueen"},
      config = function()
        local colors = require("bufferline.colors")
        local hex = colors.get_hex
        local shade = colors.shade_color

        local normal_bg = hex({name = "Normal", attribute = "bg"})
        local separator_background_color = shade(normal_bg, -27)
        local background_color = shade(normal_bg, -18)

        require("bufferline").setup {
          highlights = {
            buffer_selected = {gui = "bold"},
            background = {guibg = background_color},
            fill = {guibg = separator_background_color},
            indicator_selected = {
              guifg = {attribute = "fg", highlight = "GruvboxBlue"}
            },
            separator = {
              guifg = separator_background_color,
              guibg = background_color
            },
            tab = {guibg = background_color},
            tab_close = {guibg = background_color},
            close_button = {guibg = background_color},
            modified = {guibg = background_color}
          },
          options = {
            always_show_bufferline = false,
            enforce_regular_tabs = true,
            -- modified_icon = require("tb.icons").file.mod,
            show_buffer_close_icons = false,
            show_close_icon = false
          }
        }

        local map = require("tb.utils").map
        map("nx", "K", ":BufferLineCycleNext<CR>", {silent = true})
        map("nx", "J", ":BufferLineCyclePrev<CR>", {silent = true})
      end
    }

    use {
      "hoob3rt/lualine.nvim",
      requires = {"kyazdani42/nvim-web-devicons"},
      after = {"gruvbox.nvim", "gruvqueen"},
      config = function()
        local i = require("tb.icons")

        require("lualine").setup {
          sections = {
            lualine_a = {"mode"},
            lualine_b = {
              {"branch", icon = ""}
            },
            lualine_c = {
              {
                "diff",
                symbols = {
                  added = i.diff.add_,
                  modified = i.diff.mod_,
                  removed = i.diff.del_
                }
              },
              {
                "filename",
                symbols = {modified = i.file._mod, readonly = i.file._lock}
              }
            },
            lualine_x = {
              {
                "diagnostics",
                sources = {"nvim_lsp"},
                color_info = "#83a598",
                symbols = {
                  error = i.diag.error_,
                  warn = i.diag.warn_,
                  info = i.diag.info_,
                  hint = i.diag.hint_
                }
              },
              -- "encoding",
              -- "fileformat",
              "filetype"
            },
            lualine_y = {"progress"},
            lualine_z = {"location"}
          },
          extensions = {"fugitive"}
        }
      end
    }

    -- TODO: Find out wtf is going on with the lines (and barbar) colors
    --       changing on autocmd to PackerCompile.
    use {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        local i = require("tb.icons")

        vim.opt.colorcolumn = "80" -- highlight bug hack fix
        vim.g.indent_blankline_char = i.bar.thin
        vim.g.indent_blankline_buftype_exclude = {"help", "terminal"}
        vim.g.indent_blankline_filetype_exclude = {"text", "markdown"}
        -- vim.g.indent_blankline_show_end_of_line = true
        vim.g.indent_blankline_show_first_indent_level = false
        vim.g.indent_blankline_show_trailing_blankline_indent = false
      end
    }

    use {
      "edluffy/specs.nvim",
      config = function()
        -- vim.cmd("highlight SpecsWinHl guibg=#1D2021")
        require("specs").setup {
          min_jump = 20,
          popup = {
            inc_ms = 5,
            blend = 50,
            winhl = "PMenuThumb"
            -- winhl = "SpecsWinHl"
          }
        }
      end
    }

    use {
      "timbedard/vim-envelop",
      run = ":EnvCreate",
      config = function()
        require("tb.envelop")
      end
    }

    use {
      "sumneko/lua-language-server",
      run = {
        "cd 3rd/luamake && ./compile/install.sh && cd ../../ && 3rd/luamake/luamake rebuild"
        -- "cd 3rd/luamake && ./compile/install.sh",
        -- "3rd/luamake/luamake rebuild"
      }
    }

    use {
      "neovim/nvim-lspconfig",
      -- TODO: Get this working
      -- rocks = {"luaformatter", server = "https://luarocks.org/dev"},
      config = function()
        require("tb.lsp")
        local utils = require("tb.utils")
        local o = {silent = true}
        utils.map("n", "<leader>k", "<Cmd>lua vim.lsp.buf.hover()<CR>", o)
        utils.map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", o)
        utils.map("n", "1gd", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", o)
        -- utils.map("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", o)
        utils.map("n", "g0", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", o)
        utils.map("n", "gf", "<Cmd>lua vim.lsp.buf.formatting()<CR>", o)
      end
    }

    use {
      "glepnir/lspsaga.nvim",
      after = {"gruvbox.nvim", "gruvqueen"},
      config = function()
        require("tb.lspsaga")

        local utils = require("tb.utils")
        local o = {silent = true}
        utils.map("n", "gh", ":Lspsaga lsp_finder<CR>", o)
        utils.map("n", "<leader>ca", ":Lspsaga code_action<CR>", o)
        -- utils.map("n", "<leader>k", ":Lspsaga hover_doc<CR>", o)
        utils.map("n", "gs", ":Lspsaga signature_help<CR>", o)
        utils.map("n", "gr", ":Lspsaga rename<CR>", o)
        utils.map("n", "gD", ":Lspsaga preview_definition<CR>", o)
        utils.map("n", "<leader>cd", ":Lspsaga show_line_diagnostics<CR>", o)
        utils.map("n", "[d", ":Lspsaga diagnostic_jump_prev<CR>", o)
        utils.map("n", "]d", ":Lspsaga diagnostic_jump_next<CR>", o)
      end
    }

    use {
      "onsails/lspkind-nvim",
      config = function()
        local i = require("tb.icons")

        require("lspkind").init {
          symbol_map = {
            Class = i.lang.class,
            Color = i.lang.color,
            Constant = i.lang.constant,
            Constructor = i.lang.constructor,
            Enum = i.lang.enum,
            EnumMember = i.lang.enummember,
            Event = i.lang.event,
            Field = i.lang.field,
            File = i.lang.file,
            Folder = i.lang.folder,
            Function = i.lang["function"],
            Interface = i.lang.interface,
            Keyword = i.lang.keyword,
            Method = i.lang.method,
            Module = i.lang.module,
            Operator = i.lang.operator,
            Property = i.lang.property,
            Reference = i.lang.reference,
            Snippet = i.lang.snippet,
            Struct = i.lang.struct,
            Text = i.lang.text,
            TypeParameter = i.lang.typeparameter,
            Unit = i.lang.unit,
            Value = i.lang.value,
            Variable = i.lang.variable
          }
        }
      end
    }

    use {
      "hrsh7th/nvim-cmp",
      requires = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lua"},
      after = "lspkind-nvim",
      config = function()
        require("cmp_nvim_lsp").setup()
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        cmp.setup {
          formatting = {
            format = function(entry, vim_item)
              vim_item.kind = lspkind.presets.default[vim_item.kind]
              return vim_item
            end
          },
          min_length = 0, -- allow for `from package import _` in Python
          mapping = {
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close()
            -- This is handled by nvim-autopairs.
            -- ["<CR>"] = cmp.mapping.confirm {
            --   behavior = cmp.ConfirmBehavior.Replace,
            --   select = true
            -- }
          },
          sources = {
            {name = "nvim_lsp"},
            {name = "nvim_lua"}
          }
        }
      end
    }

    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        local i = require("tb.icons")

        require("trouble").setup {
          signs = {
            error = i.diag.error,
            warning = i.diag.warn,
            hint = i.diag.hint,
            information = i.diag.info,
            other = i.diag.pass
          }
        }
      end
    }

    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzy-native.nvim",
        "nvim-telescope/telescope-github.nvim"
        -- "nvim-telescope/telescope-packer.nvim"  -- currently breaking packer
      },
      config = function()
        require("tb.telescope")
        vim.api.nvim_set_keymap(
          "n",
          "<Leader><Leader>",
          "<cmd>lua require('telescope.builtin').builtin()<CR>",
          {noremap = true, silent = true}
        )
        vim.api.nvim_set_keymap(
          "n",
          "<C-p>",
          "<cmd>lua require('tb.telescope').project_files()<CR>",
          {noremap = true, silent = true}
        )
        vim.api.nvim_set_keymap(
          "n",
          "<C-b>",
          "<cmd>lua require('telescope.builtin').buffers()<CR>",
          {noremap = true, silent = true}
        )
      end
    }

    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {}
      end
    }

    use {"norcalli/nvim-colorizer.lua", opt = true, ft = {"css", "html"}}

    use {
      "liuchengxu/vista.vim",
      config = function()
        local i = require("tb.icons")

        vim.g["vista#renderer#icons"] = {
          class = i.lang.class,
          color = i.lang.color,
          constant = i.lang.constant,
          constructor = i.lang.constructor,
          enum = i.lang.enum,
          enummember = i.lang.enummember,
          event = i.lang.event,
          field = i.lang.field,
          file = i.lang.file,
          folder = i.lang.folder,
          ["function"] = i.lang["function"],
          interface = i.lang.interface,
          keyword = i.lang.keyword,
          method = i.lang.method,
          module = i.lang.module,
          operator = i.lang.operator,
          property = i.lang.property,
          reference = i.lang.reference,
          snippet = i.lang.snippet,
          struct = i.lang.struct,
          text = i.lang.text,
          typeparameter = i.lang.typeparameter,
          unit = i.lang.unit,
          value = i.lang.value,
          variable = i.lang.variable
        }
      end
    }

    use {
      "justinmk/vim-dirvish",
      config = function()
        vim.g.loaded_netrwPlugin = 1
      end
    }

    use {
      "iamcco/markdown-preview.nvim",
      run = ":call mkdp#util#install()",
      ft = "markdown"
    }

    use {
      "kshenoy/vim-signature",
      config = function()
        -- only supports vim-gitgutter
        -- vim.g.SignatureMarkTextHLDynamic = 1
      end
    }

    use {
      "unblevable/quick-scope",
      config = function()
        vim.g.qs_highlight_on_keys = {"f", "F", "t", "T"}
      end
    }

    use {
      "ntpeters/vim-better-whitespace",
      config = function()
        vim.g.better_whitespace_enabled = 0
        vim.g.strip_whitelines_at_eof = 1
        vim.cmd("command! Trim StripWhitespace")
      end
    }

    use {
      "lewis6991/gitsigns.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        -- local i = require("tb.icons")

        require("gitsigns").setup {
          -- TODO: maybe change this now that gruvbox.nvim highlights have changed
          -- signs = {
          --   add = {hl = "DiffAdd", text = i.bar.thick},
          --   change = {hl = "DiffChange", text = i.bar.thick},
          --   changedelete = {hl = "GruvboxOrange", text = i.bar.thick},
          --   delete = {hl = "DiffDelete"},
          --   topdelete = {hl = "DiffDelete"}
          -- },
          sign_priority = 0
        }
        vim.opt.signcolumn = "yes"
      end
    }

    use {
      "andymass/vim-matchup",
      config = function()
        vim.g.matchup_matchparen_offscreen = {}
      end
    }

    use {
      "windwp/nvim-autopairs",
      after = "nvim-cmp",
      config = function()
        require("nvim-autopairs").setup {}

        -- handle <CR> mapping with nvim-cmp
        require("nvim-autopairs.completion.cmp").setup {
          map_cr = true, --  map <CR> on insert mode
          map_complete = true -- insert `(` when function/method is completed
        }
      end
    }

    use {
      "Glench/Vim-Jinja2-Syntax",
      opt = true,
      ft = {"html", "jinja"}
    }

    use "romainl/vim-cool"
    use "farmergreg/vim-lastplace"

    use "tpope/vim-commentary"
    use "tpope/vim-surround"
    use "tpope/vim-repeat"
    use "tpope/vim-eunuch"
    use "tpope/vim-abolish"
    use "tpope/vim-fugitive"
    use "tpope/vim-rhubarb"
    use "tpope/vim-unimpaired"

    use "wellle/targets.vim"
    use {"kana/vim-textobj-line", requires = "kana/vim-textobj-user"}
    use "michaeljsmith/vim-indent-object"
    use "AndrewRadev/splitjoin.vim"

    use "Vimjas/vim-python-pep8-indent"
    use "sophacles/vim-bundle-mako"

    -- use {
    --   "sheerun/vim-polyglot",
    --   opt = true,
    --   event = "VimEnter *",
    --   setup = function()
    --     vim.g.polyglot_disabled = {"helm", "python"}
    --   end,
    --   config = function()
    --     vim.g.javascript_plugin_jsdoc = 1
    --     vim.g.vim_markdown_frontmatter = 1
    --     vim.g.vim_markdown_new_list_item_indent = 2
    --   end
    -- }

    use "janko-m/vim-test"
    -- use "hkupty/iron.nvim"
  end,
  config = {
    python_cmd = "python3"
  }
}
