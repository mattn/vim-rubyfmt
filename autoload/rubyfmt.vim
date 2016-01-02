function! rubyfmt#Format() abort
  try
    let curw = winsaveview()
    if &modified | noau update | endif
    let old_fileformat = &fileformat
    let lines = split(system('rubocop -a' . ' ' . shellescape(expand('%'))), '\n')
    silent edit!
    let &syntax = &syntax
    if v:shell_error == 0
      try | silent undojoin | catch | endtry
      return
    endif
    let errors = []
    for line in lines
      let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\(\d\+\):\s*\([A-Z]\):\s*\(.*\)')
      if len(tokens) > 1
        let tokens[4] = tr(tokens[4], 'C', 'I')
        call add(errors, {
        \"filename": tokens[1],
        \"lnum":     tokens[2],
        \"col":      tokens[3],
        \"type":     tokens[4],
        \"text":     tokens[5]})
      endif
    endfor
    if !empty(errors)
      call setqflist(errors)
      if get(g:, "rubyfmt_autoopen", 1)
        copen | cc
      end
    endif
  finally
    call winrestview(curw)
  endtry
endfunction
