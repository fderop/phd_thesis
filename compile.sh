#!/bin/bash

max_tries=99
try=1

# to install alphabeta.sty:
# tlmgr install greek-fontenc

# to install zref-abspage.sty:
# tlmgr install zref

# sudo tlmgr install charter psnfss       # charter type1 fonts/map support
# sudo tlmgr install ly1                  # provides texnansi.enc
# sudo mktexlsr

TARGET="phd_thesis.tex"
while [ $try -le $max_tries ]; do
  echo "Build attempt $try/$max_tries"
  set -o pipefail
  [ -f "$TARGET" ] || { echo "Missing target: $TARGET"; exit 1; }

  set -o pipefail
  latexmk -xelatex -biber -f -shell-escape \
    -interaction=nonstopmode -file-line-error "$TARGET" 2>&1 | tee /tmp/latexmk.log
  rc=${PIPESTATUS[0]}
  set +o pipefail

  [ $rc -eq 0 ] && break
  # keep last .log before cleaning
  [ -f phd_thesis.log ] && cp -f phd_thesis.log /tmp/phd_thesis.last.log
  latexmk -C "$TARGET" >/dev/null 2>&1

  # Missing .sty?
  sty=$(sed -n "s/.*File \`\([^']*\)\.sty' not found.*/\1/p" /tmp/latexmk.log | head -n1)
  [ -z "$sty" ] && break

  echo "Missing: ${sty}.sty"

  # First try direct install (often matches)
  if sudo -n true 2>/dev/null; then
    sudo tlmgr install "$sty" >/dev/null 2>&1 || true
  fi
  tlmgr install "$sty" >/dev/null 2>&1 || true

  # If still missing, map file -> package via tlmgr search
  if ! kpsewhich "${sty}.sty" >/dev/null 2>&1; then
    pkg=$(tlmgr search --global --file "/${sty}\.sty" 2>/dev/null | sed -n 's/^\([^:]*\):.*/\1/p' | head -n1)
    if [ -n "$pkg" ]; then
      echo "Installing package: $pkg"
      if sudo -n true 2>/dev/null; then
        sudo tlmgr install "$pkg" >/dev/null 2>&1 || true
      fi
      tlmgr install "$pkg" >/dev/null 2>&1 || true
    fi
  fi

  try=$((try+1))
done

if [ $rc -eq 0 ]; then
    echo "Compilation successful!"
    find . -name "*.bak*" -exec rm -f {} \;
else
    echo "Compilation failed. Check /tmp/latexmk.log for errors."
fi
