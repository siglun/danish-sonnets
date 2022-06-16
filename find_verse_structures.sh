#!/bin/bash

source "parameters.sh"

XSL="$HERE/verse_structure.xsl"

$SAXON -xsl:"$XSL" -s:sonnet_candidates.xml | xmllint --format -
