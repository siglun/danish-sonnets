#!/bin/bash

java -jar ~/saxon/saxon9he.jar sonnet-analysis.xml  render.xsl  > shit.html
# xsltproc render.xsl  sonnet-analysis.xml > shit.html
xmllint  --xinclude shit.html > sonnet-analysis.html

rm shit.html
