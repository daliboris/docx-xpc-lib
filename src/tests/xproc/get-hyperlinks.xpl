<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
	xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
	version="3.0">

 <p:import href="../../xproc/docx-xpc-lib.xpl" />

 <p:input port="source" primary="true" href="../input/hyperlinks.docx" />
 

 <p:output port="result" serialization="map{'indent' : true()}" sequence="true" />
	
 <dxd:get-hyperlinks />
 
 <p:wrap-sequence wrapper="rel:Relationships" />
 <p:store href="../output/hyperlinks.xml" />

</p:declare-step>
