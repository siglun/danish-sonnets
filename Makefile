
.SUFFIXES: .pic .ms .pdf .ps .eps .xml
.DEFAULT: .xml.ms .ms.pdf .ps.pdf .eps.pdf

default: sonnet-analysis.pdf

.xml.ms:
	xsltproc teip5toms.xsl  $< | grep -v '^$$' >  $*.ms

.ms.pdf:
	pdfroff -U  -m pdfpic -m pdfmark -ms -k  -s -t -P-pa4 -Tps \
	parameters.ms  $< >  $*.pdf

.eps.pdf:
	epstopdf  $<

clean:
	rm -f *~ *.ps *.pdf article.ms

sonnet-analysis.pdf: parameters.ms sonnet-analysis.ms  Makefile distro.pdf

sonnet-analysis.ms: sonnet-analysis.xml
distro.pdf: distro.eps


