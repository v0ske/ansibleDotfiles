local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})


-- Jenkinsfile use groovy syntax
autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.Jenkinsfile",
  command = "setf groovy",
})
-- puppet use pp syntax
autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.pp",
  command = "setf puppet",
})
