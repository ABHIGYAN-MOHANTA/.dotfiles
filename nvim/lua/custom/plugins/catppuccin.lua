return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      styles = {
        comments = { "italic" },
        conditionals = { "bold" },
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
      },
      color_overrides = {},
      custom_highlights = {},
      integrations = {
        aerial = true,
        alpha = false,
        barbar = false,
        beacon = false,
        cmp = true,
        coc_nvim = false,
        dashboard = false,
        fern = false,
        fidget = false,
        gitgutter = false,
        gitsigns = true,
        harpoon = false,
        headlines = false,
        hop = false,
        illuminate = false,
        leap = false,
        lightspeed = false,
        lsp_saga = false,
        lsp_trouble = false,
        markdown = true,
        mason = false,
        mini = false,
        neogit = false,
        neotest = false,
        neotree = false,
        noice = true,
        notify = true,
        nvimtree = false,
        octo = false,
        overseer = false,
        pounce = false,
        sandwich = false,
        semantic_tokens = false,
        symbols_outline = false,
        telekasten = false,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        ts_rainbow = true,
        ts_rainbow2 = false,
        vim_sneak = false,
        vimwiki = false,
        which_key = true,
        barbecue = {
          dim_dirname = true,
          bold_basename = true,
          dim_context = false,
          alt_background = false,
        },
        dap = {
          enabled = false,
          enable_ui = false,
        },
        indent_blankline = {
          enabled = false,
          colored_indent_levels = false,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = {},
            hints = {},
            warnings = {},
            information = {},
          },
        },
        navic = {
          enabled = false,
          custom_bg = "NONE",
        },
      },
      highlight_overrides = {
        mocha = function(colors)
          return {
            -- remove italics
            ["@parameter"] = { fg = colors.maroon, style = {} },
            ["@text.literal"] = { fg = colors.teal, style = {} },
            ["@text.uri"] = { fg = colors.rosewater, style = { "underline" } },
            -- alpha
            AlphaButton = { fg = colors.blue },
            AlphaButtonShortcut = { fg = colors.sapphire },
            AlphaCol1 = { fg = colors.red },
            AlphaCol2 = { fg = colors.rosewater },
            AlphaCol3 = { fg = colors.yellow },
            AlphaCol4 = { fg = colors.green },
            AlphaCol5 = { fg = colors.sky },
            AlphaCol6 = { fg = colors.flamingo },
            AlphaCol7 = { fg = colors.pink },
            AlphaCol8 = { fg = colors.mauve },
            AlphaCol9 = { fg = colors.maroon },
            AlphaCol10 = { fg = colors.peach },
            AlphaCol11 = { fg = colors.teal },
            AlphaQuote = { fg = colors.lavender, style = { "italic" } },
            -- scnvim
            SCNvimEval = { fg = colors.base, bg = colors.lavender },
            -- tidal
            TidalEval = { fg = colors.base, bg = colors.lavender },
            -- luasnip
            LuaSnipChoiceNode = { fg = colors.yellow, style = { "bold" } },
            LuaSnipInsertNode = { fg = colors.white, style = { "bold" } },
            -- telescope
            TelescopePromptPrefix = { bg = colors.crust },
            TelescopePromptNormal = { bg = colors.crust },
            TelescopeResultsNormal = { bg = colors.mantle },
            TelescopePreviewNormal = { bg = colors.crust },
            TelescopePromptBorder = { bg = colors.crust, fg = colors.crust },
            TelescopeResultsBorder = { bg = colors.mantle, fg = colors.crust },
            TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
            -- TelescopePromptTitle = { fg = colors.crust },
            -- TelescopeResultsTitle = { fg = c.olorstext },
            -- TelescopePreviewTitle = { fg = colors.crust },
          }
        end,
      },
    },
  }