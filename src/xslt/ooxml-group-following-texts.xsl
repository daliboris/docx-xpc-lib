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
 
 <xsl:template match="w:r" use-when="true()">
  <xsl:copy>
   <xsl:apply-templates select="@*"/>
   <xsl:copy-of select="w:rPr" />
   
   <!-- Sloučit <w:r> se stejným <w:rPr> -->
   <xsl:for-each-group select="*" group-adjacent="if(self::w:t) then 0 else position()">
    <xsl:choose>
     <xsl:when test="current-grouping-key() eq 0">
      <xsl:variable name="text" select="string-join(current-group())"/>
      <w:t>
       <xsl:call-template name="add-xml-space">
        <xsl:with-param name="text" select="$text" />
       </xsl:call-template>
       <xsl:value-of select="string-join(current-group())"/>
      </w:t>
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