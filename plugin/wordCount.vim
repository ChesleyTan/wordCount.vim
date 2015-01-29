command! WordCount call wordCount#UpdateWordCount() | echo wordCount#WordCount()
augroup WordCount
    autocmd CursorMoved * call wordCount#PushMode()
augroup END
