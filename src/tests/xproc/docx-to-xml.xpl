<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
	name="docx-to-xml"
	version="3.0">
   
	<p:import href="../../xproc/docx-xpc-lib.xpl" />
	
	<p:input port="source" primary="true" href="../input/docx-with-formatting.docx" />

	<p:output port="result" serialization="map{'indent' : true()}" />
	
	<dxd:docx-to-xml clean-markup="true" keep-direct-formatting="true"/>
	
	<p:store href="../output/docx-to-xml-clean-markup-keep-dirext-formatting.xml" />

	<dxd:docx-to-xml clean-markup="false" keep-direct-formatting="false">
		<p:with-input port="source" pipe="source@docx-to-xml" />
	</dxd:docx-to-xml>
	<p:store href="../output/docx-to-xml.xml" />

	<p:identity>
		<p:with-input pipe="result-uri"/>
	</p:identity>
	

</p:declare-step>
