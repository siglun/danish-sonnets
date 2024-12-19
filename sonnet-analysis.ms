.TL
Sex, death and sonnets
.br  
Musings of a software developer
.AU
Sigfrid Lundberg
.AI
slu@kb.dk
Digital Transformation
Royal Danish Library
Post box 2149
1016 Copenhagen K
Denmark
.AB
.LP
This note discusses how software can recognize sonnets, by analysis of text length, strophe structure and number of syllables per line. It also makes a simple content analysis based on word frequency analyses.
.LP
The results clearly shows that simple Unix™ for Poets analyses combines seamlessly with TEI markup and XML technologies.
.AE
.SH
Introduction
.LP
If there are any sonnets, do they rhyme and what are they about?
.LP
I have since many years been a great fan of the tutorial \fIUnix™ for Poets\fP by
.pdfhref L -D kennethchurch Kenneth Ward Church.
\&This note is an investigation of what can be done with a corpus of literary text with very simple tools similar to the ones described by Church in his tutorial. I do not claim that there is anything novel or even significant in this text. Being a scientist, I think like a scientist and don't expect any deep literary theory here.
.SH
Finding poems
.LP
The ADL text corpus contains
.pdfhref L -D adlcorpus literary texts.
\&Since the texts are encoded according to the
.pdfhref L -D teiguidelines TEI guidelines
\&it is easy to find poetry in those files. Typically a piece of poetry is encoded as
.pdfhref L -D tei-ref-lg lines within line groups
\&. More often than not the line groups are embedded in\& \f(CR<div> ... </div>\fP elements.
.LP
A poem may look like this in the source. The poem is by
.pdfhref L -D sophus Sophus Michaëlis (1883).
\&
.DS L
\f(CR\s-2
<div decls="#biblid68251">
   <head>Jeg elsker —</head>
   <lg>
      <l>Jeg elsker Himlens høje Harmoni,</l>
      <l>dens Purpurblomst, som blaaner i det Fjærne,</l>
      <l>den Fred, som risler ned fra Nattens Stjerne,</l>
      <l>det Glimt af Gud, der glider mig forbi;</l>
   </lg>
    <lg>
      <l>og Evighedens tavse Melodi,</l>
      <l>de svundne Slægters kaldende Orkester,</l>
      <l>et Tonehav om en usynlig Mester,</l>
      <l>en Klang af Gud, der bruser mig forbi;</l>
   </lg>
   <lg>
      <l>en magisk Magt fra Hjertets mørke Celle,</l>
      <l>de stærke Længsler, som mod Lyset vælde,</l>
      <l>Naturens evigunge Fantasi;</l>
   </lg>
   <lg>
      <l>det Liv, der spirer midt i selve Døden,</l>
      <l>den Sol, der stiger midt i Aftenrøden,</l>
      <l>— o Glimt af Gud, der glider mig forbi!</l>
   </lg>
   <p>
      <date>12. Septbr. 1893.</date>
   </p>
</div>
\fP
.DE
.LP
The default name space is declared as xmlns="http://www.tei-c.org/ns/1.0", which we in following refer to with the namespace prefix 't'.
.LP
The poem comprises four line groups with four, four, three and three lines. That is a very common strophe structure (according to the
.pdfhref L -D sonnets Sonnets
\&article in Wikipedia), at least in Scandinavia. It is not always like that, but they all contain 14 lines.
.LP
Shakespeare wrote often his 14 lines typographically in one strophe, whereas Francesco Petrarca wrote them in two strophes with eight and six lines, respectively (again see article
.pdfhref L -D sonnets Sonnets
\&in Wikipedia).
.LP
To be more precise, a sonnet has one more characteristics than having 14 lines, the lines should be in
.pdfhref L -D pentameter iambic pentameter.
\&
.SH
Finding sonnets
.LP
You can easily find all poems in the corpus based on a XPATH query like:
.DS L
\f(CR\s-2 //t:div[t:lg and @decls] \fP
.DE
We can use that query in XSLT like this:
.DS L
\f(CR\s-2 
        <xsl:for-each select="//t:div[t:lg and @decls]">
           <xsl:if test="count(.//t:lg/t:l)=14">
              <!-- script's got to do what a script's got to do -->
           </xsl:if>
        </xsl:for-each>
        \fP
.DE
.LP
So we iterate over all\& \f(CR<div>...</div>\fP s having line groups inside and have a `@decls` attribute containing a reference to metadata in the TEI header. The latter is not universal, but we use it in ADL and that attribute is only set on pieces that a cataloger has designated as a
\fIwork.\fP
The decisions as to what is a work was based on the experience of what library patrons ask for at the information desk. I have implemented this using the shell script  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/find_sonnet_candidates.sh find_sonnet_candidates.sh
and a transform  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/sonnet_candidate.xsl sonnet_candidate.xsl
. Finally, we don't do anything unless there are 14 lines of poetry.
.LP
This transformation creates a long,  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/sonnet_candidates.xml sonnet_candidates.xml
, table with data about the sonnet candidates it finds.
.SH
Approximately pentametric
.LP
Finding\& \f(CR<div>...</div>\fP s having 14 lines of poetry isn't good enough. We are expecting iambic pentameter, don't we? To actually analyse the texts for their rythmical properties is beyond me, but we could make an approximation.
.LP
Iambic verse consists of feet with two syllables, i.e. if there are five feet per line we could say that iambic verse has approximately 10 vowels per line. It is an approximation since a iamb should have the stress on the second syllable (due to ignorance I ignore the musical aspect of this; we will include false positives since lines of poetry with five feet must not be
\fBiambic.\fP
.LP
Any way, this script calculates the average number of vowels per line in poems with 14 lines:
.DS L
\f(CR\s-2 
        <xsl:variable name="vowel_numbers" as="xs:integer *">
           <xsl:for-each select=".//t:lg/t:l">
              <xsl:variable name="vowels">
                 <xsl:value-of select="replace(.,'[^iyeæøauoå]','')"/>
              </xsl:variable>
              <xsl:value-of select="string-length($vowels)"/>
           </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="format-number(sum($vowel_numbers) div 14, '#.####')"/>
        \fP
.DE
.LP
We use the replace function and a regular expression to remove everything in each line except the vowels. Then we measure the string length which should equal the number of vowels per line and add them together for all lines in the poem. Finally we divide that sum with 14 and get the average number of vowels per line.
.LP
For a sonnet it would be about 10,
.pdfhref L -D hendecasyllable or occasionally a little more.
\&Danish is a language rich in diftons, which could be another reason for lines deviating from the expected 10 vowels. In the Michaëlis poem quoted above it is 10.4.
.SH
Strophe structure
.LP
You can write a lot of nice poetry with 14 lines. Like Gustaf Munch-Petersen's  
.pdfhref W -D https://tekster.kb.dk/text/adl-texts-munp1-shoot-workid62017 en borgers livshymne
with one strophe with one line, then three strophes with four lines and finally a single line. The number of syllables per line seem to decrease towards the end. Gustaf was a modernist. There are no fixed structures and very few rhymes i his poetry.
.LP
You can easily find out the strophe structure for each poem:
.DS L
\f(CR\s-2 
        <xsl:variable name="lines_per_strophe" as="xs:integer *">
           <xsl:for-each select=".//t:lg[t:l]">
              <xsl:value-of select="count(t:l)"/>
           </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$lines_per_strophe"/>
        \fP
.DE
.LP
That is, iterate over the line groups in a poem, and count the lines in each of them.
.LP
I have summarized these data about all poems in ADL with 14lines. There are 243 of them (there might be more, but then they have erroneous markup).
.LP
You find these sonnet candidates in a table here  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/sonnet_candidates.xml sonnet_candidates.xml.
Please, find an extract from it below.
.SH
.SH
sonnet candidates
.LP
.TS
tab(;);
lb lb lb lb ;
l l l l .
T{
\s-2File name (link to source)\s+2
T};T{
\s-2Title (link to view)\s+2
T};T{
\s-2Strophe structure\s+2
T};T{
\s-2average number of vowels per line\s+2
T}
_
T{
\s-2  
.pdfhref W -D https://github.com/kb-dk/public-adl-text-sources/blob/master/texts/aarestrup07val.xml ./aarestrup07val.xml
\s+2
T};T{
\s-2  
.pdfhref W -D https://tekster.kb.dk/text/adl-texts-aarestrup07val-shoot-workid73888 Jeg havde faaet Brev fra dig, Nanette
\s+2
T};T{
\s-24 4 3 3\s+2
T};T{
\s-211.0\s+2
T}
T{
\s-2  
.pdfhref W -D https://github.com/kb-dk/public-adl-text-sources/blob/master/texts/aarestrup07val.xml ./aarestrup07val.xml
\s+2
T};T{
\s-2  
.pdfhref W -D https://tekster.kb.dk/text/adl-texts-aarestrup07val-shoot-workid75376 Tag dette Kys, og tusind til, du Søde ...
\s+2
T};T{
\s-24 4 3 3\s+2
T};T{
\s-211.0714\s+2
T}
T{
\s-2  
.pdfhref W -D https://github.com/kb-dk/public-adl-text-sources/blob/master/texts/aarestrup07val.xml ./aarestrup07val.xml
\s+2
T};T{
\s-2  
.pdfhref W -D https://tekster.kb.dk/text/adl-texts-aarestrup07val-shoot-workid76444 Sonet
\s+2
T};T{
\s-24 4 3 3\s+2
T};T{
\s-211.5\s+2
T}
T{
\s-2  
.pdfhref W -D https://github.com/kb-dk/public-adl-text-sources/blob/master/texts/./brorson03grval.xml ./brorson03grval.xml
\s+2
T};T{
\s-2  
.pdfhref W -D https://tekster.kb.dk/text/adl-texts-brorson03grval-shoot-workid76607 1.
\s+2
T};T{
\s-214\s+2
T};T{
\s-28.7143\s+2
T}
T{
\s-2  
.pdfhref W -D https://github.com/kb-dk/public-adl-text-sources/blob/master/texts/claussen07val.xml ./claussen07val.xml
\s+2
T};T{
\s-2  
.pdfhref W -D https://tekster.kb.dk/text/adl-texts-claussen07val-shoot-workid63580 SKUMRING
\s+2
T};T{
\s-214\s+2
T};T{
\s-210.8571\s+2
T}
T{
\s-2  
.pdfhref W -D https://github.com/kb-dk/public-adl-text-sources/blob/master/texts/claussen07val.xml ./claussen07val.xml
\s+2
T};T{
\s-2  
.pdfhref W -D https://tekster.kb.dk/text/adl-texts-claussen07val-shoot-workid66131 MAANENS TUNGSIND
\s+2
T};T{
\s-24 4 3 3\s+2
T};T{
\s-213.8571\s+2
T}
T{
\s-2  
.pdfhref W -D https://github.com/kb-dk/public-adl-text-sources/blob/master/texts/jacobjp08val.xml ./jacobjp08val.xml
\s+2
T};T{
\s-2  
.pdfhref W -D https://tekster.kb.dk/text/adl-texts-jacobjp08val-shoot-workid63094 I Seraillets Have
\s+2
T};T{
\s-214\s+2
T};T{
\s-26.7143\s+2
T}
.TE
.LP
Sophus Claussen's first poem may or may not be a sonnet, Brorson's poem is not. All of those with strophe structure 4 4 3 3 are definitely sonnets, as implied by strophe structure and the "approximately pentametric" number of vowels per line (and, by the way, Aarestrup often points out that he is actually writing sonnets in text or titles).
.SH
Then we have the rhymes
.LP
Beauty is in the eye of the beholder, says Shakespeare. I believe that he is right. Then, however, I would like to add that the rhymes and meters of poetry (like the pentameter) is in the ear of listener. It is time consuming to read houndreds of poems aloud and figure out the rhyme structure. So an approximate idea of the rhymes could be have comparing the verse line endings.
.LP
This is error prone, though. Consider this  
.pdfhref W -D https://tekster.kb.dk/text/adl-texts-moeller01val-shoot-workid62307 sonnet by P.M. Møller
.
.KF
.sp
.QP
\s-2SONET\s+2
.IP
Den Svend, som Tabet af sin elskte frister,
.br
Vildfremmed vanker om blandt Jordens Hytter;
.br
Med Haab han efter Kirkeklokken lytter,
.br
Som lover ham igen, hvad her han mister.
.br
.IP
Men næppe han med en usalig bytter,
.br
Hvis Hjerte, stedse koldt for Elskov, brister,
.br
Som sig uelsket gennem Livet lister,
.br
Hans Armod kun mod Tabet ham beskytter.
.br
.IP
Til Livets Gaade rent han savner Nøglen,
.br
Hver Livets Blomst i Hjærtets Vinter fryser,
.br
Han gaar omkring med underlige Fagter.
.br
.IP
Ræd, Spøgelser han ser, naar Solen lyser,
.br
Modløs og syg, foragtet han foragter
.br
Det skønne Liv som tom og ussel Gøglen.
.br
.KE
.sp
.LP
The the last syllable of the eight first lines are the same '-ter'. If you use some script to compare the endings you'll only find single syllable rhymes and miss double syllable ones rhymes. I.e., you can erroneously categorize feminine rhymes (with two syllables) as masculine ones (with one syllable). (Sorry, I don't know a politically correct vocabulary for these concepts.)
.LP
In order to understand what we hear when reading, we have to consider '-ister' and '-ytter'. I.e., it starts with rhyme structure 'abbabaab' not 'aaaaaaaa'. Furthermore, it continues 'cdedec'.
.LP
I have written a set of scripts that traverse the  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/sonnet_candidates.xml sonnet_candidates.xml
table. Transform that file using  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/iterate_the_rhyming.xsl iterate_the_rhyming.xsl
selects poems with 14 lines and strophe structure 4 4 3 3. It generates a shell script which when executed pipes the content through other scripts that retrieve content, remove punctuation and finally detags them. The actual text is then piped through a perl script that analyse the endings according to the silly and flawed method described above.
.LP
It works, sort of, until it doesn't. For poems with 4 4 3 3 strophe structure, you can find the result in  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/rhymes_3chars.text rhymes_3chars.text
and  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/rhymes_2chars.text rhymes_2chars.text
for three and two letter rhymes, respectively. Run
.DS L
\f(CR\s-2 
        grep -P '^[a-q]{14}' rhymes_3chars.text   | sort | uniq -c | sort -rn
        \fP
.DE
.LP
to get a list of rhyme structure and their frequencies. The rhyme structures that occur more than twice are:
.DS L
\f(CR\s-2
        6 abbaabbacdecde
        5 abbaabbacdcdcd
        4 abcaadeafgghii
        4 abbaabbacdcede
        3 abcaadeafghgig
        \fP
.DE
.LP
This silly algorithm does actually give two of the most common rhyme structure for sonnets, but misses a lot of order in the remaining chaos:
.DS L
\f(CR\s-2abbaabbacdcdcd\fP
.DE
.LP
and
.DS L
\f(CR\s-2abbaabbacdecde\fP
.DE
.LP
So while it may fail more often than it succeeds, the successes give results that are reasonable.
.LP
The rhyme structure abbaabbacdecde is one is the most common ones found. Also it is one of the socalled Petrarchan rhyme schemes (
.pdfhref L -D everysonnet Eberhart, 2018
\&).
.SH
What are the sonnets about?
.LP
Any piece of art is meant to be consumed by humans. Poems should ideally be understood when read aloud and listened to. By humans.
.LP
The cliché says that art and literature is about what it means to be human. Could we therefore hypothesize that the sonnets address this from the point of view of dead Danish male poets who wrote sonnets some 100 – 200 years ago?
.LP
Assume that, at least as a first approximation, the words chosen by poets mirror those subjects. For instance, if being human implies lethality, we could, on a statistical level hypothesize that words like "mourning", "grief", "death", "grave", etc appear in the sonnet corpus more than in a random sample of text. The opposites would also be expected: Concepts related to "love", "birth", "compassion" belong to the sphere of being human.
.LP
I have detagged the poems with 14 lines and strophe structure 4 4 3 3, tokenized their texts and calculated the word frequencies. As a matter of fact, I've done that in two ways:
.LP
(i) The first being doing a classical tokenization followed by piping the stuff through
.DS L
\f(CR\s-2 
        sort | uniq -c | sort -n
        \fP
.DE
.LP
such that I get a list of the 4781 Danish words that are used in our sonnet sample, sorted by their frequencies.
.LP
(ii) The second way is the same, but I do it twice, once for each sonnet such that I get a list of words for each sonnet. Then I repeat that for the concatenated lists for all sonnets.
.LP
This means that I get
.IP \s+1\(bu\s-1
one list of word frequencies in the entire sample and
.IP \s+1\(bu\s-1
a second list giving not of the number of occurences of each word, but the number of sonnets the word occurs in.
.LP
There are 160 sonnets in the selection, and the most frequent word occurs in all of them. These are the fifteen most commont word measured by the  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/poem_frequencies.text number of sonnets they occur in
. Number of poems in the left column.
.DS L
\f(CR\s-2 
        75 du
        76 sig
        82 er
        85 jeg
        86 det
        89 for
        94 den
        101 paa
        104 en
        105 af
        106 til
        119 som
        122 med
        150 i
        160 og
        \fP
.DE
.LP
and this is the list of the same thing, but measured as the grand total  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/frequencies.text occurrence of the words in the corpus
. Number of words in corpus in left column.
.DS L
\f(CR\s-2 
        109 min
        130 for
        144 du
        148 er
        155 paa
        164 til
        167 det
        169 den
        173 af
        206 en
        217 med
        229 som
        246 jeg
        382 i
        588 og
        \fP
.DE
.LP
As you can see this corroborates the established observation that the most frequent words in a corpus hardly ever describes the subject matter of texts (the words are conjunctions, pronouns, prepositions and the like). The distribution of the number of sonnets the words appear in:
.KF
.PDFPIC distro.pdf 12.0c 7.2c
.KE
.sp
.LP
The distribution shows number of words graphed against number of sonnets. There are 3304 words occurring in just one sonnet. The leftmost, and highest, point on the graph has the coordinate (1,3304).
.LP
There is just one word appearing in all 160 sonnets. It is 'og' meaning 'and' corresponding to the rightmost point on the graph which has the coordinate (160,1). As a rule of thumb the most common words are all conjunctions, next to them comes prepositions and after those come pronomina.
.LP
The  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/distribution.text distribution.text
is generated from  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/poem_frequencies.text poem_frequencies.text
using (the line has been folded)
.DS L
\f(CR\s-2 
        sed 's/\ [a-z]*$//' poem_frequencies.text | sort | uniq -c | 
        sort -n -k 2 > distribution.text
        \fP
.DE
.LP
See above. Column 1 is plotted against column 2.
.LP
In this particular corpus, it seems that
\fBaboutishness\fP
start at words occuring in about 25% of the sonnets, or less. I.e., words occuring in 40 sonnets, or fewer.
.LP
In what follows, I have simply used the utility
\f(CRgrep\fP
find words and derivates in the file  
.pdfhref W -D https://github.com/siglun/danish-sonnets/blob/main/poem_frequencies.text poem_frequencies.text
mentioned above.
.LP
As example we have death, dead and lethal etc (basically words containing
\fIdød\fP
) in a number of sonnets. In the left column the number of sonnets containing the word. These appear in about 7% of the sonnets.
.DS L
\f(CR\s-2 
        1 dødehavet
        1 dødeklokker
        1 dødelige
        1 dødeliges
        1 dødningvuggeqvad
        1 dødsberedthed
        1 glemselsdøden
        1 udødeliges
        2 dødes
        5 dødens
        9 død
        9 døden
        11 døde
        \fP
.DE
.LP
There are interesting derivatives and compound words on the list. Like
\fIdødsberedthed\fP
meaning preparedness for death.
\fIGlemselsdøden\fP
refers, I believe, to the death or disappearance due to the disappearance of traces or memories of someone who belonged to generations.
.LP
Love (elskov) is not as popular as death (about 5% of the sonnets).
.DS L
\f(CR\s-2 
        1 elskoven
        1 elskovsbrev
        1 elskovsbrevet
        2 elskovsild
        6 elskovs
        7 elskov
        \fP
.DE
.LP
\fIelskovsild\fP
means the fire of love.
\fIelskovsbrev\fP
has to be love letter.
\fIwomen (kvinde)\fP
are not as popular as love
.DS L
\f(CR\s-2 
        1 dobbeltkvinde
        1 kvindens
        1 kvindetække
        4 kvinder
        \fP
.DE
.LP
Men more than women, and in particular words implying bravery and male virtues
.DS L
\f(CR\s-2 
        1 baadsmandstrille
        1 dobbeltmand
        1 ejermand
        1 manddom
        1 manddomstrods
        1 manden
        2 mand
        2 manddoms
        5 mandens
        \fP
.DE
.LP
Remember that these sonnets are by men.
\fImandom\fP
implies a man's existence as a grownup man. Originally, in
.pdfhref L -D oldnorse old norse
\&, mand meant, just as in Old English, human. That, however, was when it was doubtful if women were actually human. Baadsmandstrille is a derivative of baadsmand (boatswain) which is another name for a sailor or petty officer. A baadsmandstrille is presumably a song sung by sailors.
.LP
Graves occur, for some reason, less than deaths
.DS L
\f(CR\s-2 
        1 begravet
        1 graven
        1 gravene
        1 gravhøi
        1 indgraves
        3 grav
        3 grave
        4 gravens
        \fP
.DE
.LP
indgraves is most likely a kind of
\fIhomonym\fP
, if you look up that sonnet it is clear that it means engrave. There both the verb in past tense begravet (buried) from begrave (as in bury) and grav (as in grave) and gravhøi (tumulus).
.SH
Conclusions
.LP
I think I could go on studying this for quite some time. However, I have to conclude this here, before the actual conclusions. There are interesting things to find here, though. Some of them are possible to study using simple methods, such as those described by
.pdfhref L -D kennethchurch Kenneth Ward Church
\&in his \fIUnix™ for Poets\fP .
.LP
The preliminary result from my armchair text processing exercise supports the notion that life was already in early modern Europe about sex, death and rock n'roll. Since rock wasn't there just yet, people had to be content with sonnets for the time being.
.SH
References
.XP
.pdfhref M -N kennethchurch
Church, Kenneth Ward,
[date unknown]. \fIUnix™ for Poets\fP 
.br  
\s-2\f(CR
.pdfhref W -D https://web.stanford.edu/class/cs124/kwc-unix-for-poets.pdf https://web.stanford.edu/class/cs124/kwc-unix-for-poets.pdf
\fP\s+2
.XP
.pdfhref M -N adlcorpus
Det Kgl. Bibliotek,  and Det Danske Sprog- og Litteraturselskab,
2000 - 2022. \fIThe ADL text corpus\fP 
.br  
\s-2\f(CR
.pdfhref W -D https://github.com/kb-dk/public-adl-text-sources https://github.com/kb-dk/public-adl-text-sources
\fP\s+2
.XP
.pdfhref M -N everysonnet
Eberhart, Larry,
2018. Italian or Petrarchan Sonnet.  In:
\fIEvery Sonnet: The sonnet forms database\fP 
.br  
\s-2\f(CR
.pdfhref W -D https://poetscollective.org/everysonnet/tag/abbaabbacdecde/#post-119 https://poetscollective.org/everysonnet/tag/abbaabbacdecde/#post-119
\fP\s+2
.XP
.pdfhref M -N hendecasyllable
Hendecasyllable.  In:
\fIWikipedia\fP 
.br  
\s-2\f(CR
.pdfhref W -D https://en.wikipedia.org/wiki/Hendecasyllable https://en.wikipedia.org/wiki/Hendecasyllable
\fP\s+2
.XP
.pdfhref M -N pentameter
Iambic pentameter.  In:
\fIWikipedia\fP 
.br  
\s-2\f(CR
.pdfhref W -D https://en.wikipedia.org/wiki/Iambic_pentameter https://en.wikipedia.org/wiki/Iambic_pentameter
\fP\s+2
.XP
.pdfhref M -N sophus
Michaëlis, Sophus,
1883. Jeg elsker —.  In:
\fISolblomster\fP 
.br  
\s-2\f(CR
.pdfhref W -D https://tekster.kb.dk/text/adl-texts-michs_03-shoot-workid68251 https://tekster.kb.dk/text/adl-texts-michs_03-shoot-workid68251
\fP\s+2
.XP
.pdfhref M -N oldnorse
Old Norse.  In:
\fIWikipedia\fP 
.br  
\s-2\f(CR
.pdfhref W -D https://en.wikipedia.org/wiki/Old_Norse https://en.wikipedia.org/wiki/Old_Norse
\fP\s+2
.XP
.pdfhref M -N sonnets
Sonnet.  In:
\fIWikipedia\fP 
.br  
\s-2\f(CR
.pdfhref W -D https://en.wikipedia.org/wiki/Sonnet https://en.wikipedia.org/wiki/Sonnet
\fP\s+2
.XP
.pdfhref M -N teiguidelines
The TEI Consortium,
2022. \fITEI P5: Guidelines for Electronic Text Encoding and Interchange\fP 
.br  
\s-2\f(CR
.pdfhref W -D https://tei-c.org/release/doc/tei-p5-doc/en/html/index.html https://tei-c.org/release/doc/tei-p5-doc/en/html/index.html
\fP\s+2
.XP
.pdfhref M -N tei-ref-lg
The TEI Consortium,
2022. Passages of Verse or Drama.  In:
\fITEI P5: Guidelines for Electronic Text Encoding and Interchange\fP 
.br  
\s-2\f(CR
.pdfhref W -D https://tei-c.org/release/doc/tei-p5-doc/en/html/CO.html#CODV https://tei-c.org/release/doc/tei-p5-doc/en/html/CO.html#CODV
\fP\s+2
