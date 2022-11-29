<xsl:stylesheet 
    version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

  <!-- xsl:import href="../common/common.xsl"/ -->
  <xsl:import href="../Stylesheets/common/common.xsl"/>
  
 <xsl:strip-space elements="additional address adminInfo
			    altGrp altIdentifier analytic
			    app appInfo application
			    arc argument attDef
			    attList availability back bibl
			    biblFull biblStruct bicond
			    binding bindingDesc body
			    broadcast cRefPattern calendar
			    calendarDesc castGroup
			    castList category cell certainty
			    char charDecl charProp
			    choice cit classDecl
			    classSpec classes climate
			    cond constraintSpec correction
			    custodialHist decoDesc
			    dimensions div div1 div2
			    div3 div4 div5 div6
			    div7 divGen docTitle eLeaf
			    eTree editionStmt
			    editorialDecl elementSpec
			    encodingDesc entry epigraph
			    epilogue equipment event
			    exemplum fDecl fLib
			    facsimile figure fileDesc
			    floatingText forest front
			    fs fsConstraints fsDecl
			    fsdDecl fvLib gap glyph
			    graph graphic group
			    handDesc handNotes history
			    hom hyphenation iNode if
			    imprint incident index
			    interpGrp interpretation join
			    joinGrp keywords kinesic
			    langKnowledge langUsage
			    layoutDesc leaf lg linkGrp
			    list listBibl listChange
			    listEvent listForest listNym
			    listOrg listPerson listPlace
			    listRef listRelation
			    listTranspose listWit location
			    locusGrp macroSpec metDecl
			    moduleRef moduleSpec monogr
			    msContents msDesc msIdentifier
			    msItem msItemStruct msPart
			    namespace node normalization
			    notatedMusic notesStmt nym
			    objectDesc org p  particDesc
			    performance person personGrp
			    physDesc place population
			    postscript precision
			    profileDesc projectDesc
			    prologue publicationStmt
			    quotation rdgGrp recordHist
			    recording recordingStmt
			    refsDecl relatedItem relation
			    relationGrp remarks respStmt
			    respons revisionDesc root
			    row samplingDecl schemaSpec
			    scriptDesc scriptStmt seal
			    sealDesc segmentation
			    seriesStmt set setting
			    settingDesc sourceDesc
			    sourceDoc sp spGrp space
			    spanGrp specGrp specList
			    state stdVals subst
			    substJoin superEntry
			    supportDesc surface surfaceGrp
			    table tagsDecl taxonomy
			    teiCorpus teiHeader terrain
			    text textClass textDesc
			    timeline titlePage titleStmt
			    trait transpose tree
			    triangle typeDesc vAlt
			    vColl vDefault vLabel
			    vMerge vNot vRange valItem
			    valList vocal"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>

         <p>This software is dual-licensed:

1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
Unported License http://creativecommons.org/licenses/by-sa/3.0/ 

2. http://www.opensource.org/licenses/BSD-2-Clause
		


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

This software is provided by the copyright holders and contributors
"as is" and any express or implied warranties, including, but not
limited to, the implied warranties of merchantability and fitness for
a particular purpose are disclaimed. In no event shall the copyright
holder or contributors be liable for any direct, indirect, incidental,
special, exemplary, or consequential damages (including, but not
limited to, procurement of substitute goods or services; loss of use,
data, or profits; or business interruption) however caused and on any
theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use
of this software, even if advised of the possibility of such damage.
</p>
         <p>Author: See AUTHORS</p>
         
         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>

 <xsl:output method="text"/>

 <xsl:template match="teiHeader"/>
 <xsl:template match="figDesc"/>
 <xsl:template match="gap/desc"/>
 <xsl:template match="choice">
   <xsl:apply-templates select="*[1]"/>
 </xsl:template>
 <xsl:template match="speaker"/>
 <xsl:template match="facsimile"/>

 

<xsl:template name="appReading">
     <xsl:param name="lemma"/>
     <xsl:param name="lemmawitness"/>
     <xsl:param name="readings"/>
</xsl:template>

