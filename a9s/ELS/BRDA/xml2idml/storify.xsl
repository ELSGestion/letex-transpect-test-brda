<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/"
  xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/"
  xmlns:idPkg = "http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
  xmlns:xml2idml="http://transpect.io/xml2idml"
  xmlns:idml2xml  = "http://transpect.io/idml2xml"
  xmlns:tr="http://transpect.io"
  xmlns:css="http://www.w3.org/1996/css"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:c="http://www.w3.org/ns/xproc-step" 
  exclude-result-prefixes="css tr xs xml2idml idml2xml c"
  >
  
  <xsl:import href="http://transpect.io/xml2idml/xsl/storify.xsl"/>
  
  <xsl:variable name="xml2idml:icon-element-role-regex" as="xs:string"
    select="'^(No|essentiel)$|RenvMem_'"/>
  
  <xsl:function name="xml2idml:icon-reference-name" as="xs:string">
    <xsl:param name="el" as="element(*)"/>
    <xsl:sequence select="$el/@class"/>
  </xsl:function>
  
  <xsl:template match="Content[matches(ancestor::ParagraphStyleRange[1]/@AppliedParagraphStyle, 'STD%3a(No|RenvMem)$')]" mode="xml2idml:reproduce-icons">
    <xsl:param name="icon-element" tunnel="yes"/>
    <xsl:value-of select="$icon-element"/>
  </xsl:template>
  
  <xsl:template match="ParagraphStyleRange/@AppliedParagraphStyle[matches(., '^ParagraphStyle/STD%3aNo$')]" mode="xml2idml:storify_content-n-cleanup">
    <xsl:variable name="colour" as="xs:string?" select="tokenize(preceding::*:Spread[1]/@MasterPageName, '_')[last()]"/>
    <xsl:choose>
      <xsl:when test="exists($colour)">
        <xsl:attribute name="AppliedParagraphStyle" select="concat('ParagraphStyle/STD%3aNo_Couleur%3aNo_', $colour)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>[ERROR][<xsl:value-of select="tokenize(static-base-uri(),'/')[last()]"/>] $colour vide !!!</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:function name="xml2idml:create-image-container" as="element()?">
    <xsl:param name="mapped-image" as="element()"/>
    <xsl:variable name="created-image" as="element()?">
      <xsl:choose>
        <xsl:when test="not($mapped-image/c:results/c:result)">
          <xsl:sequence select="xml2idml:output-warning-image-path-not-available($mapped-image)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="new-image" as="element(xml2idml:image)"
            select="xml2idml:get-image-info($mapped-image)"/>
          <xsl:variable name="width-in-pt" as="xs:double"
            select="xs:double($new-image/@width) * 2.8346"/>
          <xsl:variable name="height-in-pt" as="xs:double"
            select="xs:double($new-image/@height) * 2.8346"/>
          <Rectangle Self="image_{generate-id($mapped-image)}"
            AppliedObjectStyle="ObjectStyle/$ID/[None]"
            ItemTransform="1 0 0 1 0 0">
            <Properties>
              <PathGeometry>
                <GeometryPathType PathOpen="false">
                 <PathPointArray>
                    <PathPointType Anchor="-{$width-in-pt div 2} -{$height-in-pt div 2}"
                      LeftDirection="-{$width-in-pt div 2} -{$height-in-pt div 2}"
                      RightDirection="-{$width-in-pt div 2} -{$height-in-pt div 2}"/>
                    <PathPointType Anchor="-{$width-in-pt div 2} {$height-in-pt div 2}"
                      LeftDirection="-{$width-in-pt div 2} {$height-in-pt div 2}"
                      RightDirection="-{$width-in-pt div 2} {$height-in-pt div 2}"/>
                    <PathPointType Anchor="{$width-in-pt div 2} {$height-in-pt div 2}"
                      LeftDirection="{$width-in-pt div 2} {$height-in-pt div 2}"
                      RightDirection="{$width-in-pt div 2} {$height-in-pt div 2}"/>
                    <PathPointType Anchor="{$width-in-pt div 2} -{$height-in-pt div 2}"
                      LeftDirection="{$width-in-pt div 2} -{$height-in-pt div 2}"
                      RightDirection="{$width-in-pt div 2} -{$height-in-pt div 2}"/>
                  </PathPointArray>
                </GeometryPathType>
              </PathGeometry>
            </Properties>
            <xsl:choose>
              <xsl:when test="matches($new-image/@mime-type, 'image/x-eps|application/postscript')">
                <EPS Self="image_eps_{generate-id($mapped-image)}"
                  ItemTransform="1 0 0 1 -{$width-in-pt div 2} -{$height-in-pt div 2}">
                  <Properties>
                    <GraphicBounds Left="0" Top="0" Right="{$width-in-pt}" Bottom="{$height-in-pt}"/>
                  </Properties>
                  <Link Self="image_eps_link_{generate-id($mapped-image)}"
                    LinkResourceURI="{if(not(starts-with($mapped-image/@xml2idml:image-path, 'file:'))) 
                    then concat('file:/', $mapped-image/@xml2idml:image-path) 
                    else $mapped-image/@xml2idml:image-path}"
                    LinkResourceFormat="$ID/EPS"/>
                </EPS>
              </xsl:when>
              <xsl:when test="$new-image/@mime-type eq 'image/tiff'">
                <Image Self="image_eps_{generate-id($mapped-image)}"
                  ImageTypeName="$ID/TIFF"
                  ItemTransform="1 0 0 1 -{$width-in-pt div 2} -{$height-in-pt div 2}">
                  <Properties>
                    <GraphicBounds Left="0" Top="0" Right="{$width-in-pt}" Bottom="{$height-in-pt}"/>
                  </Properties>
                  <Link Self="image_tiff_link_{generate-id($mapped-image)}"
                    LinkResourceURI="{if(not(starts-with($mapped-image/@xml2idml:image-path, 'file:'))) 
                    then concat('file:/', $mapped-image/@xml2idml:image-path) 
                    else $mapped-image/@xml2idml:image-path}"
                    LinkResourceFormat="$ID/TIFF"/>
                </Image>
              </xsl:when>
            </xsl:choose>            
          </Rectangle>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="$created-image"/>
  </xsl:function>
  
  <xsl:function name="xml2idml:get-image-info" as="element(xml2idml:image)">
    <xsl:param name="mapped-image" as="element()"/>
    <xsl:variable name="mime-type" as="xs:string"
      select="$mapped-image/c:results/c:result[@name eq 'mimetype']/@value"/>    
    <xsl:variable name="new-image" as="element(xml2idml:image)">
      <xml2idml:image>
        <xsl:attribute name="mime-type" select="$mime-type"/>
        <xsl:choose>
          <xsl:when test="matches($mime-type, 'image/(x-eps|tiff)|application/postscript')">
            <xsl:attribute name="width" select="xs:double(substring-before($mapped-image/c:results/c:result[@name eq 'width']/@value, 'px'))* 25.4 div xs:double(substring-before($mapped-image/c:results/c:result[@name eq 'density']/@value, 'dpi'))"/>
            <xsl:attribute name="height" select="xs:double(substring-before($mapped-image/c:results/c:result[@name eq 'height']/@value, 'px'))* 25.4 div xs:double(substring-before($mapped-image/c:results/c:result[@name eq 'density']/@value, 'dpi'))"/>            
          </xsl:when>
          <xsl:otherwise>
            <xsl:message select="'xml2idml, function xml2idml:get-image-info: mime-type of ', $mapped-image/@xml2idml:image-path, 'unknown!'"/>
            <xsl:attribute name="width" select="($mapped-image/@css:width, '0')[1]"/>
            <xsl:attribute name="height" select="($mapped-image/@css:height, '0')[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xml2idml:image>
    </xsl:variable>
    <xsl:sequence select="$new-image"/>
  </xsl:function>
  
  
</xsl:stylesheet>
