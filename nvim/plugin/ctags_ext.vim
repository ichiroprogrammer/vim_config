function! CTags(...)
    if a:0 == 0
        let l:dir="."
    else
        let l:dir=a:1
    end
    silent execute '!ctags -R --extras=fFgpqrs --kinds-C=+px --kinds-C++=+px' . l:dir
endfunction

command!  -nargs=? -complete=dir Ctags call CTags(<f-args>)

