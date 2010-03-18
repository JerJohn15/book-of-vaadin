<?xml version='1.0'?>
<!-- ==================================================================== -->
<!-- IT Mill Customizations to PDF formatting.                            -->
<!-- ==================================================================== -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:import href="custom-fo-docbook.xsl"/>

  <xsl:param name="paper.type" select="'A6'"/>
  <xsl:param name="page.width" select="'10.795cm'"/>
  <xsl:param name="page.height" select="'17.462cm'"/>
  <xsl:param name="page.margin.inner" select="'1.5cm'"/>
  <xsl:param name="page.margin.outer" select="'1.1cm'"/>
  <xsl:param name="page.margin.top" select="'1.0cm'"/>
  <xsl:param name="page.margin.bottom" select="'0.8cm'"/>

  <xsl:param name="manual.fonts.custom" select="false"/>

  <!-- Indentation and spacing. -->
  <xsl:param name="body.start.indent" select="'0'"/>

  <!-- List indentation. -->
  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="margin-left">0.5cm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:param name="formal.title.placement">
    figure after
    example before
    equation after
    table before
    procedure before
  </xsl:param>

  <!-- Turn hyphenation on in monospace (parameter)-->
  <xsl:attribute-set name="monospace.properties">
    <xsl:attribute name="font-size">
      <xsl:choose>
        <xsl:when test="$manual.fonts.custom">90%</xsl:when>
        <xsl:otherwise>90%</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="hyphenate">true</xsl:attribute>
  </xsl:attribute-set>

  <!-- Even smaller monospace. -->
  <xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="font-size">
      <xsl:choose>
        <!-- The ?pocket-size xx% ? instructions allows further scaling. -->
        <xsl:when test="processing-instruction('pocket-size') and not($manual.fonts.custom)">
          <xsl:value-of select="processing-instruction('pocket-size')"/>
          <xsl:text>%</xsl:text>
        </xsl:when>

        <!-- For custom Vaadin fonts, the scaling percentage must be scaled 9/x. -->
        <xsl:when test="processing-instruction('pocket-size') and $manual.fonts.custom">
          <xsl:value-of select="string(number(substring-before(processing-instruction('pocket-size'),'%'))*1.125)"/>
          <!-- xsl:value-of select="string(number(substring-before(processing-instruction('pocket-size'),'%'))*1.0588)"/ -->
          <xsl:text>%</xsl:text>
        </xsl:when>

        <xsl:when test="$manual.fonts.custom">
          <!-- 0.9 for 8pt master font, 0.84706 for 8.5pt. -->
          <xsl:value-of select="$body.font.master * 0.9"/>
          <!-- xsl:value-of select="$body.font.master * 0.84706"/-->
          <xsl:text>pt</xsl:text>
        </xsl:when>

        <xsl:otherwise>
          <!-- 0.8 for 9pt master font. -->
          <xsl:value-of select="$body.font.master * 0.8"/>
          <xsl:text>pt</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>  

    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-style">normal</xsl:attribute>
  </xsl:attribute-set>

  <!-- Do not display URLs in brackets after the link text. -->
  <xsl:param name="ulink.show" select="'0'"/>

  <!-- Use zero-space space for hyphenating verbatim. -->
  <xsl:param name="hyphenate.verbatim.characters">&#x200B;</xsl:param>

  <!-- Admonition graphics (warning and note boxes). -->
  <xsl:param name="admon.graphics">1</xsl:param>
  <xsl:param name="admon.graphics.path">manual/img/icons/</xsl:param>

  <!-- Admonition (warning/note) box. -->
  <xsl:attribute-set name="graphical.admonition.properties">
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">1pt</xsl:attribute>
    <xsl:attribute name="border-color">grey</xsl:attribute>
    <xsl:attribute name="padding">2pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Admonition (warning/note) title. -->
  <xsl:attribute-set name="admonition.title.properties">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- ==================================================================== -->
  <!-- Table of Contents                                                    -->
  <!-- ==================================================================== -->

  <!-- Smaller indentation than usual. -->
  <xsl:param name="toc.indent.width" select="'5'"/>

  <!-- Have chapter titles in bold. (from autotoc.xsl)-->
  <xsl:template name="toc.line">
    <xsl:param name="toc-context" select="NOTANODE"/>
    
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    
    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>
    
    <fo:block xsl:use-attribute-sets="toc.line.properties"
      end-indent="{$toc.indent.width}pt"
      last-line-end-indent="-{$toc.indent.width}pt">

      <!-- Vaadin customization: -->
      <xsl:choose>
        <xsl:when test="self::chapter">
          <xsl:attribute name="font-weight">bold</xsl:attribute>
          <xsl:attribute name="margin-top">2.5mm</xsl:attribute>
        </xsl:when>
      </xsl:choose>

      <fo:inline keep-with-next.within-line="always">
        <fo:basic-link internal-destination="{$id}">
          <xsl:if test="$label != ''">
            <xsl:copy-of select="$label"/>
            <xsl:value-of select="$autotoc.label.separator"/>
          </xsl:if>
          <xsl:apply-templates select="." mode="titleabbrev.markup"/>
        </fo:basic-link>
      </fo:inline>
      <fo:inline keep-together.within-line="always">
        <xsl:text> </xsl:text>
        <fo:leader leader-pattern="dots"
          leader-pattern-width="3pt"
          leader-alignment="reference-area"
          keep-with-next.within-line="always"/>
      <xsl:text> </xsl:text>
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </fo:inline>
  </fo:block>
  </xsl:template>

  <!-- Only generate ToC of chapters/sections. -->
  <xsl:param name="generate.toc">
    appendix  nop
    article   toc,title
    book      toc,title
    chapter   toc
    part      nop
    preface   nop
    qandadiv  nop
    qandaset  nop
    reference toc,title
    section   nop
    set       toc
  </xsl:param>

  <!-- Only first level section titles in chapter ToC. From autotoc.xsl. -->  
  <xsl:template match="section" mode="toc">
    <xsl:param name="toc-context" select="."/>
    
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    
    <xsl:variable name="cid">
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$toc-context"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="depth" select="count(ancestor::section) + 1"/>
    <xsl:variable name="reldepth"
      select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

    <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

    <!-- xsl:message>
      <xsl:text>toc-context: </xsl:text>
      <xsl:value-of select="local-name($toc-context)"/>
    </xsl:message -->

    <xsl:variable name="toc.section.depth.vaadin">
      <xsl:choose>
        <xsl:when test="local-name($toc-context) = 'chapter'">1</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$toc.section.depth"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$toc.section.depth.vaadin &gt;= $depth">
      <xsl:call-template name="toc.line">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:call-template>
      
      <xsl:if test="$toc.section.depth > $depth and $toc.max.depth > $depth.from.context and section">
        <fo:block id="toc.{$cid}.{$id}">
          <xsl:attribute name="margin-left">
            <xsl:call-template name="set.toc.indent">
              <xsl:with-param name="reldepth" select="$reldepth"/>
            </xsl:call-template>
          </xsl:attribute>
          
          <xsl:apply-templates select="section" mode="toc">
            <xsl:with-param name="toc-context" select="$toc-context"/>
          </xsl:apply-templates>
        </fo:block>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Page numbering                                                       -->
  <!-- ==================================================================== -->

  <!-- Start ToC numbering from 'i'. From pagesetup.xsl. -->
  <xsl:template name="initial.page.number">
    <xsl:param name="element" select="local-name(.)"/>
    <xsl:param name="master-reference" select="''"/>
    
    <xsl:variable name="first.book.content"
      select="ancestor::book/*[
              not(self::title or
              self::subtitle or
              self::titleabbrev or
              self::bookinfo or
              self::info or
              self::dedication or
              self::preface or
              self::toc or
              self::lot)][1]"/>

    <xsl:choose>
      <!-- double-sided output -->
      <xsl:when test="$double.sided != 0">
        <xsl:choose>
          <!-- Vaadin: start ToC with page number 'i' -->
          <xsl:when test="$element = 'toc'">1</xsl:when>
          <xsl:when test="$element = 'book'">1</xsl:when>
          <xsl:when test="$element = 'preface'">auto-odd</xsl:when>
          <xsl:when test="($element = 'dedication' or $element = 'article')
                          and not(preceding::chapter
                          or preceding::preface
                          or preceding::appendix
                          or preceding::article
                          or preceding::dedication
                          or parent::part
                          or parent::reference)">1</xsl:when>
          <xsl:when test="generate-id($first.book.content) =
                          generate-id(.)">1</xsl:when>
          <xsl:otherwise>auto-odd</xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- The pocket book never has single-sided output. -->
    </xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Font sizes.                                                          -->
  <!-- ==================================================================== -->

  <xsl:param name="body.font.family">
    <xsl:choose>
      <xsl:when test="$manual.fonts.custom">Helvetica</xsl:when>
      <xsl:otherwise>Times</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:param name="body.font.master">
    <xsl:choose>
      <!-- Helvetica Light has to be smaller size. -->
      <xsl:when test="$manual.fonts.custom">8</xsl:when>

      <!-- 9 points is ok for Times Roman. -->
      <xsl:otherwise>9</xsl:otherwise>
    </xsl:choose>
  </xsl:param>


  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.4"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.2"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.0"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:attribute-set>

  <!-- Figure and other titles. -->
  <xsl:attribute-set name="formal.title.properties" 
    use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.0"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
  </xsl:attribute-set>

  <!-- ==================================================================== -->
  <!-- Custom chapter title.                                                -->
  <!-- ==================================================================== -->

  <xsl:template match="title" mode="chapter.titlepage.recto.auto.mode">  
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" 
      xsl:use-attribute-sets="chapter.titlepage.recto.style" 
      margin-left="{$title.margin.left}" 
      font-size="16.0pt" 
      font-weight="bold" 
      font-family="{$title.font.family}">
      <xsl:call-template name="vaadinchapter.title">
        <xsl:with-param name="node" select="ancestor-or-self::chapter[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <!-- Use the same style for the appendices. -->
  <xsl:template match="title" mode="appendix.titlepage.recto.auto.mode">  
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" 
      xsl:use-attribute-sets="chapter.titlepage.recto.style" 
      margin-left="{$title.margin.left}" 
      font-size="16.0pt" 
      font-weight="bold" 
      font-family="{$title.font.family}">
      <xsl:call-template name="vaadinchapter.title">
        <xsl:with-param name="node" select="ancestor-or-self::appendix[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template name="vaadinchapter.title">
    <xsl:param name="node" select="."/>
    <xsl:variable name="id">
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$node"/>
      </xsl:call-template>
    </xsl:variable>
    
    <fo:block id="{$id}"
      xsl:use-attribute-sets="chap.label.properties">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">
          <xsl:choose>
            <xsl:when test="$node/self::chapter">chapter</xsl:when>
            <xsl:when test="$node/self::appendix">appendix</xsl:when>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$node" mode="label.markup"/>
    </fo:block>
    <fo:block xsl:use-attribute-sets="chap.title.properties">
      <xsl:apply-templates select="$node" mode="title.markup"/>
    </fo:block>
  </xsl:template>

  <!-- The formatting properties for the chapter label. -->
  <xsl:attribute-set name="chap.label.properties">
    <xsl:attribute name="font-size">18pt</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="space-before.minimum">2cm</xsl:attribute>
    <xsl:attribute name="space-before.optimum">3cm</xsl:attribute>
    <xsl:attribute name="space-before.maximum">4cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- The formatting properties for the chapter title. -->
  <xsl:attribute-set name="chap.title.properties">
    <xsl:attribute name="font-size">24pt</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="space-before.minimum">1cm</xsl:attribute>
    <xsl:attribute name="space-before.optimum">2cm</xsl:attribute>
    <xsl:attribute name="space-before.maximum">3cm</xsl:attribute>
    <xsl:attribute name="space-after.minimum">1cm</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1.5cm</xsl:attribute>
    <xsl:attribute name="space-after.maximum">2cm</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- ==================================================================== -->
  <!-- Custom headers.                                                      -->
  <!-- ==================================================================== -->

  <!-- Custom header data element. Not processed - skip. -->
  <xsl:template match="headerdata">
  </xsl:template>

  <!-- Custom header logo element. -->
  <xsl:template match="headerlogo">
    <xsl:apply-templates select="imagedata"/>
  </xsl:template>

  <!-- No header. -->
  <xsl:template name="header.content">
  </xsl:template>

  <!-- Set header to zero size. -->
  <xsl:param name="body.margin.top" select="'0'"/>

  <!-- Disable separator. -->
  <xsl:template name="head.sep.rule">
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Custom footers.                                                      -->
  <!-- ==================================================================== -->

  <!-- Footer spacing -->
  <xsl:param name="body.margin.bottom" select="'1.1cm'"/>
  <xsl:param name="region.after.extent" select="'0.5cm'"/>

  <!-- Separator. -->
  <xsl:template name="foot.sep.rule">
    <xsl:if test="$footer.rule != 0">
      <xsl:attribute name="border-top-width">0.5pt</xsl:attribute>
      <xsl:attribute name="border-top-style">solid</xsl:attribute>
      <xsl:attribute name="border-top-color">black</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- Footer cell sizes. -->
  <xsl:param name="footer.column.widths">1 10 1</xsl:param>

  <!-- Footer content. -->
  <xsl:template name="footer.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>
    
    <fo:block>
      <!-- pageclass can be front, body, back -->
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>
        <xsl:when test="$pageclass = 'titlepage'">
          <!-- nop; no footer on title pages -->
        </xsl:when>

        <xsl:when test="$double.sided != 0 and $sequence = 'even' and $position='left'">
          <fo:page-number/>
        </xsl:when>

        <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first') and $position='left'">
        </xsl:when>

        <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first') and $position='right'">
          <fo:page-number/>
        </xsl:when>

        <xsl:when test="$double.sided != 0 and ($sequence = 'even') and $position='right'">
        </xsl:when>

        <!-- Footer text in chapter title page. -->
        <xsl:when test="$double.sided != 0 and ($sequence = 'first') and $position='center'">
          <xsl:text>Book of Vaadin</xsl:text>
        </xsl:when>

        <!-- Section title in right-hand-side page footer. -->
        <xsl:when test="$double.sided != 0 and ($sequence = 'odd') and $position='center'">
          <fo:retrieve-marker retrieve-class-name="section.head.marker"
            retrieve-position="first-including-carryover"
            retrieve-boundary="page-sequence"/>
        </xsl:when>

        <!-- Chapter title in right-hand-side page footer. -->
        <xsl:when test="$double.sided != 0 and ($sequence = 'even') and $position='center'">
          <xsl:apply-templates select="." mode="object.title.markup"/>
        </xsl:when>

        <xsl:when test="$double.sided = 0 and $position='center'">
          <xsl:text>Vaadin Reference Manual</xsl:text>
        </xsl:when>
        
        <xsl:when test="$sequence='blank'">
          <xsl:choose>
            <xsl:when test="$double.sided != 0 and $position = 'left'">
              <fo:page-number/>
            </xsl:when>
            <xsl:when test="$double.sided = 0 and $position = 'center'">
              <fo:page-number/>
            </xsl:when>
            <xsl:otherwise>
              <!-- nop -->
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        

        <xsl:otherwise>
          <!-- nop -->
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Title page                                                           -->
  <!-- ==================================================================== -->

  <xsl:include href="custom-fo-titlepage-pocket.xsl"/>

  <xsl:template match="pubdate" mode="book.titlepage.recto.mode">
    <fo:block>
      <xsl:text>2010</xsl:text>
    </fo:block>
  </xsl:template>

  <xsl:template match="corpauthor" mode="book.titlepage.recto.mode">
    <fo:block>
      <xsl:value-of select="orgname"/>
    </fo:block>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Edition notice (verso title page)                                    -->
  <!-- ==================================================================== -->

  <!-- The default font size is too big. -->
  <xsl:attribute-set name="book.titlepage.verso.style">
    <xsl:attribute name="font-size">9pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Nicer formatting for publisher.                         -->
  <!-- The address is normally intended and with large margins. -->
  <xsl:template match="publisher" mode="book.titlepage.verso.mode">
    <fo:block>
      <xsl:text>Published by </xsl:text>
    </fo:block>
    <fo:block margin-left="2em">
      <xsl:apply-templates select="publishername" mode="book.titlepage.verso.mode"/>
    </fo:block>
    <fo:block margin-left="2em">
      <xsl:value-of select="address/street"/>
    </fo:block>
    <fo:block margin-left="2em">
      <xsl:value-of select="address/postcode"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="address/city"/>
    </fo:block>
    <fo:block margin-left="2em">
      <xsl:value-of select="address/country"/>
    </fo:block>
  </xsl:template>

  <!-- Get the publication date from the command-line arguments. -->
  <xsl:param name="manual.pubdate">xxxx-xx-xx</xsl:param>
  <xsl:template match="pubdate" mode="titlepage.mode">
    <fo:block>
      <xsl:text>Published: </xsl:text> 
      <xsl:value-of select="$manual.pubdate"/>
    </fo:block>
  </xsl:template>

  <!-- Get the version number from the command-line arguments. -->
  <xsl:param name="manual.version">x.x.x</xsl:param>
  <xsl:template match="releasenumber">
    <xsl:value-of select="$manual.version"/>
  </xsl:template>

  <!-- Website notice (custom element). -->
  <xsl:template match="websitenotice" mode="book.titlepage.verso.mode">
    <fo:block>
      <xsl:value-of select="title"/>
    </fo:block>
    <fo:block>
      <xsl:value-of select="uri"/>
    </fo:block>
  </xsl:template>

  <!-- The print location (custom element). -->
  <xsl:template match="printer" mode="book.titlepage.verso.mode">
    <fo:block>
      <xsl:text>Printed in </xsl:text>

      <!-- No printer name. -->
      <!-- <xsl:value-of select="orgname"  < xsl:text>, </xsl:text> -->

      <xsl:value-of select="address/city"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="address/country"/>
      <xsl:text>.</xsl:text>
    </fo:block>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Variable lists.                                                      -->
  <!-- ==================================================================== -->

  <!-- Even less indentation for variable lists. -->
  <xsl:attribute-set name="varlist.block.spacing">
    <xsl:attribute name="margin-left">0.2cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- Use block mode representation. -->
  <xsl:param name="variablelist.as.blocks" select="'1'"/>

  <!-- Modified to use varlist-specific spacing. From from 'lists.xsl'. -->
  <xsl:template match="variablelist" mode="vl.as.blocks">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:if test="title">
      <xsl:apply-templates select="title" mode="list.title.mode"/>
    </xsl:if>
    
    <xsl:apply-templates
      select="*[not(self::varlistentry
              or self::title
              or self::titleabbrev)]
            |comment()[not(preceding-sibling::varlistentry)]
            |processing-instruction()[not(preceding-sibling::varlistentry)]"/>

    <xsl:variable name="content">
      <xsl:apply-templates mode="vl.as.blocks"
        select="varlistentry
                |comment()[preceding-sibling::varlistentry]
                |processing-instruction()[preceding-sibling::varlistentry]"/>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="ancestor::listitem">
        <fo:block id="{$id}">
          <xsl:copy-of select="$content"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block id="{$id}" xsl:use-attribute-sets="varlist.block.spacing">
          <xsl:copy-of select="$content"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Scale images smaller.                                                -->
  <!-- ==================================================================== -->

  <!-- Copied from graphics.xsl. -->
  <xsl:template name="process.image">
  <!-- When this template is called, the current node should be  -->
  <!-- a graphic, inlinegraphic, imagedata, or videodata. All    -->
  <!-- those elements have the same set of attributes, so we can -->
  <!-- handle them all in one place.                             -->

  <xsl:variable name="scalefit">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
      <xsl:when test="@contentwidth">0</xsl:when>
      <xsl:when test="@contentdepth and
                      @contentdepth != '100%'">0</xsl:when>

      <!-- This overrides scale attribute. -->
      <xsl:when test="@smallscale and contains(@smallscale,'%')">1</xsl:when>

      <xsl:when test="@scale">0</xsl:when>
      <xsl:when test="@scalefit"><xsl:value-of select="@scalefit"/></xsl:when>
      <xsl:when test="@width or @depth">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="scale">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
      <xsl:when test="@contentwidth or @contentdepth">1.0</xsl:when>

      <!-- Vaadin custom attribute. -->
      <xsl:when test="@smallscale and contains(@smallscale, '%')">1.0</xsl:when>
      <xsl:when test="@smallscale and not(contains(@smallscale, '%'))">
        <xsl:value-of select="(@smallscale div 100.0)*0.6"/>
      </xsl:when>

      <xsl:when test="@scale">
        <!-- Modified for Vaadin. -->
        <xsl:value-of select="(@scale div 100.0)*0.6"/>
      </xsl:when>
      <xsl:otherwise>0.55</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="local-name(.) = 'graphic'
                      or local-name(.) = 'inlinegraphic'">
        <!-- handle legacy graphic and inlinegraphic by new template -->
        <xsl:call-template name="mediaobject.filename">
          <xsl:with-param name="object" select="."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- imagedata, videodata, audiodata -->
        <xsl:call-template name="mediaobject.filename">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="content-type">
    <xsl:if test="@format">
      <xsl:call-template name="graphic.format.content-type">
        <xsl:with-param name="format" select="@format"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="bgcolor">
    <xsl:call-template name="dbfo-attribute">
      <xsl:with-param name="pis"
                      select="../processing-instruction('dbfo')"/>
      <xsl:with-param name="attribute" select="'background-color'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:external-graphic>
    <xsl:attribute name="src">
      <xsl:call-template name="fo-external-image">
        <xsl:with-param name="filename">
          <xsl:if test="$img.src.path != '' and
                        not(starts-with($filename, '/')) and
                        not(contains($filename, '://'))">
            <xsl:value-of select="$img.src.path"/>
          </xsl:if>
          <xsl:value-of select="$filename"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="width">
      <xsl:choose>
        <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
        <xsl:when test="contains(@width,'%')">
          <xsl:value-of select="@width"/>
        </xsl:when>
        <xsl:when test="@smallscale and contains(@smallscale, '%')">
          <xsl:value-of select="@smallscale"/>
        </xsl:when>
        <xsl:when test="@width and not(@width = '')">
          <xsl:call-template name="length-spec">
            <xsl:with-param name="length" select="@width"/>
            <xsl:with-param name="default.units" select="'px'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="not(@depth) and $default.image.width != ''">
          <xsl:call-template name="length-spec">
            <xsl:with-param name="length" select="$default.image.width"/>
            <xsl:with-param name="default.units" select="'px'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="height">
      <xsl:choose>
        <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
        <xsl:when test="contains(@depth,'%')">
          <xsl:value-of select="@depth"/>
        </xsl:when>
        <xsl:when test="@depth">
          <xsl:call-template name="length-spec">
            <xsl:with-param name="length" select="@depth"/>
            <xsl:with-param name="default.units" select="'px'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="content-width">
      <xsl:choose>
        <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
        <xsl:when test="contains(@contentwidth,'%')">
          <xsl:value-of select="@contentwidth"/>
        </xsl:when>
        <xsl:when test="@contentwidth">
          <xsl:call-template name="length-spec">
            <xsl:with-param name="length" select="@contentwidth"/>
            <xsl:with-param name="default.units" select="'px'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="number($scale) != 1.0">
          <xsl:value-of select="$scale * 100"/>
          <xsl:text>%</xsl:text>
        </xsl:when>
        <xsl:when test="$scalefit = 1">scale-to-fit</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="content-height">
      <xsl:choose>
        <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
        <xsl:when test="@contentdepth and contains(@contentdepth,'%')">
          <xsl:value-of select="@contentdepth"/>
        </xsl:when>
        <xsl:when test="@contentdepth">
          <xsl:call-template name="length-spec">
            <xsl:with-param name="length" select="@contentdepth"/>
            <xsl:with-param name="default.units" select="'px'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@smallscale and contains(@smallscale, '%')">
          <xsl:value-of select="@smallscale"/>
        </xsl:when>
        <xsl:when test="number($scale) != 1.0">
          <xsl:value-of select="$scale * 100"/>
          <xsl:text>%</xsl:text>
        </xsl:when>
        <xsl:when test="$scalefit = 1">scale-to-fit</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:if test="$content-type != ''">
      <xsl:attribute name="content-type">
        <xsl:value-of select="concat('content-type:',$content-type)"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="$bgcolor != ''">
      <xsl:attribute name="background-color">
        <xsl:value-of select="$bgcolor"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="@align">
      <xsl:attribute name="text-align">
        <xsl:value-of select="@align"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="@valign">
      <xsl:attribute name="display-align">
        <xsl:choose>
          <xsl:when test="@valign = 'top'">before</xsl:when>
          <xsl:when test="@valign = 'middle'">center</xsl:when>
          <xsl:when test="@valign = 'bottom'">after</xsl:when>
          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </fo:external-graphic>
</xsl:template>


</xsl:stylesheet>
