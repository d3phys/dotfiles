"
" KISS Vim Configuration
"

"
" Tabs and spaces.
"
    let s:tabwidth=4

    let &tabstop=s:tabwidth
    let &softtabstop=s:tabwidth
    let &shiftwidth=s:tabwidth
    set expandtab
    set smartindent

    " set tags+=~/ctags/stdtags

"
" Search.
"
    set showmatch
    set hlsearch
    set incsearch
    set ignorecase
    set smartcase

"
" Wrap text to make your paragraphs look awesome.
"
    let s:textwidth=121

    let &colorcolumn=s:textwidth
    let &synmaxcol=s:textwidth

    set wrap
    set number

    "set lazyredraw
    set redrawtime=100
    set regexpengine=1
    set history=1024

"
" Escape with 'jk'.
"
    inoremap jk <ESC>

"
" Press <F5> to remove trailing whitespaces
"
    nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

"
" Platform-specific variables.
"
    let s:IS_WIN  = has('win32') || has('win64')
    let s:IS_NVIM = has('nvim-0.2') || (has('nvim') && exists('*jobwait') && !s:IS_WIN)

"
" Plugins list.
" See https://github.com/junegunn/vim-plug
"
" All of the settings below is for plugin.
"
"
    silent! call plug#begin()

    " Check if Vim Plug exists
    if !exists('g:loaded_plug')
        finish
    endif

    Plug 'endel/vim-github-colorscheme'
    Plug 'morhetz/gruvbox'
    Plug 'jamescherti/vim-tomorrow-night-deepblue'
    Plug 'Alligator/accent.vim'
    Plug 'ntk148v/komau.vim'
    Plug 'jdhao/better-escape.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    if s:IS_NVIM

    Plug 'neovim/nvim-lspconfig'

    endif " s:IS_NVIM

    call plug#end()

"
" Better escape with 'jk'.
"
" Plug 'jdhao/better-escape.vim'
"
    let g:better_escape_interval = 100
    let g:better_escape_shortcut = ['jk',]

"
" Fuzzy finder.
"
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
"
    nnoremap <silent> <Leader>b :Buffers<CR>
    nnoremap <silent> <C-f> :Files<CR>
    nnoremap <silent> <Leader>f :Rg<CR>
    nnoremap <silent> <Leader>/ :BLines<CR>
    nnoremap <silent> <Leader>' :Marks<CR>
    nnoremap <silent> <Leader>g :Commits<CR>
    nnoremap <silent> <Leader>H :Helptags<CR>
    nnoremap <silent> <Leader>hh :History<CR>
    nnoremap <silent> <Leader>h: :History:<CR>
    nnoremap <silent> <Leader>h/ :History/<CR>

    let g:fzf_layout = { 'down': '~40%' }

"
" Language Server Protocol.
"
" Plug 'neovim/nvim-lspconfig'
"
if s:IS_NVIM

    colorscheme tomorrow-night-deepblue

lua << EOF
    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)

        -- Disable f***** treesitter
        client.server_capabilities.semanticTokensProvider = nil
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        -- Disable shitty tags generation
        vim.api.nvim_buf_set_option(bufnr, 'tagfunc', '')

        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false,
                signs = false,
                update_in_insert = false,
            }
        )

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
    end

    local lsp_flags = {
        -- This is the default in Nvim 0.7+
        debounce_text_changes = 150,
    }

    require('lspconfig')['clangd'].setup{
        on_attach = on_attach,
        flags = lsp_flags,
    }

    -- Disable *** treesitter
    vim.treesitter.stop()
EOF

endif " s:IS_NVIM

" Disable stupid tags behaviour
set tagfunc=""

