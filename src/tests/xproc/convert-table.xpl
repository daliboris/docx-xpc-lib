<p:declare-step 
	xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
	xmlns:dxt="https://www.daliboris.cz/ns/xproc/test"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	version="3.0" name="test">
	
	<p:import href="../../xproc/docx-xpc-lib.xpl" />
	
	<p:documentation>
		<xhtml:section>
			<xhtml:h2></xhtml:h2>
			<xhtml:p></xhtml:p>
		</xhtml:section>
	</p:documentation>
   
	<!-- INPUT PORTS -->
  <p:input port="source" primary="true">
  	<p:document href="../input/table.docx" />
  </p:input>
   
	<!-- OUTPUT PORTS -->
	<p:output port="result" primary="true" />

	<p:declare-step type="dxt:get-ooxml-content" name="get-ooxml-content">

		<!-- INPUT PORTS -->
		<p:input port="source" primary="true" />
		
		<!-- OUTPUT PORTS -->
		<p:output port="result" primary="true" />
		
		<p:for-each>
			<p:with-input select="('document', 'styles', 'footnotes', 'comments')"/>
			<p:variable name="content" select="." />
			
			<dxd:get-ooxml-content content="{$content}" p:message="Getting: {$content}">
				<p:with-input port="source" pipe="source@get-ooxml-content" />
			</dxd:get-ooxml-content>
			
			<p:store href="../output/table/get-ooxml-content-{$content}.xml" serialization="map{'indent' : true()}" />
			
			<p:identity>
				<p:with-input pipe="result-uri"/>
			</p:identity>
			
		</p:for-each>
		
		<p:wrap-sequence wrapper="c:results" />
		
	</p:declare-step>
	
	<p:declare-step type="dxt:docx-to-xml">
		
		<!-- INPUT PORTS -->
		<p:input port="source" primary="true" />
		
		<!-- OUTPUT PORTS -->
		<p:output port="result" primary="true" />
		
		<dxd:docx-to-xml clean-markup="true" keep-direct-formatting="true" />
		<p:store href="../output/table/docx-to-xml.xml" serialization="map{'indent' : true()}" />
		<p:identity>
			<p:with-input pipe="result-uri"/>
		</p:identity>
	</p:declare-step>
	
	<!-- PIPELINE BODY -->

	<dxt:get-ooxml-content />
	<dxt:docx-to-xml>
		<p:with-input port="source" pipe="source@test" />
	</dxt:docx-to-xml>

</p:declare-step>
