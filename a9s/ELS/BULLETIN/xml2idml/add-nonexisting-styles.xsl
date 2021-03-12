<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/"
  xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/"
  xmlns:idPkg = "http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
  xmlns:htmltable="http://transpect.io/htmltable"
  xmlns:xml2idml="http://transpect.io/xml2idml"
  xmlns:idml2xml  = "http://transpect.io/idml2xml"
  xmlns:tr="http://transpect.io"
  xmlns:css="http://www.w3.org/1996/css"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="css tr xs xml2idml idml2xml saxon htmltable"
  >
  
  <xsl:import href="http://transpect.io/xml2idml/xsl/add-nonexisting-styles.xsl"/>
  
  <xsl:key name="textframe-by-story" match="TextFrame[not(ancestor::MasterSpread)]" use="@ParentStory"/>
  
  <xsl:template match="Column[parent::Table[@data-print-display-col ne '1']]" mode="#default">
    <xsl:variable name="colnum" select="parent::Table/@ColumnCount" as="xs:integer"/>
    <xsl:variable name="display-colnum" select="parent::Table/@data-print-display-col" as="xs:integer"/>
    <xsl:variable name="textframe-colwidth" as="xs:double" select="key('textframe-by-story', ancestor-or-self::Story[@Self][1]/@Self)[1]/TextFramePreference/@TextColumnFixedWidth"/>
    <xsl:variable name="textframe-colgutter" as="xs:double" select="key('textframe-by-story', ancestor-or-self::Story[@Self][1]/@Self)[1]/TextFramePreference/@TextColumnGutter"/>
    <xsl:copy>
      <xsl:apply-templates select="@* except @SingleColumnWidth" mode="#current"/>
      <xsl:attribute name="SingleColumnWidth" select="($display-colnum*$textframe-colwidth + ($display-colnum - 1)*$textframe-colgutter) div $colnum"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="Table/@data-print-display-col" mode="#default"/>

</xsl:stylesheet>
