#!/bin/bash


source "parameters.sh"

$SAXON  article.xml  tei-to-markdown.xsl > article.md


