<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
	name="docx-to-xml"
	version="3.0">
   
	<p:import href="../../xproc/docx-xpc-lib.xpl" />
	
	<p:input port="source" primary="true" href="../input/docx-with-formatting.docx" />

	<p:output port="result" serialization="map{'indent' : true()}" sequence="true" />
	
	<!-- OPTIONS -->
	<p:option name="debug-path" as="xs:anyURI?" select="()" />
	<p:option name="base-uri" as="xs:anyURI?" select="static-base-uri()"/>
	
	<dxd:docx-to-xml clean-markup="true" keep-direct-formatting="true" debug-path="../_debug" base-uri="{$base-uri}" />
	
	<p:store href="../output/docx-to-xml/clean-markup-keep-direct-formatting.xml" name="clean-and-keep" />
	
	<dxd:docx-to-xml clean-markup="false" keep-direct-formatting="true" >
		<p:with-input port="source" pipe="source@docx-to-xml" />
	</dxd:docx-to-xml>
	<p:store href="../output/docx-to-xml/docx-to-xml-keep-direct-formatting.xml" name="remove"/>

	<dxd:docx-to-xml clean-markup="false" keep-direct-formatting="false" >
		<p:with-input port="source" pipe="source@docx-to-xml" />
	</dxd:docx-to-xml>
	<p:store href="../output/docx-to-xml/docx-to-xml.xml" name="dirty-and-remove"/>

	<dxd:docx-to-xml clean-markup="false" keep-direct-formatting="false" >
		<p:with-input port="source" pipe="source@docx-to-xml" />
	</dxd:docx-to-xml>
	<p:store href="../output/docx-to-xml/docx-to-xml-debug.xml" name="dirty-and-remove-debug"/>
	

	<p:identity>
		<p:with-input pipe="result-uri@clean-and-keep result-uri@remove result-uri@dirty-and-remove result-uri@dirty-and-remove-debug"/>
	</p:identity>
	

</p:declare-step>
