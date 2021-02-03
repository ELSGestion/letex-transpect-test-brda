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
  
    <xsl:template match="*:col" mode="xml2idml:storify_table-declarations">
      <xsl:variable name="width" as="xs:string"
        select="if (not($xml2idml:use-main-story-width-for-tables) and @css:width) 
                then @css:width 
                else 
                  if ($xml2idml:main-story-TextColumnFixedWidth ne '') 
                  then concat(
                    xs:double($xml2idml:main-story-TextColumnFixedWidth) div count(../*:col),
                    'pt'
                  )
                  else '2000'"/><!-- 2000 is a default twips value (100pt) -->
      <Column Self="col_{generate-id()}_{position() - 1}" Name="{position() - 1}"
        SingleColumnWidth="{(tr:length-to-unitless-twip($width), 2000)[1] * 0.05}" />
    </xsl:template>
  
</xsl:stylesheet>
