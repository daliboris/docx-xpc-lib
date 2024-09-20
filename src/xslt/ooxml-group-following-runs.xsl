<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
 xmlns:xml="http://www.w3.org/XML/1998/namespace"
 exclude-result-prefixes="xs math xd"
 version="3.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> Jun 4, 2023</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:output method="xml" indent="yes" />
 <xsl:mode on-no-match="shallow-copy"/>
 
 <xsl:param name="default-style" select="'text'" />
 
 <xsl:template match="w:p">
  <xsl:copy>
   <xsl:copy-of select="@*" />
    <xsl:for-each-group select="*"  group-adjacent="
      if(self::w:r[not(w:rPr)][w:tab]) 
       then -10000 
      else if(self::w:r[w:rPr][w:tab][not(w:t)]) 
      then -10000
      else if(self::w:r[w:rPr][w:footnoteReference][not(w:t)]) 
       then 0 
       else if(self::w:r[w:rPr[w:b | w:i | w:u | w:caps | w:smallCaps | w:strike | w:vertAlign]]) 
       then 0 
      else if(self::w:r[not(w:rPr)][not(w:tab)]) 
       (: then -1 :)
       then -100 - sum(string-to-codepoints($default-style))
      else if(self::w:r[w:rPr]) 
      then -100 - sum(string-to-codepoints(self::w:r/w:rPr/w:rStyle/@w:val)) 
      else 
       position()">
     <xsl:choose>
      <xsl:when test="current-grouping-key() eq 0">
       <w:r>
        <xsl:copy-of select="(current-group()/w:rPr)[1]" />
        <xsl:copy-of select="current-group()/(* except (w:rPr, w:t, w:tab))" />
        
        <xsl:choose>
         <xsl:when test="current-group()[w:tab]">
          <xsl:copy-of select="current-group()/(w:t | w:tab)" />
         </xsl:when>
         <xsl:otherwise>
          <xsl:variable name="text" select="string-join(current-group()/w:t)"/>
          <xsl:if test="$text != ''">
           <w:t>
            <xsl:if test="normalize-space($text) != $text">
             <xsl:attribute name="space" namespace="http://www.w3.org/XML/1998/namespace" select="'preserve'" />
            </xsl:if>
            <xsl:value-of select="$text"/>
           </w:t>         
          </xsl:if>
         </xsl:otherwise>
        </xsl:choose>
       </w:r>
      </xsl:when>
      <xsl:when test="current-grouping-key() lt 0">
       <xsl:variable name="text" select="string-join(current-group()/w:t/text())"/>
       <w:r>
        <xsl:copy-of select="current-group()/w:rPr[1]"/>
        <xsl:copy-of select="w:tab" />
        <xsl:if test="$text != ''">
         <w:t>
          <xsl:call-template name="add-xml-space">
           <xsl:with-param name="text" select="$text" />
          </xsl:call-template>
          <xsl:value-of select="$text"/>
         </w:t>
        </xsl:if>
       </w:r>
      </xsl:when>
      <xsl:otherwise>
       <xsl:copy-of select="current-group()" />
      </xsl:otherwise>
     </xsl:choose>
    </xsl:for-each-group>
  </xsl:copy>
 
 </xsl:template>
 <xsl:template name="add-xml-space">
  <xsl:param name="text" as="xs:string"/>
  <xsl:if test="ends-with( $text, ' ') or starts-with( $text, ' ')">
   <xsl:attribute name="space" select="'preserve'" namespace="http://www.w3.org/XML/1998/namespace" />
  </xsl:if>
 </xsl:template>
 
</xsl:stylesheet>