<xsl:template name="emphasize">
      <xsl:param name="class"/>
      <xsl:param name="content"/>
      <xsl:choose>
        <xsl:when test="$class='titlem'">
          <xsl:text>_</xsl:text>
            <xsl:copy-of select="$content"/>
            <xsl:text>_</xsl:text>
        </xsl:when>
        <xsl:when test="$class='titlej'">
          <xsl:text>_</xsl:text>
          <xsl:copy-of select="$content"/>
          <xsl:text>_</xsl:text>
        </xsl:when>
        <xsl:when test="$class='titlea'">
          <xsl:text>‘</xsl:text>
	  <xsl:copy-of select="$content"/>
          <xsl:text>’</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$content"/>
        </xsl:otherwise>
      </xsl:choose>      
</xsl:template>

<xsl:template name="generateEndLink">
  <xsl:param name="where"/>
</xsl:template>

<xsl:template name="horizontalRule">
  <xsl:text>&#10;---&#10;</xsl:text>
</xsl:template>

<xsl:template name="makeBlock">
		<xsl:param name="style"/>
		<xsl:apply-templates/>
		<xsl:call-template name="newline"/>
</xsl:template>

<xsl:template name="makeInline">
      <xsl:param name="before"/>
      <xsl:param name="style"/>
      <xsl:param name="after"/>
</xsl:template>

<xsl:template match="eg[@xml:space='preserve']">
<xsl:text>```
</xsl:text><xsl:value-of select="."/><xsl:text>
```</xsl:text>
</xsl:template>

<xsl:template match="eg"><xsl:value-of disable-output-escaping="no" select="concat('`',normalize-space(.),'`')"/></xsl:template>


<xsl:template name="makeSpan">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="p|front">
  <xsl:call-template name="newline"/>
  <xsl:apply-templates/>
  <xsl:call-template name="newline"/>
</xsl:template>

<xsl:template match="docTitle">
<xsl:call-template name="newline"/>
<xsl:for-each select=".//title[@type='main']"># <xsl:apply-templates select="."/>  </xsl:for-each> <xsl:for-each select=".//title[@type='sub']"> &lt;br> <xsl:apply-templates select="."/>  </xsl:for-each>
<xsl:call-template name="newline"/>
</xsl:template>

<xsl:template match="docAuthor">
<xsl:for-each select=".//name|.//addrLine">
> <xsl:apply-templates select="."/> <xsl:value-of select="'&lt;br&gt;'"/>
</xsl:for-each>
</xsl:template>

<xsl:template match="div[@type='abstract']">
<xsl:call-template name="newline"/>
## Abstract  
<xsl:call-template name="newline"/>
<xsl:apply-templates/>
<xsl:call-template name="newline"/>
</xsl:template>

<xsl:template match="head">
  <xsl:choose>
    <xsl:when test="parent::castList"/>
    <xsl:when test="parent::listBibl"/>
    <xsl:when test="parent::figure"/>
    <xsl:when test="parent::list"/>
    <xsl:when test="parent::front or parent::body or
		    parent::back or parent::lg"> &#10;*<xsl:apply-templates/>&#10; </xsl:when>
    <xsl:when test="parent::table"/>
    <xsl:otherwise>
      <xsl:variable name="depth">
        <xsl:apply-templates mode="depth" select=".."/>
      </xsl:variable>
      <xsl:call-template name="newline"/>
      <xsl:choose>
	<xsl:when test="$depth=0">##</xsl:when>
	<xsl:when test="$depth=1">###</xsl:when>
	<xsl:when test="$depth=2">####</xsl:when>
	<xsl:when test="$depth=3">#####</xsl:when>
	<xsl:when test="$depth=4">######</xsl:when>
	<xsl:otherwise>##</xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
      <xsl:call-template name="newline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="tei:item|tei:biblStruct">
  <xsl:call-template name="newline"/>
  <xsl:choose>
    <xsl:when test="tei:isOrderedList(..)">1. </xsl:when>
    <xsl:otherwise>* </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
  <xsl:call-template name="newline"/>
</xsl:template>

<xsl:template name="newline">
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="listBibl">
<xsl:apply-templates select="head"/>
<xsl:apply-templates select="bibl">
<xsl:sort select="concat(author[1],title[1])" data-type="text"/>
</xsl:apply-templates>
</xsl:template>

<xsl:template match="ref"><xsl:apply-templates/></xsl:template>

<xsl:template match="bibl">
  <xsl:call-template name="newline"/>  
