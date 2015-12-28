function! rubyfmt#Format() abort
  let curw = winsaveview()
  let tmpname = tempname()
  call writefile(getline(1, '$'), tmpname)
  let command = "rubocop --auto-correct"
  let out = system(command . " " . tmpname)
  if v:shell_error == 0
    try | silent undojoin | catch | endtry
    let old_fileformat = &fileformat
    call rename(tmpname, expand('%'))
    silent noau edit!
    let &fileformat = old_fileformat
    let &syntax = &syntax
  else
    let errors = []
    for line in split(out, '\n')
      let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\(\d\+\):\s*\(.*\)')
      if len(tokens) > 1
        call add(errors, {"filename": @%,
        \"lnum":     tokens[2],
        \"col":      tokens[3],
        \"text":     tokens[4]})
      endif
    endfor
    if !empty(errors)
      call setqflist(errors)
      cwindow
    endif
    call delete(tmpname)
  endif
  call winrestview(curw)
endfunction
