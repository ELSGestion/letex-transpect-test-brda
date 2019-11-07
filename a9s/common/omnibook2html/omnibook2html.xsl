<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xml2idml="http://transpect.io/xml2idml"
    xmlns:tr="http://transpect.io"
    xmlns:css="http://www.w3.org/1996/css"
    xmlns:cx="http://xmlcalabash.com/ns/extensions"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns="http://www.w3.org/1999/xhtml" 
    exclude-result-prefixes="xs xml2idml tr saxon cx css cx"
    version="2.0">
    
    <xsl:param name="s9y1-path"/>
    <xsl:param name="s9y2-path"/>
    
    <xsl:template match="/omnibook">
        <html>
            <head>
                <title>TEST</title>
                <xsl:apply-templates select="metadata/info"/>
            </head>
            <body>
                <xsl:apply-templates select="article"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="metadata/info">
        <meta name="{@name}" content="{.}"/>
    </xsl:template>
    
    <xsl:template match="article">
        <article>
            <xsl:apply-templates select="@*, node()"/>
        </article>
    </xsl:template>
    
    <xsl:template match="textbox">
        <div>
            <xsl:apply-templates select="@*, node()"/>
        </div>
    </xsl:template>
    
    <xsl:template match="table | p | sup | sub" priority="-0.2">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*, node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="table-wrap">
        <div class="{local-name()}">
            <xsl:apply-templates select="node()"/> 
        </div>
    </xsl:template>
    
    <xsl:template match="figure[link]">
        <img src="{concat($s9y1-path, 'images/', replace(link/@locator, 'Links/', ''))}"/>
    </xsl:template>
    
    <xsl:template match="tgroup">
        <xsl:apply-templates select="node()"/>
    </xsl:template>
    
    <xsl:template match="colspec"/>
    
    <xsl:template match="tbody | thead">
        <xsl:apply-templates select="node()"/> 
    </xsl:template>
    
    <xsl:template match="row">
        <tr>
            <xsl:apply-templates select="node()"/> 
        </tr>
    </xsl:template>
    
    <xsl:template match="entry">
        <xsl:element name="{if (parent::thead) then 'th' else 'td'}">
            <xsl:apply-templates select="@* except @colname, node()"/> 
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="p[matches(@type, 'SOM_Dossier_Titre')][cross-ref-ext]">
        <p>
            <xsl:apply-templates select="@*"/>
          <a href="{cross-ref-ext[1]/@ref-id}">  
              <xsl:apply-templates select="node()">
                  <xsl:with-param name="render" select="true()" tunnel="yes"/>
              </xsl:apply-templates> 
          </a>
        </p>
    </xsl:template>
    
    <xsl:template match="p[@id or style[@id]]">
        <p>
            <xsl:apply-templates select="@type"/>
            <a id="{(@id, style[1]/@id)[1]}"/>  
            <xsl:apply-templates select="node()"/> 
        </p>
    </xsl:template>
    
    <xsl:template match="p[matches(@type, 'essentiel_Titre')]">
        <p>
            <xsl:apply-templates select="@type"/>
            <span class="essentiel"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="node()"/> 
        </p>
    </xsl:template>
    
    <xsl:template match="article/p[matches(@type, 'Dossier_Titre')]">
        <div class="Theme">
            <p>
               <xsl:apply-templates select="@*, node()"/> 
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="style[matches(@type, 'FigA')]">
        <span>
            <xsl:attribute name="class" select="concat('Anoter_', replace(ancestor::article[1]/@type, '^.+_(.+)$', '$1'))"/>
            <xsl:text>A noter</xsl:text>
        </span>
        <xsl:text> </xsl:text>        
    </xsl:template>
    
    <xsl:template match="style[matches(@type, '^no$')]">
        <span>
            <xsl:attribute name="class" select="'No'"/>
            <xsl:apply-templates select="node()"/>
        </span>      
    </xsl:template>
    
    <xsl:template match="style[matches(@type, 'RenvMem')]">
        <span>
            <xsl:attribute name="class" select="concat('RenvMem_', replace(ancestor::article[1]/@type, '^.+_(.+)$', '$1'))"/>
            <xsl:apply-templates select="node()"/>
        </span>      
    </xsl:template>
    
    <xsl:template match="style[matches(@type, 'Num|Carre_Obs')]">
        <span>
            <xsl:attribute name="class" select="concat(@type, '_', replace(ancestor::article[1]/@type, '^.+_(.+)$', '$1'))"/>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="style" priority="-0.2">
        <xsl:if test="not(@id)">
            <span>
                <xsl:apply-templates select="@*, node()"/>
            </span>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="cross-ref | cross-ref-ext">
        <xsl:param name="render" select="false()" tunnel="yes"/>
        <xsl:if test="$render">
            <xsl:apply-templates select="node()"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="@type">
        <xsl:attribute name="class" select="."/>
    </xsl:template>
    
    
    <!-- identity -->
    <xsl:template match="@* | *" priority="-0.5">
        <xsl:copy>
            <xsl:apply-templates select="@*, node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>