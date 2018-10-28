# MAKEFILE FILE CHUNKS
######################

# VARIABLE DEFINITIONS
######################

FILE  := Clojure-Lang
SHELL := /bin/bash

# DEFAULT Target
################
.PHONY : TWJR TANGLE WEAVE TEXI INFO PDF HTML
.PHONY : default twjr tangle weave texi info pdf html
default : INFO PDF HTML

# TWJR TARGETS
##############
TWJR : twjr
twjr : distclean tangle weave

TANGLE : tangle
tangle : $(FILE).twjr
	jrtangle $(FILE).twjr

WEAVE : weave
weave : TEXI
TEXI  : texi
texi  : $(FILE).texi
$(FILE).texi : $(FILE).twjr
	jrweave $(FILE).twjr > $(FILE).texi

INFO : info
info : $(FILE).info
$(FILE).info : $(FILE).texi
	makeinfo $(FILE).texi
openinfo : INFO
	emacs $(FILE).info

PDF : pdf
pdf : $(FILE).pdf
$(FILE).pdf : $(FILE).texi
	pdftexi2dvi --build=tidy --build-dir=build --quiet $(FILE).texi
openpdf : PDF
	open $(FILE).pdf

HTML : html
html : $(FILE)/index.html
$(FILE)/index.html : $(FILE).texi
	makeinfo --html $(FILE).texi
openhtml : HTML
	open $(FILE)/index.html

.PHONY : clean dirclean distclean worldclean

# remove backup files
clean :
	rm -f *~ .*~ #*#

# remove all directories; leave TexiwebJr, Texinfo files, Makefile
dirclean : clean
	for file in *; do          \
	  case $$file in           \
	    $(FILE)* | Makefile) ;;\
	    my-bib-macros*)      ;;\
	    *) rm -vfr $$file	 ;;\
	  esac                     \
	done

# after dirclean, remove HTML and PDF files
distclean : dirclean
	rm -vfr $(FILE) $(FILE).pdf

# after distclean, remove INFO
worldclean : distclean
	rm -rfv $(FILE).info*


