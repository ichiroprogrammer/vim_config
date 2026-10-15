function! s:copy2clipboard(lines) abort
    let temp_file = tempname()

    call writefile(a:lines, temp_file)

    let clip = ''
    if g:os == 'linux'
        let clip = '/mnt/c/Windows/System32/clip.exe'
    elseif g:os == 'cygwin'
        let clip = '/cygdrive/c/Windows/System32/clip.exe'
    elseif g:os == 'windows'
        echohl WarningMsg
        echomsg '[Warning] Windows環境ではclip.exeへの直接パス指定はサポートしていません。'
        echohl None
        call delete(temp_file)
        return
    endif

    " nkfの存在チェック
    if !executable('nkf')
        echohl WarningMsg
        echomsg '[Warning] nkf コマンドが見つかりません。クリップボードへのコピーに失敗しました。'
        echohl None
        call delete(temp_file)
        return
    endif

    " クリップボードへコピー
    let copy_cmd = 'cat ' . shellescape(temp_file) . ' | nkf -s | ' . clip
    call system(copy_cmd)

    " 一時ファイルの削除（Vim標準関数を使用）
    call delete(temp_file)
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

