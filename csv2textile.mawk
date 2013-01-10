BEGIN{
	FS=","
	OFS="|"
	ORS="|\n"
}
{if (length($5)==0) notes="(empty_notes). ..."; else notes="(notes). "$5}
{has_see_also=""}
$6 ~ /.+/ {has_see_also="(has-see-also). "}
{print has_see_also,"(name). "$3,"(shortcode). "$2,"(tel_number). "$4,notes;}
$6 ~ /.+/ {print "","(see-also). _See also_ " $6}
END{
	OFS=""
	ORS="\n"
	print "";
}
