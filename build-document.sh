#!/bin/bash

xsltproc render.xsl  sonnet-analysis.xml > shit.html
xmllint  --xinclude shit.html > sonnet-analysis.html

rm shit.html
