# Perl script to convert textile to HTML.

use Text::Textile qw(textile);
my $text;

#$text = <<EOT;
#
#h1. Heading
#
#A _simple_ demonstration of Textile markup.
#
#* One
#* Two
#* Three
#
#"More information":http://www.textism.com/tools/textile is available.
#EOT
#
## procedural usage
#my $html = textile($text);
#print $html;
#
#$text = <<EOT;
#
#h1.  and
#
#
#|_. Name |_. Shortcode |_. Number |_. Notes |
#|Douch and Small|10|1202882936|.|
#|Ives and Shand|16|1202716500|.|
#EOT

open FILE_IN, "<$ARGV[0]";
$text = do { local $/; <FILE_IN> };
$html = textile($text);
(my $outfile=$ARGV[0])=~s/textile/html/i;
open FILE_OUT, ">$outfile";
print FILE_OUT $html;
#print $html;
