wordCount.vim
=============

A quick word count plugin for Vim, perfect for adding to your statusline

# Manual Installation
##### Clone this repository to `$HOME/.vim/bundle`  
`$ mkdir -p $HOME/.vim/bundle`  
`$ git clone https://github.com/ChesleyTan/wordCount.vim $HOME/.vim/bundle/wordCount.vim`  

##### Add the following to your `.vimrc`  
`set runtimepath+=$HOME/.vim/bundle/wordCount.vim`

# Usage
This plugin provides the function `wordCount#WordCount()` which returns a count of the number of words in the buffer (or in the directly preceding visual selection), as well as the command `WordCount` which prints out the word count.  

##### Visual Mode
For a word count of a visual selection, you must make your selection, escape visual mode, and call the word count function or command before moving your cursor in normal mode. Because Vim does not have an autocmd event for Visual enter/exit, this plugin can only be informed of the current mode when the cursor moves.  Therefore, a word count of a visual selection can only be done if the cursor is moved while in visual mode. 

# Conservative updating (enabled by default)
The conservative updating option `g:wc_conservative_update` forces the plugin to only update the word count when one of the following events occurs:
* Vim leaves insert mode
* A change is made in normal mode
* A new buffer is opened

This is useful if you plan to add the word count to your `statusline`.

# Adding a word count to your statusline
This can be done simply with `set statusline+=%{wordCount#WordCount()}`
