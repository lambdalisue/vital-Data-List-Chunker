function! s:new(chunk_size, candidates) abort
  return extend(deepcopy(s:chunker), {
        \ 'candidates': a:candidates,
        \ 'chunk_size': a:chunk_size,
        \ 'length': len(a:candidates),
        \})
endfunction


let s:chunker = {
      \ 'chunk_size': 0,
      \ 'candidates': [],
      \ 'length': 0,
      \ 'cursor': 0,
      \}

function! s:chunker.next() abort
  let prev_cursor = self.cursor
  let self.cursor = self.cursor + self.chunk_size
  return self.candidates[ prev_cursor : self.cursor - 1 ]
endfunction