<xsl:for-each select="author|editor"><xsl:if test="position() > 1 and position()=last()"><xsl:text> and </xsl:text></xsl:if><xsl:apply-templates/><xsl:if test="position() >= 1 and not(position() = last())"><xsl:text>, </xsl:text></xsl:if></xsl:for-each><xsl:if test="date"><xsl:text>,
</xsl:text><xsl:apply-templates select="date"/><xsl:text>. </xsl:text></xsl:if><xsl:if test="title">
<xsl:if test="title[@level = 'a']">
<xsl:apply-templates select="title[@level = 'a']"/><xsl:text>. </xsl:text><xsl:if test="title[@level = 'j']|title[@level = 'm']"><xsl:text> In:
</xsl:text></xsl:if>
</xsl:if>
<xsl:if test="title[@level = 'j']|title[@level = 'm']">_<xsl:apply-templates select="title[@level = 'j']|title[@level = 'm']"/>_<xsl:text> </xsl:text>
</xsl:if>
</xsl:if>
<xsl:if test="biblScope[@type='volume']">
<xsl:text>Vol. </xsl:text><xsl:apply-templates select="biblScope[@type='volume']"/><xsl:if test="biblScope[@type='number']">(<xsl:apply-templates select="biblScope[@type='number']"/>)<xsl:choose><xsl:when test="biblScope[@type='pp']"><xsl:text>, </xsl:text></xsl:when><xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise></xsl:choose></xsl:if></xsl:if> <xsl:if test="biblScope[@type='pp']"> <xsl:text>pp. </xsl:text><xsl:apply-templates select="biblScope[@type='pp']"/><xsl:text>. </xsl:text></xsl:if>
<xsl:if test="note">
<xsl:apply-templates select="note/node()"/>
</xsl:if>
<xsl:if test="ref"><xsl:text>
&lt;kbd></xsl:text>[<xsl:apply-templates select="ref/@target"/>](<xsl:apply-templates select="ref/@target"/>)&lt;/kbd>
</xsl:if>
  <xsl:call-template name="newline"/>
</xsl:template>

<xsl:template match="table">
  
   <xsl:for-each select="row[@role='label']"><xsl:for-each select="cell[@role='label']"><xsl:if test="position() = 1">| </xsl:if> <xsl:apply-templates/> | <xsl:if test="position() = last()"><xsl:call-template name="newline"/></xsl:if></xsl:for-each></xsl:for-each>

   <xsl:for-each select="row[@role='label']"><xsl:for-each select="cell[@role='label']"><xsl:if test="position() = 1">| </xsl:if> :-------- | <xsl:if test="position() = last()"><xsl:call-template name="newline"/></xsl:if></xsl:for-each>
</xsl:for-each>

   <xsl:for-each select="row[@role='data']"><xsl:for-each select="cell"><xsl:if test="position() = 1">| </xsl:if> <xsl:apply-templates/> | <xsl:if test="position() = last()"><xsl:call-template name="newline"/></xsl:if></xsl:for-each>
</xsl:for-each>
   
  </xsl:template>

<xsl:template match="*"><xsl:apply-templates/></xsl:template>


 <xsl:function name="tei:isOrderedList" as="xs:boolean">
    <xsl:param name="context"/>
    <xsl:for-each select="$context">
      <xsl:choose>
        <xsl:when test="tei:match(@rend,'numbered')">true</xsl:when>
        <xsl:when test="tei:match(@rend,'ordered')">true</xsl:when>
        <xsl:when test="@type='ordered'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:function>

 <xsl:function name="tei:match" as="xs:boolean">
    <xsl:param name="att"/>
    <xsl:param name="value"/>
    <xsl:sequence select="if (tokenize($att,' ')=($value)) then true()
      else false()"/>
  </xsl:function>

  <xsl:template match="tei:text" mode="depth">
    <xsl:value-of select="count(ancestor::tei:text)-1"/>
  </xsl:template>
  
  <xsl:template match="tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6"
                 mode="depth">
      <xsl:choose>
        <xsl:when test="ancestor::tei:text/parent::tei:group and
                        self::tei:div">
           <xsl:value-of select="count(ancestor::tei:div) + 1"/>
        </xsl:when>
         <xsl:when test="local-name(.) = 'div'">
            <xsl:value-of select="count(ancestor::tei:div)"/>
         </xsl:when>
        <xsl:when test="ancestor::tei:text/parent::tei:group">
           <xsl:value-of select="number(substring-after(local-name(.),'div')) "/>
        </xsl:when>
        <xsl:when test="ancestor::tei:text/parent::tei:group">
          <xsl:value-of select="number(substring-after(local-name(.),'div'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(substring-after(local-name(.),'div')) - 1"/>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  
</xsl:stylesheet>
