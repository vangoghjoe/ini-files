" These are items that apply only for me
"----------------------------------------------------
"--------          SETTINGS
"----------------------------------------------------
" this is the what will be called to compile
" using vim's quick-fix feature
" see the user command "Make" below, also
set nocompatible
if has("win32")
    source $VIMRUNTIME/mswin.vim
    behave mswin
endif
set nobackup

cnoremap <c-a> <home>
cnoremap <c-e> <end>

" backwards-char on h
" backwards-kill-char on u
" backwards-word on g
" backwards-kill-word on f
noremap! <c-u> <bs>
noremap! <c-g> <c-o>b
noremap! <c-f> <c-w>

" 'myfiletypes' holds definition of mumps file
let myfiletypefile="$VIMRUNTIME/myfiletypes.vim"

" report  even if only 1 line changed
set report=0

" turn syntax highlighting on
syn on
set number 
set ai
set ts=4
set sw=4
set nohlsearch

" turn on filetype plugins
filetype plugin on

"set textwidth=60

" ignore case in searching
set ignorecase
 
" don't show ruler
set noruler

" don't show commands as being typed
set noshowcmd

" will take you to a match as you type
set incsearch

" easier opening new buffers
set hidden
set iskeyword=@,48-57,_,192-255


highlight LineNr term=bold

:set selectmode=key

"--  Set the characters to be shown in list-mode (ie, set list)
set lcs=eol:$,tab:>-

"--  Terminal can only be vt320 if it's E-term, which means
"--  it supports color-setting escape sequences.
"if ( &term == "vt320" || &term == "ivt" || &term== "xterm")
"	if filereadable(expand("~/.exrc.colorterm"))
"	endif
"endif

"-- Use spaces instead of tabs for indents
set expandtab

"_________________________________________________________________

"----------------------------------------------------
"--------          NORMAL MODE MAPS
"----------------------------------------------------
" save and execute this file
noremap <f10> :w! \| ! %:p

" type N<BS> to go to buffer N
noremap <BS> <C-^>

" go position in file last time it was closed
:com! L :normal '0

" generally want to return to the exact place in the line
" so map the function to the easier key to hit
noremap ' `
noremap ` '
noremap <C-N> <Esc>
"*****************            F7 => toggle hlsearch
nnoremap <F7> :set hlsearch!

"*****************           <C-K> ==> start ex-mode at last command
nmap <C-K> :<up>

nmap <F11> :w \| so %<CR>

"*****************            * => exec line under cursor as ex cmd
noremap * Y:exe @"<CR>


"*****************            k / j => gk / gj  AND K /J => k / j
"*****************              gk / gj  handle wrapped lines      
noremap k gk
noremap j gj
noremap J j
noremap K k

noremap <CR> G

noremap 0 ^
noremap ^ 0

"*****************            J => (probably on by mistake)
"nnoremap J :echo "****  Caps on ****"<CR>
"

"----------------------------------------------------
"--------          VISUAL MODE MAPS
"----------------------------------------------------
"*****************           <C-K> ==> start ex-mode at last command
vnoremap <C-K> :<up>

"----------------------------------------------------
"--------          INSERT MODE MAPS
"----------------------------------------------------

"start Visual-Line mode
"inoremap <C-J> <C-O>V
"inoremap <C-Z> <C-O>u    Can't do this on Unix system easily
noremap! <C-H> <Left>
noremap! <C-J> <Down>
noremap! <C-K> <Up>
noremap! <C-L> <Right>
noremap! <C-N> <Esc>
" depends on 0 being mapped to ^
inoremap <C-A> <C-O>0
noremap! <C-E> <End>

"----------------------------------------------------
"--------          COMMAND MODE MAPS
"----------------------------------------------------

"----------------------------------------------------
"--------          ABBREVIATIONS
"----------------------------------------------------

"----------------------------------------------------
"----------------------------------------------------
"--------          EXPERIMENTAL
"----------------------------------------------------

" Put you in the file where you when you last exited it
au BufReadPost * if line("'\"") | exe "normal '\"" | endif

" Author:   Stefan Roemer <roemer@informatik.tu-muenchen.de>
" Function: Perform an Ex command on a visual highlighted block (CTRL-V).
" Usage:    Mark visual block (CTRL-V), press ':B ' and enter an Ex command
"           [cmd]. On the command-line the visual range is automatically
"           inserted, ie. ":'<,'>B [cmd]" is displayed there (as usual).
"           Command-line completion is supported for Ex commands.
" Note:     There must be a space before the '!' when invoking external
" shell commands, eg. ':B !sort'. Otherwise an error is reported.
"
" Use ctrl-v to visually mark the block then use
"    :B if more lines than the marked block are inserted, cut them off
"    :C to keep all lines even if there are additional lines inserted
" affected: mark register m
  fu! VisBlockCmd(flag,cmd)
    let x1=virtcol("'<")|let y1=line("'<")
    let x2=virtcol("'>")|let y2=line("'>")
    '>pu_|km|let a=''|let b=''|let l=y1
    while l<=y2
      let ln=getline(l)|let p1=strpart(ln,0,x1-1)
	  let p2=strpart(ln,x2,999999999)
      let a=a.p1."\n"|let b=b.p2."\n"|
	  call setline(l,strpart(ln,x1-1,x2-x1+1))
      let l=l+1
    endw
    exe"'<,'>".a:cmd
    let l=y2-line("'m")
	while l>=0
		'm-1pu_
		let l=l-1
		endw
	let l=y1
    while l<=y2
      call setline(l,matchstr(a,"[^\<c-j>]*").getline(l).matchstr(b,"[^\<c-j>]*"))
      let a=substitute(a,".\\{-}\<c-j>",'','')
      let b=substitute(b,".\\{-}\<c-j>",'','')
      let l=l+1
    endw
    if a:flag==1
		exe"'md"
	else
		exe y2+1.",'md"
	endif
  endf
" if more lines than the marked block are inserted, cut them off
  com! -ra -n=+ -complete=command B call VisBlockCmd(0,'<a>')
" keep all lines even if there are additional lines inserted
  com! -ra -n=+ -complete=command C call VisBlockCmd(1,'<a>')
" affected: mark register m

" A slight variation on :g/ ... /p to help delineate the 
" contents of the file itself from the search results
" (Of course, really needs highlighting!!)
command! -nargs=1 G DMGPrint <args>

" Allow certain movement characters to wrap to prev / next line
set whichwrap=b,h,l,<,>,~,[,]

"----------------------------------------------------
"--------          Source Machine-specific Exrc
"----------------------------------------------------
if filereadable(expand("~/.exrc.mach"))
	source ~/.exrc.mach
endif

"----------------------------------------------------
"--------          Archive
"----------------------------------------------------
"*****************            gv => clean up after mouse 
"*****************                  copy+paste (not used)
"map gv 0/[^0-9 	]d0I	k

""""""""""""""""""""""""""""""

