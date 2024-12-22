#!/bin/bash

# Script to convert PDFs to text files, skipping existing conversions
# Usage: ./pdf_to_text.sh

for file in pdfs/*.pdf; do
    txt_file="${file%.pdf}.txt"

    if [ ! -f "$txt_file" ]; then
        pdftotext "$file" "$txt_file"
        echo "Converted $file to text"
    else
        echo "Skipping $file - text file already exists"
    fi
done
