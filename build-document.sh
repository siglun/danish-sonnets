#!/bin/bash

# ps2pdf  -dEPSCrop  distro.eps

SAXON="/usr/share/maven-repo/net/sf/saxon/Saxon-HE/9.9.1.5/Saxon-HE-9.9.1.5.jar"

java -jar $SAXON  sonnet-analysis.xml  render.xsl  > shit.html
xmllint  --xinclude shit.html > sonnet-analysis.html
rm shit.html

xsltproc teip5toms.xsl  sonnet-analysis.xml | grep -v '^$' >  sonnet-analysis.ms
groff -U  -m pdfpic -m pdfmark -ms -k  -s -t -P-pa4 -Tpdf parameters.ms  sonnet-analysis.ms >  sonnet-analysis.pdf




