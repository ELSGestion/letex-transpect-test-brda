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
  
  <xsl:template match="*[@aid:table eq 'table']" mode="xml2idml:storify" priority="1.5">
    <xsl:variable name="base-id" select="concat('tb_', generate-id())" as="xs:string"/>
    <Table Self="{$base-id}">
      <xsl:copy-of select="@data-print-display-col"/>
      <xsl:apply-templates select="  @aid5:tablestyle 
        | (@data-colcount, *:tbody/@data-colcount)[1]
        | @data-rowcount
        | *[local-name() = ('thead', 'tbody', 'tfoot')]/@data-rowcount" mode="#current" />
      <xsl:apply-templates select="." mode="xml2idml:storify_table-declarations" />
      <!-- default template rules (i.e., process content): -->
      <xsl:apply-templates select="node()" mode="#current" />
    </Table>
  </xsl:template>
  
</xsl:stylesheet>
