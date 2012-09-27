vim syntax highlighting for jinja atop any other highlighter
============================================================

To "install" this just drop the two .vim files in your `~/.vim/syntax` folder. If that folder does not exist yet, create it.

Then add the following line to your `~/.vimrc`.
```
autocmd! BufNewFile,BufRead *.jinja setlocal ft=jinja-composite
```

You can manually tell vim to highlight a file using the jinja composite highlighter with `:setf jinja-composite`. To set the "secondary" highlighter to e.g. C type `:setf jinja-composite.c`.
