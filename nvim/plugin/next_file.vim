nmap <S-q>    :let @q=expand('%')<CR>
nmap <S-W>    :call next_file#edit_q()<CR>

command!  -count NF call next_file#change(<count>)
nmap <C-q>      :NF<CR>
