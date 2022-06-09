#!/bin/bash

java -jar ~/saxon/saxon9he.jar sonnet-analysis.xml  render.xsl  > shit.html
xmllint  --xinclude shit.html > sonnet-analysis.html
rm shit.html

xsltproc teip5toms.xsl  sonnet-analysis.xml >  sonnet-analysis.ms
groff -ms -k  -s -P-pa4 -Tps parameters.ms  sonnet-analysis.ms >  sonnet-analysis.ps


