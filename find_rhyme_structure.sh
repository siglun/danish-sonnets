#!/bin/bash

# The script should be run from the directory where it lives and
# accepts two options -f and -x with arguements. For example:
# 
# ./find_rhyme_structure.sh -f file_name \ 
#                   -x xmlid for work
#
# You run it by transforming
#
# xsltproc iterate_the_rhyming.xsl sonnet_candidates.xml
#
# which generates a shell script which runs this script for each sonnet_candidate
# that is, pipe the result of the transform to shell
#
# xsltproc iterate_the_rhyming.xsl sonnet_candidates.xml  | bash
#
# The results are in the rhymes_2chars.text and rhymes_3chars.text
#
# See the main text for discussion
#

while getopts "f:x:" flag
do
  case $flag in
    f) FILE_NAME=$OPTARG; export FILE_NAME  ;;
    x) XMLID=$OPTARG; export XMLID ;;
  esac
done

source "parameters.sh"

HERE="$PROJECTS/danish-sonnets"
THERE="$PROJECTS/public-adl-text-sources/texts"

FILE="$THERE/$FILE_NAME"
XSL="./rhyme_structure.xsl"

echo "$FILE_NAME $XMLID "

$SAXON -xsl:"$XSL" -s:"$FILE" file_name="$FILE" print_position=1 work_id="$XMLID" | ./find_the_rhyme.pl
