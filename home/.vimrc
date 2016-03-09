set gfn=Monospace\ 9
" set guifont=Consolas:h9
set ic
set smartcase
set nosol " avoids setting the cursor at start of line on various movements
set ts=2
set sw=2 " shiftwidth best if eqal to ts
set smartindent
set printoptions+=number:y
set printoptions+=wrap:y
set printoptions+=left:5pc
" set printfont=h8
" set guifont=Monospace\ 9
set printfont=Monospace:h9
" set lbr
set guioptions+=c " console choices, no popups
set guioptions+=b " bottom scrollbar is always present
set guioptions-=m " no menubar
set guioptions-=T " no Toolbar
set iskeyword+=46
runtime ftplugin/man.vim
set spelllang=de_de,en_us
set dy=lastline
set textwidth=0
vmap * y/<C-R>"<CR>
set makeprg=make\ &>/dev/null\ &"
command Wm w|make
function CursorMoveRelative()
	nmap j jz.
	nmap k kz.
	nmap <Down> <Down>z.
	nmap <Up> <Up>z.
	set cul
endfunction
command Moverel call CursorMoveRelative()
function CursorMoveAbsolute()
	nunmap j
	nunmap k
	nunmap <Down>
	nunmap <Up>
	set nocul
endfunction
command Moveabs call CursorMoveAbsolute()
set hidden
imap ae ä
imap oe ö
imap ue ü
imap Ae Ä
imap Oe Ö
imap Ue Ü
let g:vimrplugin_underscore = 1
" do not write swap and backup files to current directory
" set directory=c:\tmp\cache\vim\swapfiles\
" set backupdir=c:\tmp\cache\vim\backupdir\

" set ts=20 nowrap
