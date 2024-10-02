<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
 xmlns:dcx="https://www.daliboris.cz/ns/docx/xslt"
 xmlns:map="http://www.w3.org/2005/xpath-functions/map" 
 exclude-result-prefixes="xs math xd w dcx math map"
 version="3.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> May 11, 2024</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:param name="keep-direct-formatting" as="xs:boolean" select="false()" />
 <xsl:param name="styles" as="document-node(element(w:styles))" />
 <xsl:param name="comments" as="document-node(element(w:comments))" />
 <xsl:param name="footnotes" as="document-node(element(w:footnotes))" />

 <xsl:param name="root-element" select="'body'" />
 <xsl:param name="footnote-element" select="'footnote'" />
 <xsl:param name="comment-element" select="'comment'" />

 <xsl:param name="default-paragraph-style" select="'Normální'" />
 <xsl:param name="default-character-style" select="'text'" />
 
 <xsl:variable name="style-names" select="map {
  'b' : 'bold',
  'i' : 'italic',
  'u' : 'underline'
  }"/>

 <xsl:key name="style" match="w:style" use="@w:styleId" />
 <xsl:key name="comment" match="w:comment" use="@w:id" />
 <xsl:key name="footnote" match="w:footnote" use="@w:id" />
 
 <xsl:strip-space elements="*"/>
 
 <xsl:mode on-no-match="shallow-skip"/>
 <xsl:output method="xml" indent="yes" />
 
 <xsl:template match="/">
    <xsl:apply-templates select="/w:document/w:body" />
 </xsl:template>
 
 <xsl:template match="w:body">
  <xsl:element name="{$root-element}">
   <xsl:apply-templates />
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="w:p">
  <xsl:variable name="style" select="(key('style', w:pPr/w:pStyle/@w:val, $styles)/w:name[1]/@w:val, $default-paragraph-style)[1]"/>
  <xsl:element name="{dcx:get-style-name($style)}">
   <xsl:if test="$keep-direct-formatting">
    <xsl:apply-templates select="w:pPr" mode="direct-formatting" />
   </xsl:if>
   <xsl:apply-templates select="w:r | w:footnoteReference | w:commentRangeStart | w:commentRangeEnd" />
  </xsl:element>
  <xsl:apply-templates select="w:r/w:footnoteReference" mode="footnotes" />
  <xsl:apply-templates select="w:commentRangeEnd" mode="comments" />
 </xsl:template>
 
 <xsl:template match="w:r">
  <xsl:variable name="style" select="(key('style', w:rPr/w:rStyle/@w:val, $styles)/w:name[1]/@w:val, $default-character-style)[1]"/>
  <xsl:element name="{dcx:get-style-name($style)}">
   <xsl:copy-of select="w:t/@xml:space" />
   <xsl:if test="$keep-direct-formatting">
    <xsl:apply-templates select="w:rPr" mode="direct-formatting" />
   </xsl:if>
   <xsl:apply-templates select="w:t | w:tab | w:footnoteReference | w:commentRangeStart | w:commentRangeEnd" />
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="w:t">
  <!--<xsl:copy-of select="@xml:space" />-->
  <xsl:value-of select="."/>
 </xsl:template>
 
 <xsl:template match="w:pPr/*[@*] | w:rPr/*[@*]" mode="direct-formatting">
  <xsl:variable name="element-name" select="local-name()"/>
  <xsl:for-each select="@*">
   <xsl:variable name="name" select="local-name()"/>
   <xsl:attribute name="{$element-name}-{$name}" select="." />
  </xsl:for-each>
 </xsl:template>
 
 <xsl:template match="w:rFonts | w:pStyle | w:rStyle | w:sz | w:szCs" mode="direct-formatting" priority="2" />
 
 <xsl:template match="w:pPr/w:rPr/*" mode="direct-formatting" priority="3" />
 
 <xsl:template match="w:b | w:i | w:u | w:caps | w:smallCaps | w:strike | w:vertAlign" mode="direct-formatting" priority="2">
  <xsl:variable name="name" select="local-name()"/>
  <xsl:variable name="attribute-name" select="if(string-length($name) eq 1) then map:get($style-names, $name) else $name"/>
  <xsl:attribute name="{$attribute-name}" select="'true'" />
 </xsl:template>
 
 <xsl:template match="w:footnoteReference">
  <xsl:variable name="number">
   <xsl:number level="any" />
  </xsl:variable>
  <xsl:element name="{local-name()}">
   <xsl:attribute name="id" select="@w:id" />
   <xsl:value-of select="$number"/>
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="w:footnoteReference" mode="footnotes">
  <xsl:variable name="number">
   <xsl:number level="any" />
  </xsl:variable>
  
  <xsl:variable name="footnote" select="key('footnote', @w:id, $footnotes)"/>
  <xsl:element name="{$footnote-element}">
   <xsl:attribute name="id" select="@w:id" />
   <xsl:attribute name="n" select="$number" />
   <xsl:apply-templates select="$footnote" />
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="w:commentRangeEnd">
  <xsl:element name="comment-range">
   <xsl:attribute name="type" select="'end'" />
   <xsl:attribute name="id" select="@w:id" />
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="w:commentRangeStart">
  <xsl:element name="comment-range">
   <xsl:attribute name="type" select="'start'" />
   <xsl:attribute name="id" select="@w:id" />
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="w:commentRangeEnd" mode="comments">
  
  <xsl:variable name="comment" select="key('comment', @w:id, $comments)"/>
  <xsl:element name="{$comment-element}">
   <xsl:attribute name="id" select="@w:id" />
   <xsl:apply-templates select="$comment" />
  </xsl:element>
 </xsl:template>
 
 <xsl:template match="w:tab">
  <tab />
 </xsl:template>
 
 <xsl:template match="w:tbl">
  <xsl:variable name="n">
   <xsl:number />
  </xsl:variable>
  <table n="{$n}">
   <xsl:apply-templates />
  </table>
 </xsl:template>
 
 <xsl:template match="w:tr">
  <xsl:variable name="n">
   <xsl:number />
  </xsl:variable>
  <row n="{$n}">
   <xsl:apply-templates />
  </row>
 </xsl:template>
 
 <xsl:template match="w:tc">
  <xsl:variable name="n">
   <xsl:number />
  </xsl:variable>
  <cell n="{$n}">
   <xsl:apply-templates />
  </cell>
 </xsl:template>
 
 <xsl:function name="dcx:get-style-name">
  <xsl:param name="name" as="xs:string" />
  <xsl:value-of select="translate($name, ' ()', '-')"/>
 </xsl:function>
 
</xsl:stylesheet>