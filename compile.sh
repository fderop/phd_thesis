#!/bin/bash
#
# Requires: XeLaTeX, bibtex, latexindent, Inkscape (for SVG), latexmk
# Tested with: TeX Live 2025 (fully updated via tlmgr)
#
# NOTE: The initial TeX Live 2025 release has two known issues:
#   1. xdvipdfmx <= 20250205 crashes on PDF inclusions (fixed in 20250410)
#   2. bidi package conflicts with the array package (workaround in preamble.tex)
# If compilation fails, run: sudo tlmgr update --self --all

THESIS_FILE="phd_thesis"

find . -name "*.tex" -exec latexindent -w {} \; > /dev/null 2>&1

latexmk -xelatex -bibtex -f -shell-escape "$THESIS_FILE.tex"

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    find . -name "*.bak*" -exec rm -f {} \;
else
    echo "Compilation failed. Check the log for errors."
fi

find . -type f -name "*.bak" -exec rm {} +

