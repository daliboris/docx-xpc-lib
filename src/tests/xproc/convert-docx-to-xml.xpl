<p:declare-step 
	xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	version="3.0">
	
	<p:import href="../../xproc/docx-xpc-lib.xpl" />
	
	<p:documentation>
		<xhtml:section>
			<xhtml:h2></xhtml:h2>
			<xhtml:p></xhtml:p>
		</xhtml:section>
	</p:documentation>
   
	<!--
   >>>>>>>>>>>>>>>>>
   >> INPUT PORTS >>
   >>>>>>>>>>>>>>>>>
  -->
  <p:input port="source" primary="true">
  	<p:document href="." />
  </p:input>
   
	<!--
   <<<<<<<<<<<<<<<<<<
   << OUTPUT PORTS <<
   <<<<<<<<<<<<<<<<<<
  -->
	<p:output port="result" primary="true" />
	
	<!--
   +++++++++++++
   ++ OPTIONS ++
   +++++++++++++
  -->
	<p:option name="debug-path" as="xs:anyURI?" select="()" />
	<p:option name="base-uri" as="xs:anyURI" select="static-base-uri()" />
	<p:option name="clean-markup" as="xs:boolean" select="true()" />
	<p:option name="keep-direct-formatting" as="xs:boolean" select="true()" />
	<p:option name="output-file-path" as="xs:anyURI?" select="()" />
	
	<!--
   ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
   ÷÷ VARIABLES ÷÷
   ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
  -->
	<p:variable name="debug" as="xs:boolean" select="$debug-path || '' ne ''" />
	<p:variable name="debug-path-uri" as="xs:anyURI?" select="if(empty($debug-path)) 
		then () 
		else p:urify($debug-path, $base-uri)" />
      <p:variable name="output-file-path-uri" select="p:urify($output-file-path)" />
	<!--
   *******************
   ** PIPELINE BODY **
   *******************
  -->
	<dxd:docx-to-xml clean-markup="true" keep-direct-formatting="true" debug-path="../_debug" base-uri="{$base-uri}" />
	
	<p:store href="{$output-file-path-uri}" />
      
      <p:identity>
            <p:with-input pipe="result-uri" />
      </p:identity>

</p:declare-step>
