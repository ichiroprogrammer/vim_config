let s:launch_buff = 'Launch Buff'

function! launch#launch_file(target) abort
    if g:os == 'linux'
        silent execute '!wslstart ' .  a:target
    else 
        if g:os == 'cygwin'
            silent execute '!wslstart ' .  a:target
        else
            echo 'not support launch'
        endif
    endif
endfunction

function! launch#launch_file_range(line1, line2) abort
    for i in range(a:line1, a:line2)
        let l:target=expand('<cWORD>')
        call launch#launch_file(l:target)
    endfor
endfunction

function! s:key_map_begin() abort
    command! -range LaunchFile :call launch#launch_file_range(<line1>, <line2>)
    map <silent> <buffer> L :LaunchFile<CR>
endfunction

function! launch#launch_buff_begin(dir)
    execute 'edit' s:launch_buff

    set buftype=nofile
    set noswapfile

    call s:key_map_begin()

    silent execute ':%delete'
    execute('r!ls ' . a:dir . '*')

    " lsの最初の行は空行
    silent execute ':1delete'
endfunction

function! launch#launch_buff_end()
    let winid = bufwinid(s:launch_buff)
    if winid isnot# -1
        call win_gotoid(winid)
        execute 'bwipeout! ' . s:launch_buff
    endif
endfunction
