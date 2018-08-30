filetype on
filetype plugin indent on
filetype plugin on
syntax on

execute pathogen#infect()

set directory=$HOME/.vim/swapfiles//
"set cursorline
set number
set fileformat=unix
set nocompatible                " choose no compatibility with legacy vi
set encoding=utf-8
set showcmd                     " display incomplete commands
set listchars=eol:$

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=4                   " a tab is two four spaces
set shiftwidth=4                " indents width
set softtabstop=4               " number columns for TAB
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode
set smarttab
set autoindent

"" Searching
set nohlsearch                  " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif
