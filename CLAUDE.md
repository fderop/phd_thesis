# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PhD thesis on single-cell ATAC-seq (genomics/bioinformatics), compiled with XeLaTeX via latexmk.

## Build

```bash
./compile.sh
```

This runs `latexindent` on all `.tex` files, then `latexmk -xelatex -bibtex -f -shell-escape phd_thesis.tex`. Requires XeLaTeX, bibtex, latexindent, and Inkscape (for SVG conversion via `svg` package).

## Required External Files (gitignored)

- `papers/elife-73971-v5.pdf` — eLife HyDrop paper
- `papers/s41587-023-01881-x.pdf` — Nature Biotechnology benchmark paper

These are included via `\includepdf` in `phd_thesis.tex`.

## Structure

- `phd_thesis.tex` — Main document (book class, a4paper, twoside). Assembles frontmatter, chapters, included papers, appendices, and bibliography.
- `tex/preamble.tex` — All package imports, layout config, citation setup (biblatex with bibtex backend, custom numeric-comp style at `tex/custom-numeric-comp`), font choices (Charter text, TeX Gyre Heros headings, XeLaTeX with fontspec).
- `tex/macros.tex` — Custom commands (`\svgfigure` for SVG figure inclusion).
- `tex/references.bib` — Bibliography database.
- `content/` — Chapter and frontmatter `.tex` files:
  - `front_1_abstracts.tex` through `front_5_vietnamese.tex` — Abstracts, contributions, AI statement, acknowledgements, Vietnamese text.
  - `chapter_1_introduction.tex` — Introduction
  - `chapter_2_design.tex`, `chapter_3_benchmark.tex` — Appendix supplements
  - `chapter_4_conclusion_future.tex` — Conclusion
- `im/` — Images (PDF/PDF_tex from Inkscape, SVG, JPG, PNG). Graphics path is `./im/`.
- `im_aux/` — Auxiliary image files (gitignored).
- `svg-inkscape/` — Auto-generated SVG conversions (gitignored).

## Key Conventions

- Footnotes use three-column layout (`bidi` package with `\threecolumnfootnotes`).
- Figures use `\svgfigure{path}{short caption}{long caption}{label}` macro for SVG-based figures.
- Custom SI units defined: `\bp`, `\molar`, `\flops`, `\RPKM`.
- Citation command `\sjcitep` places footnote citations above punctuation.
- The document uses `\raggedbottom` to avoid stretched vertical spacing.
