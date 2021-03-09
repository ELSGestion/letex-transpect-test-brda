<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:cx="http://xmlcalabash.com/ns/extensions" 
    xmlns:tr="http://transpect.io"
    version="1.0"
    name="omnibook2idml"
    type="tr:omnibook2idml">

    <p:option name="debug" required="false" select="'yes'"/>
    <p:option name="debug-dir-uri" required="false" select="resolve-uri('debug')"/>
    <p:option name="validate-idml" required="false" select="'no'"/>
    <p:option name="idml-target-uri" required="false" select="''"/>
    <p:option name="idml-template-expanded-uri" required="false" select="''"/>
    
    <p:input port="source"/>    
    <p:input port="conf" primary="true"/>
    <p:output port="html" primary="true">
        <p:pipe port="result" step="omni2html"/>
    </p:output>
    
    <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
    <p:import href="http://transpect.io/xml2idml/xpl/xml2idml.xpl"/>
    <p:import href="http://transpect.io/xproc-util/store-debug/xpl/store-debug.xpl"/>
    <p:import href="http://transpect.io/cascade/xpl/paths.xpl"/>
    <p:import href="http://transpect.io/cascade/xpl/dynamic-transformation-pipeline.xpl" />
    <p:import href="http://transpect.io/calabash-extensions/image-props-extension/image-identify-declaration.xpl" />
    <p:import href="http://transpect.io/cascade/xpl/load-cascaded.xpl"/>
    <!--<p:import href="http://transpect.io/idmlvalidation/xpl/idmlval.xpl" />-->
    
    <p:load name="import-paths-xsl">
        <p:with-option name="href" select="(/*/@paths-xsl-uri, 'http://transpect.io/cascade/xsl/paths.xsl')[1]"/>
    </p:load>
    
    <tr:paths name="paths">
        <p:with-option name="pipeline" select="'omnibook2idml.xpl'"/>
        <p:with-option name="file" select="base-uri()">
            <p:pipe port="source" step="omnibook2idml"/>
        </p:with-option>
        <p:with-option name="debug" select="$debug"/>  
        <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/>  
        <p:input port="conf">
            <p:pipe port="conf" step="omnibook2idml"/>
        </p:input>
        <p:input port="params">
            <p:empty/>
        </p:input>
    </tr:paths>  
    
    <p:sink/>  
    
  <tr:load-cascaded name="load-xml2html-xsl" filename="xml2html/xml2html.xsl"
        fallback="http://transpect.io/idml2xml/xsl/idml2xml.xsl">
        <p:with-option name="debug" select="$debug" />
        <p:with-option name="debug-dir-uri" select="$debug-dir-uri" />
        <p:input port="paths">
            <p:pipe port="result" step="paths"/>
        </p:input>
    </tr:load-cascaded>
    
    <p:sink/>
    
    <p:xslt name="omni2html">
        <p:input port="parameters">
            <p:pipe port="result" step="paths"/>
        </p:input>
        <p:input port="stylesheet">
            <p:pipe port="result" step="load-xml2html-xsl"/>
        </p:input>
        <p:input port="source">
            <p:pipe port="source" step="omnibook2idml"/>
        </p:input>
    </p:xslt>
    
    <tr:store-debug pipeline-step="omnibook2html/omnibook2html">
        <p:with-option name="active" select="$debug"/>
        <p:with-option name="base-uri" select="$debug-dir-uri"/>
    </tr:store-debug>
    
    <p:viewport match="*:img" name="image-id">
        <tr:image-identify name="image-identify" cx:depends-on="omni2html">  
            <p:with-option name="href" select="/*/@src"/>
        </tr:image-identify>
        <p:insert position="last-child">
            <p:input port="insertion">
                <p:pipe port="report" step="image-identify"/>
            </p:input>      
        </p:insert>
        <tr:store-debug pipeline-step="image-id">
            <p:with-option name="active" select="$debug"/>
            <p:with-option name="base-uri" select="$debug-dir-uri"/>
        </tr:store-debug>
    </p:viewport>
    
    <tr:xml2idml name="xml2idml">
      <p:input port="paths">
        <p:pipe port="result" step="paths"/>
      </p:input>
      <p:with-option name="mapping" select="'xml2idml/mapping.xml'" />
      <p:with-option name="template" select="'xml2idml/template.idml'"/>
      <p:with-option name="idml-target-uri" select="$idml-target-uri"/>
      <p:with-option name="idmltemplate-expanded-dir-uri" select="$idml-template-expanded-uri"/>
      <p:with-option name="debug" select="$debug"/>
      <p:with-option name="debug-dir-uri" select="$debug-dir-uri" />
    </tr:xml2idml>
  
    <!--<p:for-each name="split" cx:depends-on="image-id">
        <p:iteration-source select="/*:html/*:body/*:article">
            <p:pipe port="result" step="image-id"/>
        </p:iteration-source>
        <p:variable name="filename" select="concat('article_', format-number(p:iteration-position(), '000'))">
            <p:pipe port="current" step="split"/>
        </p:variable>    
        <tr:store-debug name="store">
            <p:with-option name="pipeline-step" select="concat('split/', $filename)"/>
            <p:with-option name="active" select="$debug"/>
            <p:with-option name="base-uri" select="$debug-dir-uri"/>
        </tr:store-debug>
        <tr:xml2idml name="xml2idml">
            <p:input port="paths">
                <p:pipe port="result" step="paths"/>
            </p:input>
            <p:with-option name="mapping" select="'xml2idml/mapping.xml'" />
            <p:with-option name="template" select="'xml2idml/template.idml'"/>
            <p:with-option name="idml-target-uri" select="replace($idml-target-uri, '\w+\.idml', concat($filename, '.idml'))"/>
            <p:with-option name="idmltemplate-expanded-dir-uri" select="$idml-template-expanded-uri"/>
            <p:with-option name="debug" select="$debug"/>
            <p:with-option name="debug-dir-uri" select="concat($debug-dir-uri, '/', $filename)" />
        </tr:xml2idml>
    </p:for-each>-->
    
    <p:sink/>
    
    <!--<p:choose name="idmlval" cx:depends-on="xml2idml">
        <p:when test="$validate-idml eq 'yes'">
            <p:output port="result" primary="true">
                <p:pipe step="validate-idml" port="result"/>
            </p:output>
            
            <tr:idml-validation name="validate-idml" cx:depends-on="xml2idml">
                <p:with-option name="idmlfile" select="replace($idml-target-uri, '^file:(.+)$', '$1')"/>
                <p:with-option name="validate-regex" select="'designmap|Stories'" />
            </tr:idml-validation>
        </p:when>
        <p:otherwise>
            <p:output port="result" primary="true">
                <p:pipe step="bogo" port="result"/>
            </p:output>
            <p:identity name="bogo">
                <p:input port="source">
                    <p:inline>
                        <c:results>Option validate-idml: no</c:results>
                    </p:inline>
                </p:input>
            </p:identity>
        </p:otherwise>
    </p:choose>-->

</p:declare-step>