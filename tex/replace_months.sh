#!/bin/zsh

# Check if a .bib file is provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <filename.bib>"
    exit 1
fi

BIBFILE="$1"
# BACKUPFILE="${BIBFILE}.backup"

# # Create a backup of the original .bib file
# cp "$BIBFILE" "$BACKUPFILE"

# echo "Backup created: $BACKUPFILE"

# # Debug: Print first few lines of the file to confirm reading
# echo "First 10 lines of the input file:"
# head -n 10 "$BIBFILE"

# # Process month abbreviations using sed
# echo "Replacing month abbreviations..."
# sed -E -i '' '
# /^[[:space:]]*month[[:space:]]*=/ {
#     s/(month[[:space:]]*=[[:space:]]*)jan,/\1{January},/;
#     s/(month[[:space:]]*=[[:space:]]*)feb,/\1{February},/;
#     s/(month[[:space:]]*=[[:space:]]*)mar,/\1{March},/;
#     s/(month[[:space:]]*=[[:space:]]*)apr,/\1{April},/;
#     s/(month[[:space:]]*=[[:space:]]*)may,/\1{May},/;
#     s/(month[[:space:]]*=[[:space:]]*)jun,/\1{June},/;
#     s/(month[[:space:]]*=[[:space:]]*)jul,/\1{July},/;
#     s/(month[[:space:]]*=[[:space:]]*)aug,/\1{August},/;
#     s/(month[[:space:]]*=[[:space:]]*)sep,/\1{September},/;
#     s/(month[[:space:]]*=[[:space:]]*)oct,/\1{October},/;
#     s/(month[[:space:]]*=[[:space:]]*)nov,/\1{November},/;
#     s/(month[[:space:]]*=[[:space:]]*)dec,/\1{December},/;
# }' "$BIBFILE"

# echo "Month abbreviations replaced."

# # Debug: Check if sed made any changes
# echo "Checking for month changes..."
# grep -i "month =" "$BIBFILE" | head -n 5

# # Use awk to add shortjournal field based on the journal title
# echo "Processing journal titles and inserting shortjournal field..."

# awk '
# BEGIN {
#     found_journal = 0
#     journal_full = ""
#     journal_shortname = ""
#     in_entry = 0
#     has_shortjournal = 0
# }

# /@.*{/ {
#     in_entry = 1
#     has_shortjournal = 0
# }

# /^[[:space:]]*}/ {
#     in_entry = 0
#     has_shortjournal = 0
# }

# /^[[:space:]]*shortjournal[[:space:]]*=/ {
#     if (!has_shortjournal) {
#         has_shortjournal = 1
#         print
#     }
#     next
# }

# /^[[:space:]]*journaltitle[[:space:]]*=/ {
#     found_journal = 1
#     journal_full = $0

#     while ($0 !~ /},[[:space:]]*$/) {
#         if (getline) {
#             journal_full = journal_full " " $0
#         } else {
#             break
#         }
#     }

#     if (journal_full ~ /Proceedings of the National Academy of Sciences/) {
#         journal_shortname = "PNAS"
#     } else if (journal_full ~ /Briefings in Bioinformatics/) {
#         journal_shortname = "Brief. Bioinf."
#     } else if (journal_full ~ /Nature Communications/) {
#         journal_shortname = "Nat. Comms."
#     } else if (journal_full ~ /Nature Reviews Molecular Cell Biology/) {
#         journal_shortname = "Nat. Rev. Mol. Cell Biol."
#     } else if (journal_full ~ /Archiv für mikroskopische Anatomie/) {
#         journal_shortname = "Arch. mikrosk. Anatomie"
#     } else if (journal_full ~ /Cold Spring Harbor Symposia on Quantitative Biology/) {
#         journal_shortname = "CSH Symp. Quant. Biol."
#     } else if (journal_full ~ /Archives Internationales De Physiologie Et De Biochimie/) {
#         journal_shortname = "Arch. Int. Phys. Bioch."
#     } else if (journal_full ~ /Nature Structural & Molecular Biology/) {
#         journal_shortname = "Nat. Struct. Mol. Biol."
#     } else if (journal_full ~ /Perspectives in Biology and Medicine/) {
#         journal_shortname = "Perspect. Biol. Med."
#     } else if (journal_full ~ /Journal of Experimental Medicine/) {
#         journal_shortname = "J. Exp. Med."
#     }

#     print journal_full

#     if (journal_shortname != "" && !has_shortjournal) {
#         print "  shortjournal = {" journal_shortname "},"
#         has_shortjournal = 1
#     }

#     next
# }

# { print }
# ' "$BIBFILE" > "$BIBFILE.tmp" && mv "$BIBFILE.tmp" "$BIBFILE"

# echo "Journal short names processing complete."

# # Debug: Show shortjournal entries
# echo "Checking for inserted shortjournal fields..."
# grep -i "shortjournal =" "$BIBFILE" | head -n 5
# # Remove any line that contains exactly "DELETEME"
sed -i '' '/^[[:space:]]*DELETEME[[:space:]]*$/d' "$BIBFILE"

echo "Conversion complete. Updated file: $BIBFILE"