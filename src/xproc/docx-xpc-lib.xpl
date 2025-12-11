<p:library xmlns:p="http://www.w3.org/ns/xproc"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
 xmlns:c="http://www.w3.org/ns/xproc-step" 
 xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
 xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
 version="3.0">
  
 <!-- STEP -->
 <p:declare-step type="dxd:get-document" version="3.0" name="getting-document">
  <p:documentation>Gets document.xml file in OOXML format from DOCX container.</p:documentation>

  <p:output port="result" serialization="map{'indent' : false()}" primary="true">
   <p:documentation>Document.xml itself.</p:documentation>
  </p:output>
  
  <p:input port="source">
   <p:documentation>Source document, ie. DOCX file.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>

  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  <p:archive-manifest name="manifest">
   <p:with-input port="source" pipe="source@getting-document" />
  </p:archive-manifest>
  
  <!-- Extract the zip file: -->
  <!-- https://test-suite.xproc.org/tests/ab-unarchive-012.html -->
  <p:unarchive include-filter="word/document\.xml">
   <p:with-input pipe="source@getting-document" />
  </p:unarchive>
  
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/document.xml" />
  </p:if>
  
  <!-- https://github.com/xproc/3.0-steps/issues/362 -->
<!--  <p:split-sequence test="ends-with(p:document-property(., 'base-uri'), 'word/document.xml')" />-->

 </p:declare-step>

 <!-- STEP -->
 <p:declare-step type="dxd:extract-text" version="3.0" name="content-extract-text">
  
  <p:output port="result" primary="true">
   <p:documentation>Text document with extracted text itself</p:documentation>
  </p:output>
  
  <p:output port="result-uri" serialization="map{'indent' : true()}" primary="false" pipe="result-uri@storing">
   <p:documentation>Information about document replacement</p:documentation>
  </p:output>
  
  <p:input port="source">
   <p:documentation>OOXML document, ie. document.xml from DOCX file.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  <p:option name="href" as="xs:anyURI" />
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  <p:variable name="href-uri" select="resolve-uri($href, $base-uri)" />
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../Xslt/ooxml-extract-text.xsl" />   
  </p:xslt>
  
  <p:store href="{$href-uri}" name="storing" message="Storing text to {$href-uri}" />
  
 </p:declare-step>
 
 <!-- STEP -->
 <p:declare-step type="dxd:get-styles" version="3.0" name="getting-styles">
  <p:documentation>Gets styles.xml file in OOXML format from DOCX container.</p:documentation>
  
  <p:output port="result" serialization="map{'indent' : false()}" primary="true">
   <p:documentation>Styles.xml itself.</p:documentation>
  </p:output>
  
  <p:input port="source" primary="true">
   <p:documentation>Source document, ie. DOCX file.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  <!--<p:archive-manifest name="manifest">
   <p:with-input port="source" pipe="source@getting-styles" />
  </p:archive-manifest>-->
  
  <!-- Extract the zip file: -->
  <!-- https://test-suite.xproc.org/tests/ab-unarchive-012.html -->
  <p:unarchive include-filter="word/styles\.xml">
   <p:with-input pipe="source@getting-styles" />
  </p:unarchive>
  
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/styles/source.xml" />
  </p:if>
  
 </p:declare-step>
 
 <!-- STEP -->
 <p:declare-step type="dxd:get-ooxml-content" version="3.0" name="getting-ooxml-content">
  <p:option name="content" as="xs:string" values="('document', 'styles', 'footnotes', 'comments', 'hyperlinks')" />
  
  <p:input port="source" primary="true">
   <p:documentation>Source document, ie. DOCX file.</p:documentation>
  </p:input>
  
  <p:output port="result" serialization="map{'indent' : false()}" primary="true" >
   <p:documentation>Extracted document itself.</p:documentation>
  </p:output>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  <p:variable name="include-filter" select="if($content = 'hyperlinks') then 'document\.xml\.rels' else 'word/' || $content || '\.xml'" />
  
  <p:unarchive include-filter="{$include-filter}" name="content" />
  
 
  <p:count />
  
  <p:choose>
   <p:when test="/c:result[.= 0]">
    <p:choose>
     <p:when test="$content = 'comments'">
      <p:identity>
       <p:with-input port="source">
        <w:comments />
       </p:with-input>
      </p:identity>
     </p:when>
     <p:when test="$content = 'footnotes'">
      <p:identity>
       <p:with-input port="source">
        <w:footnotes />
       </p:with-input>
      </p:identity>
     </p:when>
     <p:when test="$content = 'hyperlinks'">
      <p:identity>
       <p:with-input port="source">
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships" />
       </p:with-input>
      </p:identity>
     </p:when>
     <p:otherwise>
      <p:identity>
       <p:with-input port="source">
        <w:document />
       </p:with-input>
      </p:identity>
     </p:otherwise> 
    </p:choose>
   </p:when>
   <p:otherwise>
    <p:identity>
     <p:with-input port="source" pipe="result@content" />
    </p:identity>
   </p:otherwise>
  </p:choose>
  
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/{$content}/source.xml" />
  </p:if>

 </p:declare-step>

 <!-- STEP -->
 <p:declare-step type="dxd:replace-document-only" version="3.0" name="replacing-document-only">
  <p:documentation>Replaces document.xml file in OOXML format withing DOCX container.</p:documentation>
  
  <p:output port="result" serialization="map{'indent' : true()}" primary="true">
   <p:documentation>Document replacement itself</p:documentation>
  </p:output>
  
  <p:input port="source" primary="true">
   <p:documentation>Target document, ie. DOCX file which will be changed.</p:documentation>
  </p:input>
  
  <p:input port="document">
   <p:documentation>Source document, ie. document.xml file in OOXML format.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  <!-- Get the existing manifest: -->
  <p:archive-manifest name="manifest" />
  
  
  <!-- Extract the zip file: -->
  <p:unarchive>
   <p:with-input pipe="source@replacing-document-only" />
  </p:unarchive>
  <!-- Now we have multiple documents flowing through the pipeline...  -->
  
  <!-- Find document.xml file in the archive: -->
  <p:for-each>
   <p:if test="ends-with(p:document-property(., 'base-uri'), '/document.xml')">
    <p:replace match="w:document">
     <p:with-input port="replacement" pipe="document@replacing-document-only" />
    </p:replace>
   </p:if>
  </p:for-each>
  
  <!-- Create a new archive and store it: -->
  <p:archive> <!-- {$file-path} -->
   <p:with-input port="manifest" pipe="result@manifest" />
  </p:archive>
    
 </p:declare-step>

 <!-- STEP -->
 <p:declare-step type="dxd:replace-document" version="3.0" name="document-replace">
  <p:documentation>Replaces document.xml file in OOXML format withing DOCX container.</p:documentation>
  
  <p:output port="result" serialization="map{'indent' : true()}" primary="true">
   <p:documentation>Document replacement itself</p:documentation>
  </p:output>
  
  <!-- As a report, output where the new zip is stored: -->
  
  <p:output port="result-uri" serialization="map{'indent' : true()}" primary="false" pipe="result-uri@storing" sequence="true">
   <p:documentation>Information about document replacement</p:documentation>
  </p:output>
  
  <p:input port="source">
   <p:documentation>Target document, ie. DOCX file which will be changed.</p:documentation>
  </p:input>

  <p:input port="document">
   <p:documentation>Source document, ie. document.xml file in OOXML format.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <p:option name="docx-href" as="xs:anyURI" required="true"  />
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  <p:variable name="docx-href-uri" select="resolve-uri($docx-href, $base-uri)" />
 
  <!-- Get the existing manifest: -->
  <p:archive-manifest name="manifest">
   <p:with-input port="source" pipe="source@document-replace" />
  </p:archive-manifest>
  
  <!-- Extract the zip file: -->
  <p:unarchive>
   <p:with-input pipe="source@document-replace" />
  </p:unarchive>
  <!-- Now we have multiple documents flowing through the pipeline...  -->
  
  <!-- Find document.xml file in the archive: -->
  <p:for-each>
   <p:if test="ends-with(p:document-property(., 'base-uri'), '/document.xml')">
    <p:replace match="w:document">
     <p:with-input port="replacement" pipe="document@document-replace" />
    </p:replace>
   </p:if>
  </p:for-each>
  
  <!-- Create a new archive and store it: -->
  <p:archive> <!-- {$file-path} -->
   <p:with-input port="manifest" pipe="result@manifest" />
  </p:archive>
  
  <p:store href="{$docx-href-uri}" name="storing" message="Storing: {$docx-href} :: {$docx-href-uri}" /> 

 </p:declare-step>
 
 <!-- STEP -->
 <p:declare-step type="dxd:replace-styles" version="3.0" name="styles-replace">
  <p:documentation>Replaces document.xml file in OOXML format withing DOCX container.</p:documentation>
  
  <p:output port="result" serialization="map{'indent' : true()}" primary="true">
   <p:documentation>Document replacement itself</p:documentation>
  </p:output>
  
  <!-- As a report, output where the new zip is stored: -->
  
  <p:output port="result-uri" serialization="map{'indent' : true()}" primary="false" pipe="result-uri@storing">
   <p:documentation>Information about document replacement</p:documentation>
  </p:output>
  
  <p:input port="source">
   <p:documentation>Target document, ie. DOCX file which will be changed.</p:documentation>
  </p:input>
  
  <p:input port="document">
   <p:documentation>Source document with styles definition, ie. styles.xml file in OOXML format.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <p:option name="docx-href" as="xs:anyURI"  />
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  <p:variable name="docx-href-uri" select="resolve-uri($docx-href, $base-uri)" />
  
  <!-- Get the existing manifest: -->
  <p:archive-manifest name="manifest">
   <p:with-input port="source" pipe="source@styles-replace" />
  </p:archive-manifest>
  
  <!-- Extract the zip file: -->
  <p:unarchive>
   <p:with-input pipe="source@styles-replace" />
  </p:unarchive>
  <!-- Now we have multiple documents flowing through the pipeline...  -->
  
  <!-- Find document.xml file in the archive: -->
  <p:for-each>
   <p:if test="ends-with(p:document-property(., 'base-uri'), '/styles.xml')">
    <p:replace match="w:styles">
     <p:with-input port="replacement" pipe="document@styles-replace" />
    </p:replace>
   </p:if>
  </p:for-each>
  
  <!-- Create a new archive and store it: -->
  <p:archive message="Document source: "> <!-- {$file-path} -->
   <p:with-input port="manifest" pipe="result@manifest" />
  </p:archive>
  
  <p:store href="{$docx-href-uri}" name="storing" message="Storing {$docx-href} ::: {$docx-href-uri}" />
  
 </p:declare-step>
 
 <!-- STEP -->
 <p:declare-step type="dxd:replace-content" version="3.0" name="content-replace">
  <p:documentation>Replaces document.xml and styles.xml files in OOXML format withing DOCX container.</p:documentation>
  
  <p:output port="result" serialization="map{'indent' : true()}" primary="true">
   <p:documentation>Document replacement itself</p:documentation>
  </p:output>
  
  <!-- As a report, output where the new zip is stored: -->
  
  <p:output port="result-uri" serialization="map{'indent' : true()}" primary="false" pipe="result-uri@storing">
   <p:documentation>Information about document replacement</p:documentation>
  </p:output>
  
  <p:input port="source">
   <p:documentation>Target document, ie. DOCX file which will be changed.</p:documentation>
  </p:input>
  
  <p:input port="document">
   <p:documentation>Source document, ie. document.xml file in OOXML format.</p:documentation>
  </p:input>
  
  <p:input port="styles">
   <p:documentation>Source document with styles definition, ie. styles.xml file in OOXML format.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <p:option name="docx-href" as="xs:anyURI"  />
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  <p:variable name="docx-href-uri" select="resolve-uri($docx-href, $base-uri)" />

  <!-- Get the existing manifest: -->
  <p:archive-manifest name="manifest">
   <p:with-input port="source" pipe="source@content-replace" />
  </p:archive-manifest>
  
  <!-- Extract the zip file: -->
  <p:unarchive>
   <p:with-input pipe="source@content-replace" />
  </p:unarchive>
  <!-- Now we have multiple documents flowing through the pipeline...  -->
  
  <!-- Find document.xml file in the archive: -->
  <p:for-each>
   <p:if test="ends-with(p:document-property(., 'base-uri'), '/document.xml')">
    <p:replace match="w:document" message="Replacing document in {p:document-property(., 'base-uri')}">
     <p:with-input port="replacement" pipe="document@content-replace" />
    </p:replace>
   </p:if>
   <p:if test="ends-with(p:document-property(., 'base-uri'), '/styles.xml')">
    <p:replace match="w:styles" message="Replacing styles in {p:document-property(., 'base-uri')}">
     <p:with-input port="replacement" pipe="styles@content-replace" />
    </p:replace>
   </p:if>
  </p:for-each>
  
  <!-- Create a new archive and store it: -->
  <p:archive message="Archiving modified DOCX document"> <!-- {$file-path} -->
   <p:with-input port="manifest" pipe="result@manifest" />
  </p:archive>
  
  <p:store href="{$docx-href-uri}" name="storing" message="Storing {$docx-href} ::: {$docx-href-uri}" />
  
 </p:declare-step>
 
 <!-- STEP -->
 <p:declare-step type="dxd:get-hyperlinks" version="3.0" name="getting-hyperlinks">
  <p:documentation>Gets list of hyperlinks used in DOCX document.</p:documentation>
  
  <p:output port="result" serialization="map{'indent' : true()}" primary="true" sequence="true">
   <p:documentation>List of Relationship elements containing all hyperlinks used in DOCX document.</p:documentation>
  </p:output>
  
  <p:input port="source">
   <p:documentation>Source document, ie. DOCX file.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  
  <p:archive-manifest name="manifest">
   <p:with-input port="source" pipe="source@getting-hyperlinks" />
  </p:archive-manifest>
  
  <p:unarchive include-filter=".*\.rels" override-content-types="[ ['.rels$', 'application/xml'], ['^special/', 'application/octet-stream'] ]">
   <p:with-input pipe="source@getting-hyperlinks"  />
  </p:unarchive>
  
  <p:for-each name="iteration">
   <p:filter select="//rel:Relationship[@Type='http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink']" />
  </p:for-each>
  
 </p:declare-step>
 
 <!-- STEP -->
 <p:declare-step type="dxd:clean-runs" version="3.0" name="cleaning-runs">
  
  <p:output port="result" primary="true">
   <p:documentation>OOXML document with cleaned runs, i.e. merged following runs and moved space to previous run</p:documentation>
  </p:output>
  
  <p:input port="source">
   <p:documentation>OOXML document, ie. document.xml from DOCX file.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/clean-runs/document-01.xml" />   
  </p:if>
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../Xslt/ooxml-remove-proofErrors.xsl" />
  </p:xslt>
  
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/clean-runs/document-02-proofErrors.xml" /> 
  </p:if>
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../Xslt/ooxml-remove-smartTags.xsl" />
  </p:xslt>

  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/clean-runs/document-03-smartTags.xml" /> 
  </p:if>
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../Xslt/ooxml-remove-view-bookmarks.xsl" />
  </p:xslt>
  
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/clean-runs/document-04-remove-view-bookmarks.xml" /> 
  </p:if>

  <p:xslt>
   <p:with-input port="stylesheet" href="../Xslt/ooxml-group-following-runs.xsl" />
  </p:xslt>
  
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/clean-runs/document-05-following-runs.xml" /> 
  </p:if>
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../Xslt/ooxml-group-following-texts.xsl" />
  </p:xslt>
  
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/clean-runs/document-06-following-texts.xml" /> 
  </p:if>
  
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../Xslt/ooxml-move-space-to-another-run.xsl" />
  </p:xslt>
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/clean-runs/document-07-move-space.xml" /> 
  </p:if>
  
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../Xslt/ooxml-remove-duplicated-run-styles.xsl" />
  </p:xslt>
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/clean-runs/document-08-remove-duplicated.xml" />
  </p:if>
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../Xslt/ooxml-remove-empty-run-styles.xsl" />
  </p:xslt>
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/clean-runs/document-09-remove-empty.xml" />
  </p:if>
  
 </p:declare-step>
 
 <!-- STEP -->
 <p:declare-step type="dxd:remove-protection" version="3.0" name="removing-protection">
  <p:documentation>Removes protection from the document.</p:documentation>
  
  <p:output port="result" serialization="map{'indent' : true()}" primary="true">
   <p:documentation>Document replacement itself</p:documentation>
  </p:output>
    
  <p:input port="source" primary="true">
   <p:documentation>Target document, ie. DOCX file which will be changed.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  <!-- Get the existing manifest: -->
  <p:archive-manifest name="manifest">
   <p:with-input port="source" pipe="source@removing-protection" />
  </p:archive-manifest>
  
  <!-- Extract the zip file: -->
  <p:unarchive>
   <p:with-input pipe="source@removing-protection" />
  </p:unarchive>
  
  <!-- Find document.xml file in the archive: -->
  <p:for-each>
   <p:if test="ends-with(p:document-property(., 'base-uri'), '/settings.xml')">
    <p:delete match="w:documentProtection" />
   </p:if>
  </p:for-each>
  
  <!-- Create a new archive and store it: -->
  <p:archive message="Archiving modified DOCX document"> <!-- {$file-path} -->
   <p:with-input port="manifest" pipe="result@manifest" />
  </p:archive>
  
 </p:declare-step>

 <!-- STEP -->
 <p:declare-step type="dxd:docx-to-xml" version="3.0" name="docx-to-xml">

  <!-- INPUT PORTS -->
  <p:input port="source" primary="true">
   <p:documentation>Source document, ie. DOCX file.</p:documentation>
  </p:input>
  
  <p:input port="conversion-settings" sequence="true">
   <p:documentation>Settings with conversion rules.</p:documentation>
   <p:empty />
  </p:input>
  
  <!-- OUTPUT PORTS -->
  <p:output port="result" primary="true">
   <p:documentation>OOXML document with cleaned runs, i.e. merged following runs and moved space to previous run</p:documentation>
  </p:output>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <p:option name="clean-markup" as="xs:boolean" select="false()" />
  <p:option name="keep-direct-formatting" as="xs:boolean" select="false()" />
  <p:option name="revisions" as="xs:string?" select="'accept'" values="('accept', 'reject', 'keep')" />
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />

  <p:variable name="file-stem" select="tokenize(tokenize(resolve-uri(base-uri(/), $base-uri), '/')[last()], '\.')[position() lt last()] => string-join('.')" />
  
  <p:variable name="content-debug-path" select="if($debug) then p:urify($debug-path, $base-uri) else () || '/' || $file-stem || '/docx-to-xml/content'" />
  <p:variable name="content-debug-path-uri" select="if(empty($content-debug-path)) then () else p:urify($content-debug-path, $base-uri)" />
  
  <!-- PIPELINE BODY -->
  <p:group use-when="false()">
   <p:variable name="styles" select="/">
    <dxd:get-styles debug-path="{$debug-path}" base-uri="{$base-uri}" />
   </p:variable>
   
   <p:variable name="comments" select="/">
    <dxd:get-ooxml-content content="comments" debug-path="{$content-debug-path}" base-uri="{$base-uri}" />
    <p:if test="$clean-markup">
     <dxd:clean-runs debug-path="{$content-debug-path}/comments" base-uri="{$base-uri}" />   
    </p:if>
   </p:variable>   
  </p:group>
  
