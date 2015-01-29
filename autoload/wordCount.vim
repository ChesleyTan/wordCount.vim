let s:buf_cache=[]
let s:wc=0
let s:last_mode=""
if !exists('g:wc_conservative_update')
    let g:wc_conservative_update=1
endif

if g:wc_conservative_update != 1 && !exists('g:wc_optimization_warning') && &lazyredraw == 0
    echo "[WARNING]: If you experience slowdown after adding the word count to your statusline, please enable lazyredraw with 'set lazyredraw' or consider enabling the g:wc_conservative_update option. To disable this warning, add 'let g:wc_optimization_warning=0' to your .vimrc"
endif

function! s:isWord(s)
    return a:s =~ ".*[A-Za-z].*"
endfunction

function! wordCount#GetVisualSelection()
    let [row1, col1] = getpos("'<")[1:2]
    let [row2, col2] = getpos("'>")[1:2]
    let lines = getline(row1, row2)
    let numLines = len(lines)
    if s:last_mode ==# "v"
        for i in range(numLines)
            let lines[i] = lines[i]
        endfor
        if numLines > 0
            let lines[0] = lines[0][col1 - 1 :]
        endif
        if numLines > 1
            let lines[-1] = lines[-1][: col2 - 1]
        endif
    else
        for i in range(numLines)
            let lines[i] = lines[i][col1 - 1 : col2 - 1]
        endfor
    endif
    return lines
endfunction

function s:lastModeWasVisual()
    return s:last_mode ==# "v" || s:last_mode ==# "V" || s:last_mode ==# ""
endfunction

function! wordCount#WordCount()
    if g:wc_conservative_update != 1 || s:lastModeWasVisual()
        call wordCount#UpdateWordCount()
    endif
    return s:wc
endfunction

function! wordCount#UpdateWordCount()
    if s:lastModeWasVisual()
        let bufc = wordCount#GetVisualSelection()
    else
        let bufc = getline(1, '$')
    endif
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

function! wordCount#PushMode()
    let s:last_mode = mode()
endfunction

if g:wc_conservative_update == 1
    " Only update the word count upon entering a buffer, leaving insert mode or
    " changing text in normal mode
    augroup WordCountConservative
        autocmd InsertLeave * call wordCount#UpdateWordCount()
        autocmd TextChanged * call wordCount#UpdateWordCount()
        autocmd BufEnter * call wordCount#UpdateWordCount()
    augroup END
endif

