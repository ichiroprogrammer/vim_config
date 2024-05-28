command! -nargs=0 Cdv    call cd#vim_change_dir()
command! -nargs=0 Cds    call cd#shell_change_dir()

nmap <C-c>       :Cdv<CR>
nmap <S-c>       :Cds<CR>

