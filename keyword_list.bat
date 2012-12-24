REM mawk -F "," "{print $3}"
cut -d, -f3 telephones_data.csv | tr "[:space:]" \n | tr -d "[()]" | sort | uniq > keywords.txt
for keyword in `cat keywords.txt`
  touch .\wordlists\$keyword
endfor