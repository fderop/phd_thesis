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
PRINT_DIR="print"
LATEXMK=(latexmk -xelatex -bibtex -f -shell-escape)
PDFLATEXMK=(latexmk -pdf)

MISSING_PAPERS=()
if [[ ! -f papers/elife-73971-v5-thesis-corrected.pdf && ! -f papers/elife-73971-v5.pdf ]]; then
    MISSING_PAPERS+=("papers/elife-73971-v5.pdf (eLife HyDrop paper)")
fi
if [[ ! -f papers/s41587-023-01881-x.pdf ]]; then
    MISSING_PAPERS+=("papers/s41587-023-01881-x.pdf (Nature Biotechnology benchmark paper)")
fi

if (( ${#MISSING_PAPERS[@]} )); then
    echo "Warning: The following paper PDFs are missing:"
    printf '  %s\n' "${MISSING_PAPERS[@]}"
    echo "The complete thesis requires these papers. You can compile without them; the missing PDFs will be omitted."
    read -r -p "Continue without the missing papers? [y/N] " REPLY
    case "$REPLY" in
        y|Y|yes|YES) ;;
        *) echo "Compilation cancelled."; exit 1 ;;
    esac
fi

find . -name "*.tex" -exec latexindent -w {} \; > /dev/null 2>&1

if ! "${LATEXMK[@]}" "$THESIS_FILE.tex"; then
    echo "Compilation failed. Check the log for errors."
    exit 1
fi

mkdir -p "$PRINT_DIR"

if ! "${LATEXMK[@]}" -outdir="$PRINT_DIR" -jobname=cover -usepretex="\def\printcoveronly{1}" "$THESIS_FILE.tex"; then
    echo "Cover PDF compilation failed. Check print/cover.log for errors."
    exit 1
fi

if ! "${LATEXMK[@]}" -outdir="$PRINT_DIR" -jobname=content -usepretex="\def\printcontentonly{1}" "$THESIS_FILE.tex"; then
    echo "Content PDF compilation failed. Check print/content.log for errors."
    exit 1
fi

CONTENT_PAGES=$(pdfinfo "$PRINT_DIR/content.pdf" | awk '/^Pages:/ {print $2}')
SPINE_WIDTH_MM=$(awk -v pages="$CONTENT_PAGES" 'BEGIN {printf "%.4f", pages * 5.12 / 100}')

if ! "${PDFLATEXMK[@]}" -outdir="$PRINT_DIR" -jobname=cover-spread -usepretex="\def\ContentPageCount{$CONTENT_PAGES}\def\SpineWidthMm{$SPINE_WIDTH_MM}" cover_spread.tex; then
    echo "Wraparound cover PDF compilation failed. Check print/cover-spread.log for errors."
    exit 1
fi

find "$PRINT_DIR" -maxdepth 1 -type f \
    \( -name "cover.*" -o -name "content.*" -o -name "cover-spread.*" -o -name "cover-blx.bib" -o -name "content-blx.bib" \) \
    ! -name "*.pdf" -delete

echo "Compilation successful!"
echo "Print PDFs saved to $PRINT_DIR/cover.pdf, $PRINT_DIR/content.pdf, and $PRINT_DIR/cover-spread.pdf"
echo "Wraparound cover spine width: ${SPINE_WIDTH_MM}mm for ${CONTENT_PAGES} content pages"

find . -name "*.bak*" -exec rm -f {} \;

find . -type f -name "*.bak" -exec rm {} +
