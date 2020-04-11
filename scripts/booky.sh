#!/usr/bin/env bash
# https://github.com/SiddharthPant/booky

# Change to the directory of pdf file
pdf_dir=$(dirname "$1")
pdf=$(basename "$1")
pdf_data="${pdf_dir}/${pdf%.*}""_data.txt"
EXTRACT_FILE="${pdf_dir}/booky_bookmarks_extract"
bookmarks="${2}"

echo "Converting ${bookmarks} to pdftk compatible format"
booky_py < "${bookmarks}" > "${EXTRACT_FILE}"

echo "Dumping pdf meta data..."
pdftk "${pdf_dir}/${pdf}" dump_data_utf8 output "${pdf_data}"

echo "Clear dumped data of any previous bookmarks"
sed -i '/Bookmark/d' "${pdf_data}"

echo "Inserting your bookmarks in the data"
sed -i "/NumberOfPages/r $EXTRACT_FILE" "${pdf_data}"

echo "Creating new pdf with your bookmarks..."
pdftk "${pdf_dir}/${pdf}" update_info_utf8 "${pdf_data}" output "${pdf_dir}/${pdf%.*}""_new.pdf"

echo "Deleting leftovers"
rm "${EXTRACT_FILE}" "${pdf_data}"
