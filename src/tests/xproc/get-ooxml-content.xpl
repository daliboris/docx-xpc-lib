<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
	version="3.0" name="get-ooxml-content">
   
		<p:import href="../../xproc/docx-xpc-lib.xpl" />
   
  <p:input port="source" primary="true" href="../input/docx-with-formatting.docx" />
<!--  <p:input port="source" primary="true" href="../input/revisions-clean.docx" />-->
   
	 <p:output port="result" serialization="map{'indent' : true()}" />
	
	<!-- OPTIONS -->
	<p:option name="debug-path" as="xs:anyURI?" select="'../_debug/ooxnl-content'" />
	<p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>

  <p:for-each>
  	<p:with-input select="('document', 'styles', 'footnotes', 'comments', 'hyperlinks')"/>
  	<p:variable name="content" select="." />

  	<dxd:get-ooxml-content content="{$content}" p:message="Getting: {$content}" debug-path="{$debug-path}" base-uri="{$base-uri}">
  		<p:with-input port="source" pipe="source@get-ooxml-content" />
  	</dxd:get-ooxml-content>

  	<p:store href="../output/get-ooxml-content/{$content}.xml" serialization="map{'indent' : true()}" />

  	<p:identity>
  		<p:with-input pipe="result-uri"/>
  	</p:identity>

  </p:for-each>
	
		<p:wrap-sequence wrapper="c:results" />

	
</p:declare-step>
