function! s:copy2clipboard(lines) abort
    let temp_file = tempname()

    call writefile(a:lines, temp_file)
    let copy_cmd='cat ' . temp_file . ' | nkf -s | /mnt/c/Windows/System32/clip.exe' 
    call system(copy_cmd)

    let rm_cmd = 'silent !rm -f ' . shellescape(temp_file)
    call system(rm_cmd)

endfunction

function! win_clipboard#paste_r0() abort
    let register_contents = getreg('0')
    let lines = split(register_contents, "\n")
    call s:copy2clipboard(lines)
endfunction

function! win_clipboard#paste(line1, line2) abort
    if a:line1 < a:line2
        let start = a:line1
        let end = a:line2
    else
        let start = a:line2
        let end = a:line1
    endif

    let lines = getline(start, end)
    call s:copy2clipboard(lines)
endfunction

