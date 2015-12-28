if get(g:, "rubyfmt_auto", 1)
  augroup RubyFmt
    au!
    autocmd BufWritePost *.rb call rubyfmt#Format()
  augroup END
endif

command! -buffer -nargs=0 RubyFmt call rubyfmt#Format()
