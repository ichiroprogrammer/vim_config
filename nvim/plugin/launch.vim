command! -nargs=0 Launch                    call launch#launch_file(expand('%'))
command! -nargs=1 -complete=dir LaunchBegin call launch#launch_buff_begin('<args>')
command! -nargs=0 LaunchEnd                 call launch#launch_buff_end()
