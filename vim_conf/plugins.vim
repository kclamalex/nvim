scriptencoding utf-8

" --------------- Diffview configurations ---------------  
nnoremap <silent> <leader>vo :<C-U>DiffviewOpen<CR>
nnoremap <silent> <leader>vc :<C-U>DiffviewClose<CR>
" --------------- Telescope configurations ---------------  
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>
nnoremap <leader>fr <cmd>Telescope oldfiles<cr>
nnoremap <leader>fp <cmd>Telescope projects<cr>
" --------------- Neoformat configurations ---------------  
"Python formatter
let g:neoformat_python_black = {
            \ 'exe': 'black',
            \ 'args': ['--line-length 79', '-q', '-'],
            \ 'stdin': 1,
            \ }
let g:neoformat_enabled_python = ['black']


" --------------- Nvim-tree configurations ---------------  
let g:nvim_tree_respect_buf_cwd = 1
nnoremap <silent> <space>m :MinimapToggle<CR>


" --------------- Minimap.vim configurations ---------------  
let g:minimap_git_colors = 1

" In order to make sure all the global variables
" are applied to the plugin, we should load lua
" module after setting all the global variables here

" Plugins and its lua configurations 
lua require('plugins')

