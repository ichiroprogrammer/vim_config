command! -nargs=0 GitDiffSession       call git_diff#begin(0)
command! -nargs=0 GitDiffSessionResize call git_diff#begin(1)
command! -nargs=0 GitDiffSessionOff    call git_diff#show_diff_off()

command! -complete=customlist,git_diff#sh1_complete -nargs=? 
                \ GitDiff call git_diff#diff_curr_buff(<f-args>)

