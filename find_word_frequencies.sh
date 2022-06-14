#!/bin/bash

# The script should be run from the directory where it lives and
# accepts two options -f and -x with arguements. For example:
# 
# ./find_rhyme_structure.sh -f file_name \ 
#                   -x xmlid for work
#

while getopts "f:x:" flag
do
  case $flag in
    f) FILE_NAME=$OPTARG; export FILE_NAME  ;;
    x) XMLID=$OPTARG; export XMLID ;;
  esac
done

SAXON_JAR="/usr/share/maven-repo/net/sf/saxon/Saxon-HE/9.9.1.5/Saxon-HE-9.9.1.5.jar"
SAXON="java -jar $SAXON_JAR"

PROJECTS="$HOME/projects"

HERE="$PROJECTS/danish-sonnets"
THERE="$PROJECTS/public-adl-text-sources"

FILE="$THERE/texts/$FILE_NAME"
XSL="./rhyme_structure.xsl"

$SAXON -xsl:"$XSL" -s:"$FILE" file_name="$FILE" work_id="$XMLID" | ./find_words.pl unique
