#!/bin/bash


source "parameters.sh"

XSL="$HERE/sonnet_candidate.xsl"

(cd $THERE ; find . -name  "*.xml" -exec  $SAXON -xsl:"$XSL" -s:{}  file_name={} \; )
