local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'rust_analyzer',
  'lua_ls',
  'eslint',
  'html',
  'emmet_ls',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

--Turn on when debugging into logs is needed
--vim.lsp.set_log_level("debug")

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

-- make emmet_ls lower priority so lsp firt suggests autocomplete, then emmet snippets
-- https://www.reddit.com/r/neovim/comments/woih9n/how_to_set_lsp_autocomplete_priority/
-- I had the exact same issue. Changes the order of the sources didn't really work for me since the emmet snippets are coming from the nvim_lsp source not for 
-- a snippet source and I still want lsp autocompletes to be of a high priority. I just want to de-prioritize emmet stuff.
-- What I did was to write a custom comparison function and pass it to cmp's sorting.comparators setting. Like so 

local types = require("cmp.types")

local function deprioritize_snippet(entry1, entry2)
  if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then return false end
  if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then return true end
end

cmp.setup({
  -- your config
  sorting = {
    priority_weight = 2,
    comparators = {
      deprioritize_snippet,
      -- the rest of the comparators are pretty much the defaults
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.scopes,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

--This will put lsp snippets at the very bottom, so it's out of the way but still pretty easy to access.
--There's probably a more elegant solution, but it's good enough for me. 

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
