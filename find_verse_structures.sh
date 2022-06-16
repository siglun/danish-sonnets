#!/bin/bash

#
# Calculates the distribution of strophe structures. Presenting them
# in a html table.
#
# ./find_verse_structures.sh > strophe_structure_distro.xml
# 

source "parameters.sh"

XSL="$HERE/verse_structure.xsl"

$SAXON -xsl:"$XSL" -s:sonnet_candidates.xml | xmllint --format -
