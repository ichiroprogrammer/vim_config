let s:git_diff_session = 'GIT DIFF'
let s:git_diff_buff_id_cur = -1
let s:git_diff_buff_id_old = -1

function! s:echo_err(msg) abort
  echohl ErrorMsg
  echomsg 'git_diff.vim:' a:msg
  echohl None
endfunction

" pattern : 0       just changed
"         : 1       change filename
function! s:modified_pattern(pattern) abort
    if  a:pattern == 0
        return '^[ADMU? ][DMU? ] \+'
    elseif  a:pattern == 1
        return 'R[M ] \+.* -> '
    endif
    call s:echo_err('modified_pattern wrong')
endfunction

function! s:get_target_name()
    let l:line=getline(".")

    if match(l:line, s:modified_pattern(0)) isnot# -1
        let ret = substitute(l:line, s:modified_pattern(0), "", "")
    elseif match(l:line, s:modified_pattern(1)) isnot# -1
        let ret = substitute(l:line, s:modified_pattern(1), "", "")
    else
        call s:echo_err(l:line . ' :this file is not modefied')
        let ret = ''
    endif

    return ret
endfunction

function! s:each(line1, line2, func_ref) abort
    let l:col = col('.')

    for i in range(a:line1, a:line2)
        call cursor(i, l:col)
        call a:func_ref()
    endfor
endfunction

function! s:launch_file() abort
    let l:target=s:get_target_name()

    if g:os == 'linux'
        silent execute '!wslstart ' .  l:target
    else 
        if g:os == 'cygwin'
            silent execute '!wslstart ' .  l:target
        else
            echo 'not support launch'
        endif
    endif
endfunction

function! git_diff#launch_file(line1, line2) abort
    call s:each(a:line1, a:line2, function('s:launch_file'))
endfunction


function! s:git_add() abort
    let l:target=s:get_target_name()

    silent execute '!git add ' .  l:target
    call git_diff#make_list_load()
endfunction

function! git_diff#git_add(line1, line2) abort
    call s:each(a:line1, a:line2, function('s:git_add'))
endfunction

function! s:git_reset() abort
    let l:target=s:get_target_name()

    if len(l:target) == 0
        return
    endif

    silent execute '!git reset ' .  l:target
    call git_diff#make_list_load()
endfunction

function! git_diff#git_reset(line1, line2) abort
    call s:each(a:line1, a:line2, function('s:git_reset'))
endfunction

function! git_diff#make_list_load() abort
    setlocal modifiable

    let l:line = line('.')
    let l:col = col('.')
    silent execute ':%delete'
    silent execute 'r! git status -s'
    silent execute ':1delete'
    call cursor(l:line, l:col)

    setlocal nomodifiable
endfunction

function! s:key_map_end() abort
    delcommand GitAdd
    delcommand GitReset
endfunction

function! s:key_map_begin() abort
    command! -range GitAdd :call git_diff#git_add(<line1>, <line2>)
    map <silent> <buffer> a :GitAdd<CR>

    command! -range GitLaunchFile :call git_diff#launch_file(<line1>, <line2>)
    map <silent> <buffer> L :GitLaunchFile<CR>

    command! -range GitReset :call git_diff#git_reset(<line1>, <line2>)
    map <silent> <buffer> r :GitReset<CR>

    nnoremap <silent> <buffer> <Plug>(diff-open) :<C-u>call git_diff#show_diff(0, 0)<CR>
    nmap <buffer> d <Plug>(diff-open)

    nnoremap <silent> <buffer> <Plug>(diff-open-V) :<C-u>call git_diff#show_diff(1, 0)<CR>
    nmap <buffer> vd <Plug>(diff-open-V)

    nnoremap <silent> <buffer> <Plug>(diff-open-h) :<C-u>call git_diff#show_diff(0, 1)<CR>
    nmap <buffer> h <Plug>(diff-open-h)

    nnoremap <silent> <buffer> <Plug>(diff-open-Vh) :<C-u>call git_diff#show_diff(1, 1)<CR>
    nmap <buffer> vh <Plug>(diff-open-Vh)

    nnoremap <silent> <buffer> <Plug>(diff-list-close) :<C-u>call git_diff#end()<CR>
    nmap <buffer> <C-Q> <Plug>(diff-list-close)

    nnoremap <silent> <buffer> <Plug>(diff-reload) :<C-u>call git_diff#make_list_load()<CR>
    nmap <buffer> s <Plug>(diff-reload)

    nnoremap <silent> <buffer> <Plug>(git-commit) :!git commit -m 
    nmap <buffer> c <Plug>(git-commit)
