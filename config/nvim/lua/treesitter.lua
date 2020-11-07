-- TODO: To enable TS syntax-based code folding:
-- set foldmethod=expr
-- set foldexpr=nvim_treesitter#foldexpr()

require'nvim-treesitter.configs'.setup {

  -- TODO: Try switching from other tools to TS-based solutions

  -- highlight = {
  --   enable = true,
  --   use_languagetree = false, -- Use this to enable language injection (this is very unstable)
  -- },

  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     init_selection = "gnn",
  --     node_incremental = "grn",
  --     scope_incremental = "grc",
  --     node_decremental = "grm",
  --   },
  -- },

  -- indent = { enable = true },

  --- nvim-treesitter-refactor ---
  -- refactor = {
  --   highlight_current_scope = { enable = false },
  --   highlight_definitions = { enable = true },
  --   navigation = {
  --     enable = true,
  --     keymaps = {
  --       goto_definition = "gnd",
  --       list_definitions = "gnD",
  --       list_definitions_toc = "gO",
  --       goto_next_usage = "<a-*>",
  --       goto_previous_usage = "<a-#>",
  --     },
  --   },
  -- },

  --- nvim-treesitter-textobjects ---
  -- textobjects = {
  --   move = {
  --     enable = true,
  --     goto_next_start = {
  --       ["]m"] = "@function.outer",
  --       ["]]"] = "@class.outer",
  --     },
  --     goto_next_end = {
  --       ["]M"] = "@function.outer",
  --       ["]["] = "@class.outer",
  --     },
  --     goto_previous_start = {
  --       ["[m"] = "@function.outer",
  --       ["[["] = "@class.outer",
  --     },
  --     goto_previous_end = {
  --       ["[M"] = "@function.outer",
  --       ["[]"] = "@class.outer",
  --     },
  --   },
  --   select = {
  --     enable = true,
  --     keymaps = {
  --       -- You can use the capture groups defined in textobjects.scm
  --       ["af"] = "@function.outer",
  --       ["if"] = "@function.inner",
  --       ["ac"] = "@class.outer",
  --       ["ic"] = "@class.inner",

  --       -- Or you can define your own textobjects like this
  --       ["iF"] = {
  --         python = "(function_definition) @function",
  --         cpp = "(function_definition) @function",
  --         c = "(function_definition) @function",
  --         java = "(method_declaration) @function",
  --       },
  --     },
  --   },
  --   swap = {
  --     enable = true,
  --     swap_next = {
  --       ["<leader>a"] = "@parameter.inner",
  --     },
  --     swap_previous = {
  --       ["<leader>A"] = "@parameter.inner",
  --     },
  --   },
  -- },

}
