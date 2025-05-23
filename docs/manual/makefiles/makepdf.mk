SRCDIR=src

HTML_DIR=html
ND_HTML_FILES=$(wildcard $(HTML_DIR)/files*/*.html)
ND_PDF=$(patsubst $(HTML_DIR)/%,%,$(ND_HTML_FILES:.html=.pdf))

LAT_COM_SRC=$(SRCDIR)/common.tex
LAT_COM_AUX=$(LAT_COM_SRC:.tex=.aux)

LAT_PDF_SRC=$(SRCDIR)/pdf.tex
LAT_PDF_PDF=$(PROJECT_NAME).pdf

AUX=$(LAT_PDF_PDF:.pdf=.aux)
LOG=$(LAT_PDF_PDF:.pdf=.log)
TOC=$(LAT_PDF_PDF:.pdf=.toc)
OUT=$(LAT_PDF_PDF:.pdf=.out)

.PHONY: clean

all: $(ND_PDF) $(LAT_PDF_PDF)

#--disable-smart-shrinking
%.pdf:
	wkhtmltopdf --page-size letter -B 38 -L 38 -R 38 -T 38 --no-background --enable-local-file-access $(HTML_DIR)/$(basename $@).html $(patsubst %/,%,$(dir $@))_$(notdir $@)

$(LAT_PDF_PDF): $(LAT_PDF_SRC) $(LAT_COM_SRC)
	pdflatex -jobname $(basename $@) -shell-escape -interaction=batchmode $<
	pdflatex -jobname $(basename $@) -shell-escape -interaction=batchmode $<
	rm $(AUX) $(LOG) $(TOC) $(OUT) $(LAT_COM_AUX)

clean:
	rm -rf *.pdf
