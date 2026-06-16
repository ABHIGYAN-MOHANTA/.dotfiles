return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          -- This specifically fixes the "diagnostics stuck on save" bug in Neovim 0.10+
          -- by disabling the workspace file watcher that overwhelms gopls.
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = false,
              },
            },
          },
        },
      },
    },
  },
}
