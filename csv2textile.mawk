BEGIN{
	FS=","
	OFS="|"
	ORS="|\n"
}
{if (length($5)==0) notes="..."; else notes=$5}
$6 ~ /.+/ {has_see_also="(has-see-also). "}
{print has_see_also,$3,$2,$4,notes;}
$6 ~ /.+/ {print "","(see-also). _See also_ " $6}
END{
	OFS=""
	ORS="\n"
	print "";
}
