if g:os == 'windows'
    set shell=C:/cygwin64/bin/bash.exe
else
    if filereadable("/bin/zsh")
        set shell=/bin/zsh
    else
        set shell=/bin/bash
    endif
endif

set shellpipe=\|&\ tee
set shellcmdflag=-c
set shellslash

tnoremap <silent> <C-q> <C-\><C-n>
command! -nargs=0 Term     call term#start()

