" Vim plugin for looking up words on thesaurus.com
" Author:       Yannis Drougas <http://drougas@cs.ucr.edu>
" Version:      0.1
" Original idea and code:
"   Anton Beloglazov <http://beloglazov.info/>
"   Nick Coleman <http://www.nickcoleman.org/>

if exists('g:loaded_pythesaurus') || !has('python')
    finish
endif
let g:loaded_pythesaurus = 1

let s:save_cpo = &cpo
set cpo&vim

let s:path = escape(expand('<sfile>:p:h'), ' \')

function! s:Lookup(word)
    silent keepalt belowright split pythesaurus
    setlocal noswapfile nobuflisted nospell nowrap modifiable
    setlocal buftype=nofile bufhidden=hide
    1,$d
    exec 'pyfile ' . s:path . '/pythesaurus.py'
    normal! ggVGgqgg
    exec 'resize ' . line('$')
    setlocal nomodifiable filetype=pythesaurus
    nnoremap <silent> <buffer> q :q<CR>
endfunction

command! PyThesaurusCurrentWord :call <SID>Lookup(expand('<cword>'))
command! -nargs=1 PyThesaurus :call <SID>Lookup(<f-args>)

let &cpo = s:save_cpo
