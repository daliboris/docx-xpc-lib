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
   <xd:p><xd:b>Created on:</xd:b> May 14, 2024</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:strip-space elements="*"/>
 <xsl:output method="xml" indent="yes" />
 <xsl:mode on-no-match="shallow-copy"/>
 
 <xd:doc>
  <xd:desc>
   <xd:p><xd:a href="https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_delInstrText_topic_ID0EGGS1.html">See</xd:a></xd:p>
   <w:fldchar w:type="begin" />
   <w:ins>
    <w:r>
     <w:instrText>FORMCHECKBOX</w:instrText>
    </w:r>
    <w:del>
     <w:r>
      <w:delInstrText>FORMFIELDTEXT</w:delInstrText>
     </w:r>
    </w:del>
    <w:fldChar w:type="seperate" />
    …
    <w:fldChar w:type="end" />
   </w:ins>
  </xd:desc>
 </xd:doc>
 <xsl:template match="w:delInstrText" />
 
 <xd:doc>
  <xd:desc>
   <xd:p>
    <xd:a href="https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_moveTo_topic_ID0EXMJW.html?hl=w%3Amoveto">See</xd:a>
   </xd:p>
   <w:p>
    <w:moveToRangeStart w:id="0" w:name="move1" />
    <w:moveTo w:id="1">
     <w:r>
      <w:t>Some moved text.</w:t>
     </w:r>
    </w:moveTo>
    <w:moveToRangeEnd w:id="0" />
    <w:r>
     <w:t xml:space="preserve">Some text.</w:t>
    </w:r>
    <w:moveFromRangeStart w:id="2" w:name="move1" />
    <w:moveFrom w:id="3" >
     <w:r>
      <w:t>Some moved text.</w:t>
     </w:r>
    </w:moveFrom>
    <w:moveFromRangeEnd w:id="2" />
   </w:p>
  </xd:desc>
 </xd:doc>
 <xsl:template match="w:moveToRangeStart | w:moveFromRangeStart | w:moveToRangeEnd | w:moveFromRangeEnd" />
 
 <xd:doc>
  <xd:desc>
   <xd:p>
    <xd:a href="https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_moveTo_topic_ID0EXMJW.html?hl=w%3Amoveto">See</xd:a>
   </xd:p>
  </xd:desc>
 </xd:doc>
 <xsl:template match="w:moveFrom" />
 
 <xd:doc>
  <xd:desc>
   <xd:p>
    <xd:a href="https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_moveTo_topic_ID0EXMJW.html?hl=w%3Amoveto">See</xd:a>
   </xd:p>
  </xd:desc>
 </xd:doc>
 <xsl:template match="w:moveTo">
  <xsl:apply-templates />
 </xsl:template>
 
 <xd:doc>
  <xd:desc>
   <xd:p>
    <xd:a href="https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_rPrChange_topic_ID0E4JSW.html?hl=w%3Arprchange">See</xd:a>
   </xd:p>
   <xd:p>The child element of this element contains the complete set of run properties which were applied to this run before this revision.</xd:p>
   <w:rPr>
    <w:b/>
    <w:i/>
    <w:rPrChange w:id="0" w:date="01-01-2006T12:00:00" w:author="John Doe">
     <w:rPr>
      <w:i/>
     </w:rPr>
    </w:rPrChange>
   </w:rPr>
  </xd:desc>
 </xd:doc>
 <xsl:template match="w:rPrChange" />
 
 <xd:doc>
  <xd:desc>
   <xd:p>
    <xd:a href="https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_pPrChange_topic_ID0EXXRW.html?hl=pprchange">See</xd:a>
   </xd:p>
   <xd:p>The child element of this element contains the complete set of paragraph properties which were applied to this paragraph before this revision.</xd:p>
   <w:pPr>
    <w:jc w:val="center"/>
    <w:pPrChange w:id="0" w:date="01-01-2006T12:00:00" w:author="John Doe">
     <w:pPr/>
    </w:pPrChange>
   </w:pPr>
  </xd:desc>
 </xd:doc>
 <xsl:template match="w:pPrChange" />
 
 <xd:doc>
  <xd:desc>
   <xd:p><xd:a href="https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_Inline_topic_ID0EW2IV.html?hl=w%3Adel">See</xd:a> amd <xd:a href="https://c-rex.net/samples/ooxml/e1/Part3/OOXML_P3_Primer_Revisions_topic_ID0E3PCK.html?hl=w%3Ains">w:ins</xd:a></xd:p>
   <w:p>
    <w:r>
     <w:t xml:space="preserve">The quick brown fox jumps over the </w:t>
    </w:r>
    <w:del>
     <w:r>
      <w:delText>lazy</w:delText>
     </w:r>
    </w:del>
    <w:ins>
     <w:r>
      <w:t>jet lagged</w:t>
     </w:r>
    </w:ins>
    <w:r>
     <w:t xml:space="preserve"> dog.</w:t>
    </w:r>
   </w:p> 
   <w:p>
    <w:r>
     <w:t>Some</w:t>
    </w:r>
    <w:ins w:id="0" w:author="Joe Smith" w:date="2006-03-31T12:50:00Z">
     <w:r>
      <w:t>text</w:t>
     </w:r>
    </w:ins>
   </w:p>
  </xd:desc>
 </xd:doc>
 <xsl:template match="w:del | w:delText" />
 <xsl:template match="w:ins">
  <xsl:apply-templates />
 </xsl:template>
 
 <xd:doc>
  <xd:desc>
   <xd:p>
    <xd:a href="https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_del_topic_ID0EMM3V.html?hl=w%3Adel">See</xd:a>
   </xd:p>
   <xd:p>Following paragraph previously formatted with default paragraph style, now formatted wih "Bezmezer" style.</xd:p>
   <w:p>
    <w:pPr>
     <w:pStyle w:val="Bezmezer" />
     <w:pPrChange w:id="7" w:author="Boris Lehečka" w:date="2024-10-16T12:55:00Z">
      <w:pPr />
     </w:pPrChange>
    </w:pPr>
   </w:p>
   <xd:p>This element specifies that the paragraph mark delimiting the end of a paragraph within a WordprocessingML document shall be treated as deleted (i.e. the contents of this paragraph are no longer delimited by this paragraph mark, and are combined with the following paragraph - but those contents shall not automatically be marked as deleted) as part of a tracked revision.</xd:p>
   <xd:p>Místo Delimitator_hesel + Heslove_zahlavi má být Delimitator_hesel </xd:p>
   <w:p>
    <w:pPr>
     <w:pStyle w:val="Heslovezahlavi"/>
     <w:rPr>
      <w:del w:id="799" w:author="Kateřina Voleková" w:date="2023-01-17T10:05:00Z"/>
     </w:rPr>
     <w:pPrChange w:id="800" w:author="Kateřina Voleková" w:date="2023-01-17T10:05:00Z">
      <w:pPr>
       <w:pStyle w:val="Delimitatorhesel"/>
      </w:pPr>
     </w:pPrChange>
    </w:pPr>
   </w:p>
  </xd:desc>
  
 </xd:doc>
 <xsl:template match="w:pPr[w:rPr[w:del]][w:pPrChange]">
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:apply-templates select="w:pPrChange/*" />
  </xsl:copy>
 </xsl:template>
 
 <xd:doc>
  <xd:desc>
   <xd:p>Completely removed paragraph, i.e. paragraph sing and text (runs).</xd:p>
   <w:p>
    <w:pPr>
     <w:rPr>
      <w:del w:id="8" />
     </w:rPr>
    </w:pPr>
    <w:del w:id="9">
     <w:r w:rsidDel="00537E71">
      <w:delText>Deleted</w:delText>
     </w:r>
     <w:r w:rsidR="00145B73" w:rsidDel="00537E71">
      <w:delText xml:space="preserve"> </w:delText>
     </w:r>
     <w:r w:rsidDel="00537E71">
      <w:delText>paragraph</w:delText>
     </w:r>
    </w:del>
   </w:p>
  </xd:desc>
 </xd:doc>
 <xsl:template match="w:p[w:pPr[w:rPr[w:del]]][not(w:r)]" />
 
 <xd:doc>
  <xd:desc>
   <xd:p>Merged paragraph with the following one.</xd:p>
   <w:p>
    <w:pPr>
     <w:rPr>
      <w:del w:id="10" />
     </w:rPr>
    </w:pPr>
    <w:r>
     <w:t>First</w:t>
    </w:r>
    <w:r w:rsidR="00145B73">
     <w:t xml:space="preserve"> </w:t>
    </w:r>
    <w:r>
     <w:t>paragraph</w:t>
    </w:r>
    <w:ins w:id="11">
     <w:r w:rsidR="00537E71">
      <w:t xml:space="preserve"> </w:t>
     </w:r>
    </w:ins>
   </w:p>
  </xd:desc>
 </xd:doc>
 <xsl:template match="w:p[w:pPr[w:rPr[w:del]]][w:r]">
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:apply-templates select="following-sibling::*[1]/w:pPr" />
   <xsl:apply-templates select="* except w:pPr" />
   <xsl:apply-templates select="following-sibling::*[1]/* except w:pPr" />
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="w:p[preceding-sibling::*[1][self::w:p[w:pPr[w:rPr[w:del]]][w:r]]]" />
 
 
</xsl:stylesheet>