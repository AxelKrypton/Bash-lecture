# Does only work on Unix/Linux-like enviroments

TEXCOMPILER = latexmk
TEXOPTIONS = -xelatex --synctex=1 -interaction=batchmode
TEXSOURCESLIDES = Day_
TEXSOURCEEXERCISE = Exercise_
CLEANUP_FILES = .bbl .bcf .blg .out .synctex.gz .tex.backup '~' .log  .toc .aux .tdo .ps .dvi .xml frn.tex blx.bib .vrb .snm .nav .xdv .fls .fdb_latexmk
DAYS = 1 2 3 4 5
LIVEDATE = `date +'on %y.%m.%d at %H:%M:%S'`

.PHONY: slides

default : all clean

help	:
	# This Makefile provides :
	# clean    - deletes all auxiliary files
	# slides   - generates the slides of one day
	# exercise - generates the exercise sheet of one day
	# count    - counts number of words
	# default  - compile all slides and exercises and clean

clean :
	@for f in $(CLEANUP_FILES); do \
		find . -iname '*'$$f -exec echo "rm -rf {}" \; ; \
		find . -iname '*'$$f -exec rm -rf {} \; ; \
	done

slides :
ifdef DAY
	@printf '\n\e[92m==> Compiling \e[1m$(TEXSOURCESLIDES)$(DAY).tex\e[22;96m %s\e[0m\n\n' "$(LIVEDATE)"\
	; timestamp_start=$$(date +%s)\
	; $(TEXCOMPILER) $(TEXOPTIONS) $(TEXSOURCESLIDES)$(DAY).tex\
	&& mv $(TEXSOURCESLIDES)$(DAY).pdf ..\
	&& printf '\n\e[92m==> File \e[1m$(TEXSOURCESLIDES)$(DAY).pdf\e[22m sucessfully produced in \e[93m%d seconds.\e[0m\n\n' "$$(($$(date +%s)-timestamp_start))"
else
	@printf '\n\e[91m==> No day specified, use e.g. "make DAY=1 slides"\e[0m\n\n'
endif

exercise :
ifdef DAY
	@printf '\n\e[92m==> Compiling \e[1m$(TEXSOURCEEXERCISE)$(DAY).tex\e[22;96m %s\e[0m\n\n' "$(LIVEDATE)"\
	; timestamp_start=$$(date +%s)\
	; $(TEXCOMPILER) $(TEXOPTIONS) $(TEXSOURCEEXERCISE)$(DAY).tex\
	&& mv $(TEXSOURCEEXERCISE)$(DAY).pdf ..\
	&& printf '\n\e[92m==> File \e[1m$(TEXSOURCEEXERCISE)$(DAY).pdf\e[22m sucessfully produced in \e[93m%d seconds.\e[0m\n\n' "$$(($$(date +%s)-timestamp_start))"
else
	@printf '\n\e[91m==> No day specified, use e.g. "make DAY=1 exercise"\e[0m\n\n'
endif

all:
	$(MAKE) DAY=0 slides
	for day in $(DAYS) ; do \
		$(MAKE) DAY=$$day slides; \
		$(MAKE) DAY=$$day exercise; \
    done

count : clean
	# Words : 
	wc `find | grep "\.tex" | grep -v ".svn" | grep -v "def.tex"`

