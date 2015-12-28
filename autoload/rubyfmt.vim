function! rubyfmt#Format() abort
  try
    let curw = winsaveview()
    if &modified | noau update | endif
    let old_fileformat = &fileformat
    let lines = split(system('rubocop -a' . ' ' . expand('%')), '\n')
    silent edit!
    let &fileformat = old_fileformat
    let &syntax = &syntax
    if v:shell_error == 0
      try | silent undojoin | catch | endtry
      return
    endif
    let errors = []
    for line in lines
      let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\(\d\+\):\s*\(.*\)')
      if len(tokens) > 1
        call add(errors, {
        \"filename": tokens[1],
        \"lnum":     tokens[2],
        \"col":      tokens[3],
        \"text":     tokens[4]})
      endif
    endfor
    if !empty(errors)
      call setqflist(errors)
      copen | cc
    endif
  finally
    call winrestview(curw)
  endtry
endfunction
