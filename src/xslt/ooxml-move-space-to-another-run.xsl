<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
 
 exclude-result-prefixes="xs math xd"
 version="3.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> May 9, 2023</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:param name="ommit-styles" select="()" />
 <xsl:output method="xml" indent="yes" />
 <xsl:mode on-no-match="shallow-copy"/>
 
 <xsl:template match="w:t[starts-with(., ' ')]">
  <xsl:copy>
   <xsl:copy-of select="@* except @xml:space" />
   <xsl:if test="ends-with(., ' ')">
    <xsl:attribute name="space" select="'preserve'" namespace="http://www.w3.org/XML/1998/namespace" />
   </xsl:if>
   <xsl:value-of select="substring(., 2)"/>
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="w:r[following-sibling::w:r[1]/w:t[starts-with(., ' ')]]/w:t" priority="2">
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:attribute name="space" select="'preserve'" namespace="http://www.w3.org/XML/1998/namespace" />
   <xsl:value-of select="concat(., ' ')"/>
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="w:r[not(w:tab)][w:t[not(text())]]" />
 
</xsl:stylesheet>