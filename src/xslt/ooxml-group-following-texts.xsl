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
 <xsl:mode on-no-match="shallow-copy" name="merge"/>
 
 <xsl:param name="default-style" select="'text'" />
 
 <xsl:template match="w:r[count(w:t) gt 1]" use-when="false()">
  <xsl:copy>
   <xsl:apply-templates select="@*"/>
   <xsl:apply-templates select="*[1]" mode="merge" />
  </xsl:copy>
 </xsl:template>

 <xsl:template match="w:t" mode="merge" use-when="false()">
  
  <xsl:variable name="position" as="xs:integer">
   <xsl:number />
  </xsl:variable>
  <xsl:variable name="prev" select="preceding-sibling::*[1]" />
  <xsl:variable name="next" select="following-sibling::*[1]" />
  
  <xsl:choose>
   <xsl:when test="$position eq 1">
    <xsl:copy>
     <xsl:copy-of select="@*" />
     <xsl:apply-templates mode="#current" />
     <xsl:apply-templates select="following-sibling::*[1]" mode="#current" />
    </xsl:copy>
   </xsl:when>
   <xsl:when test="$prev[self::w:t]">
    <xsl:apply-templates mode="#current" />
    <xsl:apply-templates select="following-sibling::*[1]" mode="#current" />
   </xsl:when>
   
   <xsl:when test="$next[self::w:t]">
    <xsl:copy>
     <xsl:apply-templates select="@*"/>
     <xsl:apply-templates select="*" mode="#current" />
    </xsl:copy>
   </xsl:when>
   
   <xsl:otherwise>
    <xsl:copy-of select="." />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 
 <xsl:template match="w:r[count(w:t) gt 1]" use-when="true()">
  <xsl:copy>
   <xsl:apply-templates select="@*"/>
<!--   <xsl:copy-of select="w:rPr" />-->
   
   <!-- Sloučit <w:r> se stejným <w:rPr> -->
   <xsl:for-each-group select="*" group-adjacent="if(self::w:t) then 0 else position()">
    <xsl:choose>
     <xsl:when test="current-grouping-key() eq 0">
      <xsl:choose>
       <xsl:when test="count(current-group()[self::w:t]) eq 1">
        <xsl:copy-of select="current-group()" />        
       </xsl:when>
       <xsl:otherwise>
        <xsl:variable name="text" select="string-join(current-group())"/>
        <w:t>
         <xsl:call-template name="add-xml-space">
          <xsl:with-param name="text" select="$text" />
         </xsl:call-template>
         <xsl:value-of select="$text"/>
        </w:t>
       </xsl:otherwise>
      </xsl:choose>
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