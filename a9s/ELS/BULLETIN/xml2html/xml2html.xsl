<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xml2idml="http://transpect.io/xml2idml"
  xmlns:tr="http://transpect.io"
  xmlns:css="http://www.w3.org/1996/css"
  xmlns:cx="http://xmlcalabash.com/ns/extensions"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:xf="http://www.lefebvre-sarrut.eu/ns/xmlfirst"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="#all"
  version="2.0"
  >
  
  <!--the most specific path-->
  <xsl:param name="s9y1-path"/>
  <!--the 2nd most specific path-->
  <xsl:param name="s9y2-path"/>
  
  <xsl:template match="/RACINE">
    <html>
      <head>
        <title>Bulletin <xsl:value-of select="@NUMERO"/></title>
        <!--<xsl:apply-templates select="metadata/info"/>-->
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="RACINEZOOM | RACINEACTUCC | RACINEARRETCC">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="ARTICLEZOOM | ARTICLEACTUCC | ARTICLEARRETCC">
    <article class="{name()}">
      <xsl:apply-templates/>
    </article>
  </xsl:template>
  
  <!--========================-->
  <!--ZOOM-->
  <!--========================-->
  
  <xsl:template match="ARTICLEZOOM/THEME">
    <!--TODO-->
  </xsl:template>
  
  <xsl:template match="ARTICLEZOOM/TITRE/div">
    <p class="Ti1zoom">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="ARTICLEZOOM/CHAPEAU/div">
    <p class="ChapoCouv">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  
  <!--========================-->
  <!--ACTU-->
  <!--========================-->
  
  <xsl:template match="ARTICLEACTUCC/THEME/CODE">
    <!--TODO-->
  </xsl:template>
  
  <xsl:template match="ARTICLEACTUCC/THEME/LIBELLE">
    <p class="105-Etude">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="ARTICLEACTUCC/TITRE/div">
    <p class="005-PnumTi">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="ARTICLEACTUCC/INTERTITRE">
    <p class="Region">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="ARTICLEACTUCC/CHAPEAU/div">
    <p class="130-Comment">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <!--========================-->
  <!--ARRETS-->
  <!--========================-->
  
  <!--TODO-->
  
  <!--========================-->
  <!--CONTENT-->
  <!--========================-->
  
  <xsl:template match="article[@class = 'els-content el-actu']">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="article[@class = 'els-content el-actu']//p" priority="-1">
    <p class="007-Al">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <!--========================-->
  <!--Titres-->
  <!--========================-->
  
  <xsl:template match="article[@class = 'els-content el-actu']//h1">
    <p class="009-Pnum2">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="article[@class = 'els-content el-actu']//h2">
    <p class="010-Pnum3">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="article[@class = 'els-content el-actu']//h3">
    <p class="011-Pnum4">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <!--========================-->
  <!--TABLEAUX-->
  <!--========================-->
  
  <xsl:template match="article[@class = 'els-content el-actu']//div[@class = 'els-table']">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="table | thead | tbody | tfoot | tr | td | th">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:element>
  </xsl:template>
  
  <!--========================-->
  <!--ANNOTATION : REM/EXEMPLE/ ...-->
  <!--========================-->
  
  <xsl:template match="article[@class = 'els-content el-actu']//div[contains(@class, 'els-block')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="article[@class = 'els-content el-actu']//div[@class = 'els-block remarque']/p">
    <p class="078-Rem-seul">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="article[@class = 'els-content el-actu']//div[@class = 'els-block NDLR']/p">
    <p class="082-Ndlr-seul">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <!--========================-->
  <!--LISTES-->
  <!--========================-->
  
  <xsl:template match="article[@class = 'els-content el-actu']//ul">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="article[@class = 'els-content el-actu']//ul/li">
    <p class="026-LT">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="article[@class = 'els-content el-actu']//ul/li/p">
    <xsl:apply-templates/>
  </xsl:template>

  <!--========================-->
  <!--INLINE-->
  <!--========================-->
  <!--fixme-->
  
  <xsl:template match="em">
    <i class="Italique">
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  
  <xsl:template match="sup">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>
  
  <xsl:template match="strong">
    <b>
      <xsl:apply-templates/>
    </b>
  </xsl:template>
  
  <xsl:template match="br">
    <br/>
  </xsl:template>
  
  <!--========================-->
  <!--FIN ARTICLE-->
  <!--========================-->
  
  <xsl:template match="REFERENCE">
    <p class="007-PrenvH-Al">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="SIGNATURE[normalize-space(.) = '']"/>

  <xsl:template match="SIGNATURE">
    <p class="Sign">
      <xsl:value-of select="PRENOM || ' ' || NOM"/>
    </p>
  </xsl:template>
  
  <!--========================-->
  <!--COMMON-->
  <!--========================-->
  
  <!--shallow skip-->
  <xsl:template match="THEME | ARTICLEZOOM/TITRE | ARTICLEACTUCC/TITRE | CHAPEAU | RACINEACTU">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*" priority="-2">
    <xsl:message>UNMATCHED <xsl:value-of select="local-name()"/></xsl:message>
    <xsl:next-match/>
  </xsl:template>
  
  <!-- identity -->
  <xsl:template match="node() | @*" priority="-3">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>