<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
	name="docx-to-xml"
	version="3.0">
   
	<p:import href="../../xproc/docx-xpc-lib.xpl" />
	
	<p:input port="source" primary="true" href="../input/tabs.docx" />

	<p:output port="result" serialization="map{'indent' : true()}" />
	
	<dxd:docx-to-xml clean-markup="true" keep-direct-formatting="true"  debug="true"/>
	
	<p:store href="../output/tabs-clean-markup-keep-dirext-formatting.xml" />

	<dxd:docx-to-xml clean-markup="false" keep-direct-formatting="false" debug="true">
		<p:with-input port="source" pipe="source@docx-to-xml" />
	</dxd:docx-to-xml>
	<p:store href="../output/tabs.xml" />

	<p:identity>
		<p:with-input pipe="result-uri"/>
	</p:identity>
	

</p:declare-step>
