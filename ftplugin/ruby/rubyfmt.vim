if get(g:, "rubyfmt_auto", 1)
    autocmd BufWritePre *.rb call rubyfmt#Format()
endif

command! -buffer -nargs=0 RubyFmt call rubyfmt#Format()
