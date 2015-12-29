if !executable('rubocop')
  finish
endif

command! -buffer -nargs=0 RubyFmt call rubyfmt#Format()
