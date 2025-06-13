#!/bin/bash


THESIS_FILE="phd_thesis"

find . -name "*.tex" -exec latexindent -w {} \; > /dev/null 2>&1

latexmk -xelatex -bibtex -f -shell-escape "$THESIS_FILE.tex"

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
else
    echo "Compilation failed. Check the log for errors."
fi