<!--  <p:group use-when="true()">-->
  <!--<dxd:get-styles debug-path="{$content-debug-path}" base-uri="{$base-uri}">
    <p:with-input port="source" pipe="source@docx-to-xml" />
   </dxd:get-styles>-->
  <dxd:get-ooxml-content content="styles" debug-path="{$content-debug-path}" base-uri="{$base-uri}">
   <p:with-input port="source" pipe="source@docx-to-xml" />
  </dxd:get-ooxml-content>
   <p:variable name="styles" select="/" />
   
  <dxd:get-ooxml-content content="comments" debug-path="{$content-debug-path}" base-uri="{$base-uri}">
   <p:with-input port="source" pipe="source@docx-to-xml" />
   </dxd:get-ooxml-content>
   <p:if test="$clean-markup">
    <dxd:clean-runs debug-path="{$content-debug-path}/comments" base-uri="{$base-uri}" />   
   </p:if>
   <p:variable name="comments" select="/" />   
  <!--</p:group>-->
  
  <dxd:get-ooxml-content content="footnotes" debug-path="{$content-debug-path}" base-uri="{$base-uri}">
   <p:with-input port="source" pipe="source@docx-to-xml" />
  </dxd:get-ooxml-content>
  <p:if test="$revisions != ('keep')">
   <dxd:process-revisions operation="{$revisions}" />
  </p:if>
  <p:if test="$clean-markup">
   <dxd:clean-runs debug-path="{$content-debug-path}/footnotes" base-uri="{$base-uri}" />   
  </p:if>
  <p:variable name="footnotes" select="/" />
  
  <dxd:get-ooxml-content content="hyperlinks" debug-path="{$content-debug-path}" base-uri="{$base-uri}">
   <p:with-input port="source" pipe="source@docx-to-xml" />
  </dxd:get-ooxml-content>
  <p:variable name="hyperlinks" select="/" />
  
  <dxd:get-document debug-path="{$content-debug-path}" base-uri="{$base-uri}">
   <p:with-input port="source" pipe="source@docx-to-xml" />
  </dxd:get-document>
  <p:if test="$revisions != ('keep')">
   <dxd:process-revisions operation="{$revisions}" />
  </p:if>
  <p:if test="$clean-markup">
   <dxd:clean-runs debug-path="{$content-debug-path}/document" base-uri="{$base-uri}" />   
  </p:if>
  
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/docx-to-xml/001-docx-to-xml.xml" />
  </p:if>
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../Xslt/ooxml-to-xml.xsl" />
   <p:with-option name="parameters" select="map {
    'keep-direct-formatting' : $keep-direct-formatting,
    'root' : 'body', 
    'styles' : $styles,
    'footnotes' : $footnotes,
    'comments' : $comments,
    'hyperlinks' : $hyperlinks
    }" />
  </p:xslt>
  
  <p:if test="$debug">
   <p:store href="{$debug-path-uri}/docx-to-xml/002-docx-to-xml.xml" />
  </p:if>
  
 </p:declare-step>
 
 <!-- STEP -->
 <p:declare-step type="dxd:process-revisions-docx" version="3.0" name="processing-revisions-docx" visibility="private">
  
  <p:documentation>
   <xhtml:section>
    <xhtml:h2></xhtml:h2>
    <xhtml:p></xhtml:p>
   </xhtml:section>
  </p:documentation>
  
  
  <p:input port="source" primary="true">
   <p:documentation>Source document in DOCX format</p:documentation>
  </p:input>
  
  <p:output port="result" primary="true">
   <p:documentation>DOCX document with processed revisions, i.e. inserted, moved deleted and formatted spans or paragraphs. Revisions will be acctepted or rejected.</p:documentation>
  </p:output>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <p:option name="operation" as="xs:string" select="'accept'" values="('accept', 'reject')" required="false">
   <p:documentation>How to process existing revisions: accept or reject them</p:documentation>
  </p:option>

  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  

  <dxd:get-ooxml-content content="document" debug-path="{$debug-path}" base-uri="{$base-uri}" >
   <p:with-input port="source" pipe="source@processing-revisions-docx" />
  </dxd:get-ooxml-content>
  
  <dxd:process-revisions-ooxml operation="{$operation}" debug-path="{$debug-path}" base-uri="{$base-uri}" />
  <p:identity name="revisions" />
  
  <dxd:replace-document-only debug-path="{$debug-path}" base-uri="{$base-uri}">
   <p:with-input port="source" pipe="source@processing-revisions-docx" />
   <p:with-input port="document" pipe="result@revisions" />
  </dxd:replace-document-only>
  
 </p:declare-step>
 
 <!-- STEP -->
 <p:declare-step type="dxd:process-revisions-ooxml" version="3.0" name="processing-revisions-ooxml" visibility="private">
  
  <p:documentation>
   <xhtml:section>
    <xhtml:h2></xhtml:h2>
    <xhtml:p></xhtml:p>
   </xhtml:section>
  </p:documentation>
  
  <p:input port="source" primary="true">
   <p:documentation>Source document in OOXML format</p:documentation>
  </p:input>
  
  <p:output port="result" primary="true">
   <p:documentation>OOXML document with processed revisions, i.e. inserted, moved deleted and formatted spans or paragraphs. Revisions will be acctepted or rejected.</p:documentation>
  </p:output>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <p:option name="operation" as="xs:string" select="'accept'" values="('accept', 'reject')">
   <p:documentation>How to process existing revisions: accept or reject them</p:documentation>
  </p:option>
  
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  
  <p:xslt>
   <p:with-input port="stylesheet" href="../xslt/ooxml-revisions-process.xsl" />
   <p:with-option name="parameters" select="map {'operation' : $operation }" />
  </p:xslt>
  
 </p:declare-step>
 
 <!-- STEP -->
 <p:declare-step type="dxd:process-revisions" version="3.0" name="processing-revisions" visibility="public">
  
  <p:documentation>For inspiration see https://github.com/OpenXmlDev/Open-Xml-PowerTools/blob/vNext/OpenXmlPowerTools/RevisionProcessor.cs and https://github.com/ARLM-Keller/UOF-EF-to-Open-XML-Translator/blob/master/UofTranslatorLib/resources/word/oox2uof/revisions.xsl.</p:documentation>
  
  <p:option name="operation" as="xs:string" select="'accept'" values="('accept', 'reject')">
   <p:documentation>How to process existing revisions: accept or reject them</p:documentation>
  </p:option>
  
  <p:output port="result" primary="true">
   <p:documentation>Docx or OOXML document with processed revisions, i.e. inserted, moved deleted and formatted spans or paragraphs. Revisions will be acctepted or rejected.</p:documentation>
  </p:output>
  
  <p:input port="source" primary="true">
   <p:documentation>Source document, ie. DOCX file.</p:documentation>
  </p:input>
  
  <!-- OPTIONS -->
  <p:option name="debug-path" as="xs:anyURI?" select="()" />
  <p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
  
  <!-- VARIABLES -->
  <p:variable name="debug" select="$debug-path || '' ne ''" />
  <p:variable name="debug-path-uri" select="if($debug) then p:urify($debug-path, $base-uri) else ()" />
  
  <p:variable name="content-type" select="p:document-property(., 'content-type')"/>
  <p:choose>
   <p:when test="$content-type eq 'application/xml'">
    <dxd:process-revisions-ooxml operation="{$operation}" debug-path="{$debug-path}" base-uri="{$base-uri}" />
   </p:when>
   <p:when test="$content-type eq 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'">    
    <dxd:process-revisions-docx operation="{$operation}" debug-path="{$debug-path}" base-uri="{$base-uri}" />
   </p:when>
   <p:otherwise>
    <p:identity>
     <p:with-input port="source"><c:result>Unknown document type: {$content-type}</c:result></p:with-input>
    </p:identity>
   </p:otherwise>
  </p:choose>
  
 </p:declare-step>
 
</p:library>
