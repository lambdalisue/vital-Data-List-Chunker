vital-Data-List-Chunker
==============================================================================
[![Travis CI](https://img.shields.io/travis/lambdalisue/vital-Data-List-Chunker/master.svg?style=flat-square&label=Travis%20CI)](https://travis-ci.org/lambdalisue/vital-Data-List-Chunker)
[![AppVeyor](https://img.shields.io/appveyor/ci/lambdalisue/vital-Data-List-Chunker/master.svg?style=flat-square&label=AppVeyor)](https://ci.appveyor.com/project/lambdalisue/vital-Data-List-Chunker/branch/master)
![Version 0.1.0](https://img.shields.io/badge/version-0.1.0-yellow.svg?style=flat-square)
![Support Vim 7.4.2137 or above](https://img.shields.io/badge/support-Vim%207.4.2137%20or%20above-yellowgreen.svg?style=flat-square)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20Vital.Data.List.Chunker-orange.svg?style=flat-square)](doc/vital-data-list-chunker.txt)

A vital module to split a large list into several chunks.

```vim
let Chunker = vital#vital#import('Data.List.Chunker')
let chunk_size = 10
let candidates = range(55)
let chunker = Chunker.new(chunk_size, candidates)

echo chunker.next()
" -> [0, 1, 2, ..., 9]
echo chunker.next()
" -> [10, 11, 12, ..., 19]
echo chunker.next()
" -> [20, 21, 22, ..., 29]
echo chunker.next()
" -> [30, 31, 32, ..., 39]
echo chunker.next()
" -> [40, 41, 42, ..., 49]
echo chunker.next()
" -> [50, 51, 52, ..., 54]
echo chunker.next()
" -> []
```

It may used to improve the initial response like:

```vim
let s:Chunker = vital#vital#import('Data.List.Chunker')

function! Test() abort
  let candidates = range(1000)
  let chunker = Chunker.new(10, candidates)
  let chunker.bufnum = bufnr('%')

  if exists('s:timer_id')
    call timer_stop(s:timer_id)
  endif
  let s:timer_id = timer_start(
        \ 0,
        \ function('s:timer_callback', [chunker])
        \)
endfunction

function! s:timer_callback(chunker, timer_id) abort
  if a:chunker.bufnum != bufnr('%')
    " The focus has moved to a differnt bufferso stop iteration.
    return
  endif

  let candidates = a:chunker.next()
  if empty(candidates)
    " There is no candidate left. Stop iteration.
    return
  endif

  let candidates = map(a:chunker.next(), 's:parse_candidate(v:val)')
  call append(line('$'), candidates)
  let s:timer_id = timer_start(
        \ 100,
        \ function('s:timer_callback', [chunker])
        \)
endfunction

function! s:parse_candidate(candidate) abort
  " Assume that parsing is a really heavy process
  sleep 1m
  return string(a:candidate)
endfunction
```

Without chunker, it requires approx. 1000 x 1 ms to get the initial response.
Using chunker reduce this initial response to approx. 10 x 1 ms so users would feel that the response has improved.
Note that the total procession time would become longer with chunker.
