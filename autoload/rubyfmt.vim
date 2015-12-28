function! rubyfmt#Format() abort
  let curw = winsaveview()
  let command = 'rubocop --auto-correct'
  let lines = split(system(command . ' ' . expand('%')), '\n')
  if v:shell_error == 0
    try | silent undojoin | catch | endtry
    silent! %d _
    call setline(1, lines)
  else
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
      cwindow
    endif
  endif
  call winrestview(curw)
endfunction
