#Make a telephone directory from a telephone list.
#Uses keywords to create a an index rather than just a single list.

all : keywords.txt directory

keyword_list=$(shell cat keywords.txt)
#keyword_file_stems=$(patsubst %,keyword_%,$(keyword_list)) 
contrib_dir=contrib/
keyword_dir=keywords/
keyword_file_stems=$(keyword_list:%=$(keyword_dir)%)
keyword_PDFs=$(addsuffix .pdf,$(keyword_file_stems))
keyword_TEXTILEs=$(addsuffix .textile,$(keyword_file_stems))
keyword_CSVs=$(addsuffix .csv,$(keyword_file_stems))

PERL=C:\strawberry\perl\bin\PERL.EXE
SCRIPT_CSV2TEXTILE=csv2textile.mawk

textile_header=$(contrib_dir)textile_header.textile

.PHONY: directory
directory: telephone_directory.pdf telephone_directory.html

#telephone_directory.pdf : $(addsuffix .pdf,$(keyword_file_stems))
telephone_directory.pdf : $(keyword_PDFs)
#	@echo use pdftk to cat all the files together. Also need to ensure they are sorted alphabetically first - rely on the keyword list being alphabetical.

telephone_directory.html : telephone_directory_pages.html
	@echo Cat together the HTML preamble, pages and closure.
	cat ./contrib/html_preamble.html > $@
	cat ./telephone_directory_pages.html >> $@
	cat ./contrib/html_footer.html >> $@

telephone_directory_pages.html: %.html : %.textile
	$(PERL) textile2html.pl $<

telephone_directory_pages.textile: $(keyword_TEXTILES)
	cat $(keyword_TEXTILEs) > $@

# This next rule could be broadened to %.pdf, with a filter to exclude the keyword files.  
$(keyword_PDFs) : %.pdf : %.textile
#	@echo Command required here to create keyword PDFs from Textile.

.SECONDEXPANSION:
$(keyword_TEXTILEs) : thiskeyword=$(patsubst $(keyword_dir)%.textile,%,$@)
$(keyword_TEXTILEs) : %.textile : %.csv $(SCRIPT_CSV2TEXTILE)
	@echo Create keyword Textile from CSVs.
	@echo Keyword is $(thiskeyword)
	@echo h1\(#$(thiskeyword)\). $(thiskeyword) > $@
	cat $(textile_header) >> $@
	@echo Prerequisites are: $< 
	mawk -f $(SCRIPT_CSV2TEXTILE) $< >> $@

$(keyword_CSVs) : keywords.txt telephone_data.csv
	grep -sw $(patsubst $(keyword_dir)%.csv,%,$@) telephone_data.csv > $@

keywords.txt : telephone_data.csv
#	cut -d, -f3 telephone_data.csv | tr -d "[()]" | mawk "{gsub(//,"X");print}" | tr -d "'" | tr "[:space:]" \n | sort | uniq > keywords.txt
	cut -d, -f3 telephone_data.csv | tr -d "[()]" | mawk -f clean_possessives.mawk | tr -d "'" | tr "[:space:]" "\n" | sort | uniq > keywords.txt

telephone_data.csv :

$(SCRIPT_CSV2TEXTILE):

.PHONY : clean clean-list clean-csv clean-textile clean-pdf

clean : clean-list clean-csv clean-textile clean-pdf

clean-list:
	rm keywords.txt

clean-csv:
	rm $(wildcard $(keyword_dir)*.csv)

clean-textile:
	rm $(wildcard $(keyword_dir)*.textile)

clean-pdf:
	rm $(wildcard $(keyword_dir)*.pdf)
