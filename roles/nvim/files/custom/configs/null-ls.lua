local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- python
  b.formatting.autoflake,
  b.formatting.autopep8,

  -- terraform
  b.formatting.terraform_fmt,

  -- yaml
  b.formatting.yamlfmt,
  -- puppet
  b.diagnostics.puppet_lint,
  b.formatting.puppet_lint,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
