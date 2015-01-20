let s:buf_cache=[]
let s:wc=0
if !exists('g:wc_conservative_update')
    let g:wc_conservative_update=1
endif

if g:wc_conservative_update != 1 && !exists('g:wc_optimization_warning') && &lazyredraw == 0
    echo "[WARNING]: If you experience slowdown after adding the word count to your statusline, please enable lazyredraw with 'set lazyredraw' or consider enabling the g:wc_conservative_update option. To disable this warning, add 'let g:wc_optimization_warning=0' to your .vimrc"
endif

function! s:isWord(s)
    return a:s =~ ".*[A-Za-z].*"
endfunction

function! wordCount#WordCount()
    if g:wc_conservative_update != 1
        call wordCount#UpdateWordCount()
    endif
    return s:wc
endfunction

function! wordCount#UpdateWordCount()
    let bufc=getline(1, '$')
    if bufc != s:buf_cache
        let s:buf_cache = bufc
        let s:wc=0
        for line in bufc
            for word in split(line)
                if s:isWord(word)
                    let s:wc=s:wc+1
                endif
            endfor
        endfor
    endif
endfunction

if g:wc_conservative_update == 1
    " Only update the word count upon entering a buffer, leaving insert mode or
    " changing text in normal mode
    augroup WordCount
        autocmd InsertLeave * call wordCount#UpdateWordCount()
        autocmd TextChanged * call wordCount#UpdateWordCount()
        autocmd BufEnter * call wordCount#UpdateWordCount()
    augroup END
endif

