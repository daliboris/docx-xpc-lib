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
 
 <xsl:template match="w:p" use-when="true()">
  <xsl:copy>
   <xsl:apply-templates select="@*"/>
   <xsl:copy-of select="w:pPr" /> <!-- * except w:r ??? -->
   
   <!-- Combine <w:r> with identical <w:rPr> -->
   <xsl:for-each-group select="w:r"
    group-adjacent="serialize(w:rPr)">
    
    <xsl:variable name="first" select="current-group()[1]"/>
    
    <w:r>
     <!-- Keep first occurence of w:rPr -->
     <xsl:copy-of select="$first/w:rPr"/>
     
     <!-- Combine content of all items in the group except for w:rPr -->
     <xsl:for-each select="current-group()">
      <xsl:copy-of select="*[not(self::w:rPr)]"/>
     </xsl:for-each>
    </w:r>
   </xsl:for-each-group>
  </xsl:copy>
 </xsl:template>

 
</xsl:stylesheet>