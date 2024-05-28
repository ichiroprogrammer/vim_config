" Ward off unexpected things that your distro might have made, as
" well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Set Dein base path (required)
let s:dein_base = '~/.cache/dein'

" Set Dein source path (required)
let s:dein_src = '~/.cache/dein/repos/github.com/Shougo/dein.vim'

" Set Dein runtime path (required)
execute 'set runtimepath+=' . s:dein_src

" Call Dein initialization (required)
call dein#begin(s:dein_base)

call dein#add(s:dein_src)

" Your plugins go here:
call dein#add('Shougo/deoplete.nvim')
call dein#add('zchee/deoplete-clang')
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('Shougo/neoinclude.vim')

call dein#add('tpope/vim-fugitive')
call dein#add('reireias/vim-cheatsheet')
call dein#add('mattn/vim-maketable')
call dein#add('aklt/plantuml-syntax')

" Finish Dein initialization (required)
call dein#end()

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
if has('filetype')
  filetype indent plugin on
endif

" Enable syntax highlighting
if has('syntax')
  syntax on
endif

" Uncomment if you want to install not-installed plugins on startup.
"if dein#check_install()
" call dein#install()
"endif

let g:cheatsheet#cheat_file = expand('<sfile>:p:h') . '/cheatsheet.md'
let g:table_mode_corner = '|'

if g:os == 'windows'
    let g:python_host_prog  = 'C:\cygwin64\bin\python2.7.exe'
    let g:python3_host_prog  = 'C:\cygwin64\bin\python3.8.exe'
elseif g:os == 'cygwin'

elseif g:os == 'linux'
    let g:ruby_host_prog = '/usr/local/bin/neovim-ruby-host'
    let g:python_host_prog  = '/usr/bin/python2'
    let g:python3_host_prog  = '/usr/bin/python3'
else
    echo 'unkown os'
endif

" deoplete
if has('python3')
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-14/lib/libclang.so.1'
    let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-14/lib/clang/'
    let g:deoplete#sources#clang#std = {'c': 'c11', 'cpp': 'c++14'}
    let g:deoplete#sources#clang#clang_complete_database = './'
    "g:deoplete#sources#clang#include_default_arguments	False	No
    "g:deoplete#sources#clang#filter_availability_kinds
endif


