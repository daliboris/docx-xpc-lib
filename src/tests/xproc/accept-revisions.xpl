<p:declare-step 
	xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
	xmlns:dxt="https://www.daliboris.cz/ns/xproc/test"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	version="3.0">
	
	<p:import href="../../xproc/docx-xpc-lib.xpl" />
	
	<p:documentation>
		<xhtml:section>
			<xhtml:h2></xhtml:h2>
			<xhtml:p></xhtml:p>
		</xhtml:section>
	</p:documentation>
   
	<!-- INPUT PORTS -->
  <p:input port="source" primary="true" sequence="true">
  	<p:document href="../input/revisions.docx" />
  	<p:document href="../input/revisions.xml" />
  	<p:document href="../input/revisions-essc.xml" />
  </p:input>
   
	<!-- OUTPUT PORTS -->
	<p:output port="result" primary="true" sequence="true" />
	
	<!-- OPTIONS -->
	<p:option name="debug-path" select="'../_debug'" as="xs:string?" />
	<p:option name="base-uri" as="xs:anyURI" select="static-base-uri()"/>
	
	<!-- VARIABLES -->
	<p:variable name="debug" select="$debug-path || '' ne ''" />
	<p:variable name="debug-path-uri" select="resolve-uri($debug-path, $base-uri)" />
	
	<!-- PIPELINE BODY -->
	
	<p:for-each>
		<p:variable name="full-path" select="p:document-property(., 'base-uri')" />
		<p:variable name="name" select="tokenize($full-path, '/')[last()]" />
		<dxd:process-revisions operation="accept" p:message="Processing {$name}" debug-path="{$debug-path}" base-uri="{$base-uri}"/>
		<p:store href="../output/{$name}" message="Storing to ../output/{$name}" />
		<p:identity>
			<p:with-input pipe="result-uri" />
		</p:identity>
	</p:for-each>
	

</p:declare-step>
