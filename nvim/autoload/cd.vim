function! s:is_term()
    let bn = bufname("%")
    if bn =~ 'term://'
        return 1
    else
        return 0
    endif
endfunction

function! cd#find_dir_candidate()
    " bashのプロンプトが以下のようになっている前提
    " PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]$(echo $PWD/|sed "s@$HOME@~/@g"| sed "s@/\$@@g")\[\e[0m\]\n\$ ' 
    " username@hostname ~/pwd/
    
    let username=$USER
    let hostname=$NAME
    let prompt= username . '@' . hostname . ' '

    for i in range(50)
        silent execute 'normal "uyy'
        let reg=@u
        if reg =~ prompt
            return substitute(reg, prompt, '', '') 
        endif
        silent execute 'normal k'
    endfor

    return ''
endfunction


function! cd#vim_change_dir() " vimのカレントディレクトリをbashのカレントに合わせる
    if s:is_term() == 1
        let dir_candidate=cd#find_dir_candidate()

        if dir_candidate == ''
            echo "no dir candidate"
        else
            silent execute ':cd ' . dir_candidate
        endif
    else
        silent execute ':cd %:h'
    endif
endfunction

function! cd#shell_change_dir() " shellのカレントディレクトリをvimのカレントに合わせる
  let vim_cwd = getcwd()
  call jobsend(b:terminal_job_id, "cd " . vim_cwd . "\n")
endfunction
