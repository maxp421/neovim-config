local null_ls = require("null-ls")

null_ls.setup({
    sources = {
      -- https://github.com/fsouza/prettierd 
      -- needs to be installed via npm first
       null_ls.builtins.formatting.prettierd,
    },
})
