<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:dlb="https://www.daliboris.cz/ns/xproc/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
	version="3.0" name="extract-ooxml">
   
		<p:import href="../../xproc/docx-xpc-lib.xpl" />
   
  <p:input port="source" primary="true" href="../input/docx-with-formatting.docx" />
   
		<p:output port="result" serialization="map{'indent' : true()}" />
	<dxd:get-document />
	<p:store href="../output/get-document.xml" serialization="map{'indent' : true()}" />
	
	<p:identity>
		<p:with-input pipe="result-uri"/>
	</p:identity>
	
</p:declare-step>