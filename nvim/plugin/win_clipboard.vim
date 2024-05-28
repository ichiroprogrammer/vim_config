command! -nargs=0 WPaste0     call win_clipboard#paste_r0()
command! -range WPaste        call win_clipboard#paste(<line1>, <line2>)
