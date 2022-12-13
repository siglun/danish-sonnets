#!/bin/bash


source "parameters.sh"

$SAXON  sonnet-analysis.xml  tei-to-markdown.xsl > sonnet-analysis.md