endfunction

"vertial    : 0 normal split to show diff buffers
"           : 1 virtial split to show diff buffers
"from_head  : 0 git diff STAGE
"           : 1 git diff HEAD
function! git_diff#show_diff(vertical, from_head) abort
    call git_diff#show_diff_off()
    let l:target=s:get_target_name()

    if a:from_head == 0
        let sh1 = ':0'
    else
        let sh1 = 'HEAD'
    endif

    split
    execute 'edit ' . l:target

    call s:diff_curr_file(l:sh1, a:vertical)
endfunction

function! git_diff#show_diff_off()
    execute ':diffoff!'

    let l:curr_id = win_getid()

    if s:git_diff_buff_id_cur != -1
        if l:curr_id != s:git_diff_buff_id_cur
            if win_gotoid(s:git_diff_buff_id_cur)
                bwipeout!
            endif
        endif

        let s:git_diff_buff_id_cur = -1
    endif

    if s:git_diff_buff_id_old != -1
        if l:curr_id != s:git_diff_buff_id_old
            if win_gotoid(s:git_diff_buff_id_old)
                bwipeout!
            endif
        endif

        let s:git_diff_buff_id_old = -1
    endif

    call win_gotoid(l:curr_id)
endfunction

function! git_diff#begin(resize) abort
    let winid = bufwinid(s:git_diff_session)
    if winid isnot# -1
        call win_gotoid(winid)
    else
        execute 'edit' s:git_diff_session
        set buftype=nofile
        set noswapfile
        setlocal nomodifiable

        call s:key_map_begin()
        call git_diff#make_list_load()
    endif

    if a:resize != 0
        execute ":only"
        let l:lines=&lines
        echo l:lines
        if l:lines < 50
            execute ":set lines=50"
            sleep 100m
        endif
        execute ":set columns=241"
    endif

endfunction

function! git_diff#end()
    call git_diff#show_diff_off()
    call s:key_map_end()
    bwipeout!
endfunction

function! git_diff#sh1_complete(ArgLead, CmdLine, CursorPos)
    let l:sh1s = systemlist('git log --pretty=format:%H')
    return filter(l:sh1s, {_, v -> v =~ '^' . a:ArgLead})
endfunction

function s:get_sh1(args)
  let res = []
  call extend(res, a:args)

  if len(res) == 0
      let sh1 = ':0'
  else
      let sh1 = res[0]
  endif

  return sh1
endfunction

" カレントバッファが変わる
function! s:load_file_with_sh1(sh1, current_file, filetype, vertical)
    let l:git_top = systemlist('git rev-parse --show-toplevel')[0] . '/'
    let l:abs_path = fnamemodify(a:current_file, ':p')
    let l:current_file = substitute(l:abs_path, l:git_top, '', '')

    let l:title = a:current_file . '.' . strpart(a:sh1, 0, 4)

    if a:vertical == 0
        execute ':new ' .  l:title
    else
        execute ':vert new ' .  l:title
    endif

    set buftype=nofile
    set noswapfile
    execute 'set filetype=' . a:filetype

    let l:line = line('.')
    let l:col = col('.')
    silent execute ':%delete'
    silent execute 'r! git show ' . a:sh1 . ':' . l:current_file
    silent execute ':1delete'
    call cursor(l:line, l:col)

    setlocal nomodifiable
endfunction

function! s:diff_curr_file(sh1, vertical)
    let s:git_diff_buff_id_cur = win_getid()
    let l:filetype = &filetype

    call s:load_file_with_sh1(a:sh1, expand('%'), l:filetype, a:vertical)
    let s:git_diff_buff_id_old = win_getid()

    diffthis
    call win_gotoid(s:git_diff_buff_id_cur)
    diffthis
endfunction

function git_diff#diff_curr_buff(...)

    " GitDiffを直接呼び出した場合の対策
    let s:git_diff_buff_id_cur = win_getid()

    call git_diff#show_diff_off()

    let sh1 = s:get_sh1(a:000)
    call s:diff_curr_file(sh1, 0)
endfunction

