<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:bc="http://transpect.le-tex.de/book-conversion"
  xmlns:tr="http://transpect.io"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  version="2.0">
  
  <xsl:import href="http://transpect.io/cascade/xsl/paths.xsl"/>  
  
  <xsl:function name="tr:parse-file-name" as="attribute(*)*">
    <xsl:param name="filename" as="xs:string?"/>
    <xsl:variable name="basename" select="tr:basename($filename)"/>
    <xsl:attribute name="publisher" select="'ELS'"/>
    <xsl:attribute name="production-line">
      <xsl:choose>
        <xsl:when test="contains($filename, 'BRDA')">
          <xsl:text>BRDA</xsl:text>
        </xsl:when>
        <xsl:when test="contains($filename, 'BULLETIN')">
          <xsl:text>BULLETIN</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="ext" select="tr:ext($filename)"/>
    <xsl:attribute name="work" select="replace($basename, '\D', '')"/>          
    <xsl:attribute name="basename" select="$basename"/>
    <xsl:attribute name="base" select="tr:basename($filename)"/>
 </xsl:function>
  
  
  
  
</xsl:stylesheet>