!/^$/ {keyword=$1;
id=tolower(keyword);
gsub(/[^a-z0-9]/,"",id);
print "\"(index-entry) "keyword"\":#"id;}
