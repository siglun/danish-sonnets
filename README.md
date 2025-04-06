
# Sex, death and sonnets -- musings of a software developer

Sigfrid Lundberg

This note discusses how software can recognize sonnets, by
analysis of text length, strophe structure and number of syllables
per line. It also makes a simple content analysis based on
word frequency analyses.

The results clearly shows that simple Unix™ for Poets
analyses combines seamlessly with TEI markup and XML technologies.

* [sonnet-analysis.md](sonnet-analysis.md)
* [sonnet-analysis.html](sonnet-analysis.html)
* [sonnet-analysis.pdf](sonnet-analysis.pdf)
* [sonnet-analysis.xml](sonnet-analysis.xml)

You get best [reading comfort by downloading the PDF](https://raw.githubusercontent.com/siglun/danish-sonnets/main/sonnet-analysis.pdf)

## How to work with these problems

I doubt that you want to work with these problems in the way I
do. Still it you might want to check things, or perhaps even develop
things further. Note that you must clone two git repositories in order
to do that.

* git clone git@github.com:siglun/danish-sonnets.git
* git clone git@github.com:kb-dk/public-adl-text-sources.git

To retry my analyses you'll must work on a Unix or Linux system, have
JAVA and perl programming languages and both xsltproc and SAXON xslt
processors. There are also shell scripts and a Makefile and I do some
processing using xmllint.

The documents are authored in TEI xml and you need xsltproc and GNU
groff to format them.

There is a parameters.sh which is sourced all over the place. Edit
it to set relevant parameters:

```
SAXON_JAR="/where/your/Saxon-HE-9.9. or better can be found .jar"
SAXON="java -jar $SAXON_JAR "

PROJECTS="$HOME/projects"

HERE="$PROJECTS/danish-sonnets"
THERE="$PROJECTS/public-adl-text-sources"
```
