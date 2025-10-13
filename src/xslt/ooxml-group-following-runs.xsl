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
 
 <!-- WIP -->
 <xsl:template match="w:p" use-when="true()">
  <xsl:copy>
   <xsl:apply-templates select="@*"/>
   <!-- Combine <w:r> with identical <w:rPr> -->
   <xsl:for-each-group select="*"
    group-adjacent="local-name()">
    <xsl:choose>
     <xsl:when test="current-group()[self::w:r]">
      <xsl:for-each-group select="current-group()" group-adjacent="serialize(w:rPr)">
       <xsl:variable name="first" select="current-group()[1]"/>
       <w:r>
        <!-- Keep attributes of first w:r -->
        <xsl:copy-of select="$first/@*"/>
        <!-- Keep first occurence of w:rPr -->
        <xsl:copy-of select="$first/w:rPr"/>
        
        <!-- Combine content of all items in the group except for w:rPr -->
        <xsl:for-each select="current-group()">
         <xsl:copy-of select="*[not(self::w:rPr)]"/>
        </xsl:for-each>
       </w:r>
      </xsl:for-each-group>
     </xsl:when>
     <xsl:otherwise>
      <xsl:copy-of select="current-group()" />
     </xsl:otherwise>
    </xsl:choose>
   </xsl:for-each-group>
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="w:r" use-when="false()">
  <xsl:variable name="position" as="xs:integer">
   <xsl:number />
  </xsl:variable>
  <xsl:variable name="prev" select="preceding-sibling::*[1]" />
  <xsl:variable name="next" select="following-sibling::*[1]" />
  
  <xsl:variable name="prev-rend" select="if($prev[self::w:r]) then serialize($prev/w:rPr) else ()"/>
  <xsl:variable name="current-rend" select="serialize(w:rPr)" as="xs:string"/>
  <xsl:variable name="next-rend" select="if($next[self::w:r]) then serialize($next/w:rPr) else ()"/>
  <xsl:choose>
   <xsl:when test="$position eq 1">
    <xsl:copy>
     <xsl:copy-of select="@*" /> 
     <xsl:apply-templates  />
     <xsl:apply-templates select="following-sibling::*[1]" mode="merge" />
    </xsl:copy>    
   </xsl:when>
   <!-- skip, it's proceeded in merge mode -->
   <xsl:when test="$current-rend = $prev-rend" />
   <!-- create parent element and process child elements from following -->
   <xsl:when test="$current-rend = $next-rend">
    <xsl:copy>
     <xsl:copy-of select="@*" /> 
     <xsl:apply-templates  />
     <xsl:apply-templates select="following-sibling::*[1]" mode="merge" />
    </xsl:copy>
   </xsl:when>
   <!-- copy while element -->
   <xsl:otherwise>
     <xsl:copy-of select="." />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="w:r" mode="merge" use-when="false()">
  
  <xsl:variable name="prev" select="preceding-sibling::*[1]" />
  <xsl:variable name="next" select="following-sibling::*[1]" />

  <xsl:variable name="prev-rend" select="if($prev[self::w:r]) then serialize($prev/w:rPr) else ()"/>
  <xsl:variable name="current-rend" select="serialize(w:rPr)"/>
  <xsl:variable name="next-rend" select="if($next[self::w:r]) then serialize($next/w:rPr) else ()"/>

 <xsl:if test="$prev-rend = $current-rend">
  <xsl:apply-templates select="* except w:rPr" />
  
  <xsl:if test="$current-rend = $next-rend">
   <xsl:apply-templates select="following-sibling::*[1]" mode="merge" />
  </xsl:if>  
 </xsl:if>

  
 </xsl:template>

 
</xsl:stylesheet>