#!/bin/bash


THESIS_FILE="phd_thesis"

latexmk -xelatex -bibtex -f "$THESIS_FILE.tex"

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
else
    echo "Compilation failed. Check the log for errors."
fi
