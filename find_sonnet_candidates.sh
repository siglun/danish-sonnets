#!/bin/bash

#
# Collects and summarizes data from ADL repo, which need to in sib directory to this one.
#
#

source "parameters.sh"

XSL="$HERE/sonnet_candidate.xsl"

echo '<?xml version="1.0" encoding="UTF-8" ?>'
echo '<table>'

(cd $THERE ; find . -name  "*.xml" -exec  $SAXON -xsl:"$XSL" -s:{}  file_name={} \; ) | grep -vP '^\s*$' | grep -vP '<\/?table'

echo  '</table>'
