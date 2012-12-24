BEGIN{
	FS=","
	OFS="|"
	ORS="|\n"
}
{print "",$3,$2,$4,$5;}
$6 ~ /.+/ {print "","(see-also). See also " $6}
END{
	OFS=""
	ORS="\n"
	print "";
}
