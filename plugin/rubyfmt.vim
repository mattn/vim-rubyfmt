if !executable('rubocop') || !get(g:, "rubyfmt_auto", 1)
  finish
endif

augroup RubyFmt
  au!
  autocmd BufWritePost *.rb call rubyfmt#Format()
augroup END
