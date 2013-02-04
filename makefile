#Make a telephone directory from a telephone list.
#Uses keywords to create a an index rather than just a single list.
#The keyword list must be up to date because there are variables used in the directory rules which are based on that list.
#To emphasise the point, the recipe for building the keyword list must be executed before those variables are defined.     

contrib_dir=contrib/
keyword_dir=keywords/

PERL=C:\strawberry\perl\bin\PERL.EXE
SCRIPT_CSV2TEXTILE=csv2textile.mawk
SCRIPT_KEYWORD2HASHTAG=keyword2hashtag.mawk
TELEPHONE_DATA_FILE=telephone_data.csv
KEYWORD_LIST_FILE=keywords.txt
textile_header=$(contrib_dir)textile_header.textile

.PHONY: directory

all : config directory
config : $(KEYWORD_LIST_FILE) 
directory: config telephone_directory.pdf telephone_directory.html


keyword_list:=$(shell cat $(KEYWORD_LIST_FILE))
#keyword_file_stems=$(patsubst %,keyword_%,$(keyword_list)) 
keyword_file_stems:=$(keyword_list:%=$(keyword_dir)%)
keyword_PDFs:=$(addsuffix .pdf,$(keyword_file_stems))
keyword_TEXTILEs:=$(addsuffix .textile,$(keyword_file_stems))
keyword_CSVs:=$(addsuffix .csv,$(keyword_file_stems))



#telephone_directory.pdf : $(addsuffix .pdf,$(keyword_file_stems))
telephone_directory.pdf : $(keyword_PDFs)
#	@echo use pdftk to cat all the files together. Also need to ensure they are sorted alphabetically first - rely on the keyword list being alphabetical.

telephone_directory.html : telephone_directory_pages.html telephone_index.html
	@echo Cat together the HTML preamble, pages and closure.
	cat ./contrib/html_preamble.html > $@
	echo '<div class="index">'  >> $@
	echo '<nav class="index">'  >> $@
	cat ./telephone_index.html >> $@
	echo '</nav>'  >> $@
	echo '</div>'  >> $@
	cat ./telephone_directory_pages.html >> $@
	cat ./contrib/html_footer.html >> $@

telephone_directory_pages.html: %.html : %.textile
	$(PERL) textile2html.pl $<

telephone_directory_pages.textile: $(wildcard $(keyword_dir)*.textile)
	cat $^ > $@
	
telephone_index.html: %.html : %.textile
	$(PERL) textile2html.pl $<

#Checked to here so far

telephone_index.textile: $(KEYWORD_LIST_FILE)  
	mawk -f lines2links.mawk $(KEYWORD_LIST_FILE) > telephone_index.textile

# This next rule could be broadened to %.pdf, with a filter to exclude the keyword files.  
$(keyword_PDFs) : %.pdf : %.textile
#	@echo Command required here to create keyword PDFs from Textile.

.SECONDEXPANSION:
$(keyword_TEXTILEs) : thiskeyword=$(patsubst $(keyword_dir)%.textile,%,$@)
$(keyword_TEXTILEs) : thishashtag=$(shell echo $(thiskeyword) | mawk -f "$(SCRIPT_KEYWORD2HASHTAG)")
$(keyword_TEXTILEs) : %.textile : %.csv $(SCRIPT_CSV2TEXTILE) $(SCRIPT_KEYWORD2HASHTAG)
	@echo Create keyword Textile from CSVs.
	@echo Keyword is $(thiskeyword)
	@echo Index hashtag is $(thishashtag)
	@echo h1\(#$(thishashtag)\). $(thiskeyword) > $@
	cat $(textile_header) >> $@
	@echo Prerequisites are: $< 
	mawk -f $(SCRIPT_CSV2TEXTILE) $< >> $@

$(keyword_CSVs) : keywords.txt $(TELEPHONE_DATA_FILE)
	grep -sw $(patsubst $(keyword_dir)%.csv,%,$@) $(TELEPHONE_DATA_FILE) > $@

keywords.txt : $(TELEPHONE_DATA_FILE)
#	cut -d, -f3 $(TELEPHONE_DATA_FILE) | tr -d "[()]" | mawk "{gsub(//,"X");print}" | tr -d "'" | tr "[:space:]" \n | sort | uniq > $(KEYWORD_LIST_FILE)
	grep -iv ^[a-z] $(TELEPHONE_DATA_FILE) | cut -d, -f3 | tr -d "[()]" | mawk -f clean_possessives.mawk | tr -d "'" | tr "[:space:]" "\n" | sort | uniq > $(KEYWORD_LIST_FILE)

telephone_data.csv :

$(SCRIPT_CSV2TEXTILE):

.PHONY : clean clean-list clean-csv clean-textile clean-pdf

clean : clean-list clean-csv clean-textile clean-pdf

clean-list:
	rm $(KEYWORD_LIST_FILE)

clean-csv:
	rm $(wildcard $(keyword_dir)*.csv)

clean-textile:
	rm $(wildcard $(keyword_dir)*.textile)

clean-pdf:
	rm $(wildcard $(keyword_dir)*.pdf)
