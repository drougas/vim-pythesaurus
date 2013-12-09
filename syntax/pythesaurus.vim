" Vim plugin for looking up words on thesaurus.com
" Author:       Yannis Drougas <http://drougas@cs.ucr.edu>
" Version:      0.1
" Original idea and code:
"   Anton Beloglazov <http://beloglazov.info/>
"   Nick Coleman <http://www.nickcoleman.org/>

if exists("b:current_syntax")
    finish
endif

" Setup
syntax case match
setlocal iskeyword+=:

" Entry name rules
syntax match thesMainEntry /Main Entry: */ contained
syntax keyword thesDefinition Definition:
syntax keyword thesSynonyms Synonyms:
syntax keyword thesAntonyms Antonyms:

" Entry contents rules
syntax region thesMainWord start=/Main Entry:/  end=/$/ contains=CONTAINED keepend

" Highlighting
hi link thesMainEntry  Keyword
hi link thesDefinition Keyword
hi link thesSynonyms   Keyword
hi link thesAntonyms   Keyword
hi thesMainWord        term=bold cterm=bold gui=bold

let b:current_syntax = "pythesaurus"
