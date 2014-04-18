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
let s:buf_name = 'PyThesaurus results'

function! s:Lookup(word)
    let l:buf_num = bufnr(s:buf_name)
    if l:buf_num > 0
        exec 'bdelete! ' . l:buf_num
    endif
    exec 'silent keepalt belowright split ' . escape(s:buf_name, ' ')
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
