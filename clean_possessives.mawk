{
	gsub(/'s/,"",$0);
	gsub(/\$and\^/,"",$0);
	gsub(/^the$/,"",$0);
	print;
}