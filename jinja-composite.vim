" Vim syntax file
" Language:	Jinja composite syntax template
" Maintainer:	jaseg <s@jaseg.de>
" Last Change:	27 Sep 2012
" Version:      1.23
"
" Known Bugs:
"   because of odd limitations dicts and the modulo operator
"   appear wrong in the template.
"
" Changes:
"
"     2008 May 9:     Added support for Jinja2 changes (new keyword rules)
"     2012 Sep 27:    Added support for language-jinja composite syntaxes

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'jinja'
endif

if !exists("g:jinja_default_subtype")
  let g:jinja_default_subtype = "html"
endif

if !exists("b:jinja_subtype") && main_syntax == 'jinja'
  let s:lines = getline(1)."\n".getline(2)."\n".getline(3)."\n".getline(4)."\n".getline(5)."\n".getline("$")
  let b:jinja_subtype = matchstr(s:lines,'jinja_subtype=\zs\w\+')
  if b:jinja_subtype == ''
    let b:jinja_subtype = matchstr(&filetype,'^jinja\.\zs\w\+')
  endif
  if b:jinja_subtype == ''
    let b:jinja_subtype = matchstr(substitute(expand("%:t"),'\c\%(\.jj\|\.jinja\)\+$','',''),'\.\zs\w\+$')
  endif
  if b:jinja_subtype == 'txt'
    " Conventional; not a real file type
    let b:jinja_subtype = 'text'
  elseif b:jinja_subtype == ''
    let b:jinja_subtype = g:jinja_default_subtype
  endif
endif

if !exists("b:jinja_nest_level")
  let b:jinja_nest_level = strlen(substitute(substitute(substitute(expand("%:t"),'@','','g'),'\c\.\%(erb\|rhtml\)\>','@','g'),'[^@]','','g'))
endif
if !b:jinja_nest_level
  let b:jinja_nest_level = 1
endif

if exists("b:jinja_subtype") && b:jinja_subtype != ''
  exe "runtime! syntax/".b:jinja_subtype.".vim"
  unlet! b:current_syntax
endif

syntax case match

syn include @jinjaTop syntax/jinja.vim

" Jinja template tag and variable blocks
syn region jinjaTagBlock matchgroup=jinjaTagDelim start=/{%-\?/ end=/-\?%}/ skipwhite containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaRaw,jinjaString,jinjaNested,jinjaComment

syn region jinjaVarBlock matchgroup=jinjaVarDelim start=/{{-\?/ end=/-\?}}/ containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaRaw,jinjaString,jinjaNested,jinjaComment

" Jinja template 'raw' tag
syn region jinjaRaw matchgroup=jinjaRawDelim start="{%\s*raw\s*%}" end="{%\s*endraw\s*%}" containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment

" Jinja comments
syn region jinjaComment matchgroup=jinjaCommentDelim start="{#" end="#}" containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaString

" Block start keywords.  A bit tricker.  We only highlight at the start of a
" tag block and only if the name is not followed by a comma or equals sign
" which usually means that we have to deal with an assignment.
syn match jinjaStatement containedin=jinjaTagBlock contained skipwhite /\({%-\?\s*\)\@<=\<[a-zA-Z_][a-zA-Z0-9_]*\>\(\s*[,=]\)\@!/

" and context modifiers
syn match jinjaStatement containedin=jinjaTagBlock contained /\<with\(out\)\?\s\+context\>/ skipwhite


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_jinja_syn_inits")
  if version < 508
    let did_jinja_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink jinjaPunctuation jinjaOperator
  HiLink jinjaAttribute jinjaVariable
  HiLink jinjaFunction jinjaFilter

  HiLink jinjaTagDelim jinjaTagBlock
  HiLink jinjaVarDelim jinjaVarBlock
  HiLink jinjaCommentDelim jinjaComment
  HiLink jinjaRawDelim jinja

  HiLink jinjaSpecial Special
  HiLink jinjaOperator Normal
  HiLink jinjaRaw Normal
  HiLink jinjaTagBlock PreProc
  HiLink jinjaVarBlock PreProc
  HiLink jinjaStatement Statement
  HiLink jinjaFilter Function
  HiLink jinjaBlockName Function
  HiLink jinjaVariable Identifier
  HiLink jinjaString Constant
  HiLink jinjaNumber Constant
  HiLink jinjaComment Comment

  delcommand HiLink
endif

if main_syntax == 'jinja'
  unlet main_syntax
endif

let b:current_syntax = "jinja"
