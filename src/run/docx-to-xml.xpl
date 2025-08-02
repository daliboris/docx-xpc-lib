<p:declare-step 
	xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	version="3.0">
	
	<p:import href="../xproc/docx-xpc-lib.xpl" />
	
	<p:documentation>
		<xhtml:section>
			<xhtml:h2></xhtml:h2>
			<xhtml:p></xhtml:p>
		</xhtml:section>
	</p:documentation>
   
	<!-- INPUT PORTS -->
  <p:input port="source" primary="true" />
   
	<!-- OUTPUT PORTS -->
	<p:output port="result" primary="true" />
	
	<!-- OPTIONS -->
	<p:option name="debug-path" select="()" as="xs:string?" />
	<p:option name="base-uri" as="xs:anyURI" select="static-base-uri()"/>
	
	<p:option name="clean-markup" as="xs:boolean" select="false()" />
	<p:option name="keep-direct-formatting" as="xs:boolean" select="false()" />

	<p:option name="output-directory-path" select="()" as="xs:anyURI?" />
	<p:option name="input-filename-pattern" select="()" as="xs:string?" />
	

	<!-- VARIABLES -->
	<p:variable name="debug" select="$debug-path || '' ne ''" />
	<p:variable name="debug-path-uri" select="if(empty($debug-path)) then () else p:urify($debug-path, $base-uri)" />
	
	<p:variable name="file-directory" select="tokenize(base-uri(/), '/')[position() lt last()] => string-join('/')" />
	<p:variable name="output-directory-path-uri" select="if(empty($output-directory-path))
		then $file-directory
	  else p:urify($output-directory-path, $base-uri)" />
	<p:variable name="extension" select="tokenize(base-uri(/), '/')[last()] => substring-after('.')" />
	<p:variable name="file-stem" select="tokenize(base-uri(/), '/')[last()] => substring-before('.')" />
	

	<!-- PIPELINE BODY -->
	
	
	<p:identity message=":-------------------------------------" />
	<p:identity message="::          DOCX to XML             ::" />
	<p:identity message=":-------------------------------------" />
	<p:identity message=":: + file path:                {$file-directory}/{$file-stem}.{$extension}" />
	<p:identity message=":: + output directory:         {$output-directory-path-uri}" />
	<p:identity message=":: + clean markup:             {$clean-markup}" />
	<p:identity message=":: + keep direct formatting:   {$keep-direct-formatting}" />
	<p:identity message=":: + debug path:               {$debug-path-uri}" />
	<p:identity message=":-------------------------------------" />
	<p:identity message=": >>> starting " />
	
	
	<dxd:docx-to-xml clean-markup="{$clean-markup}" keep-direct-formatting="{$keep-direct-formatting}" debug-path="{$debug-path}" base-uri="{$base-uri}" />
	
	<p:if test="exists($output-directory-path-uri)">
		<p:store href="{$output-directory-path-uri}/{$file-stem}.xml" serialization="map{'indent' : true()}" />	
	</p:if>
	
	<p:identity message=": >>> finished " />
	<p:identity message=":-------------------------------------" />
	<p:identity message="::           DOCX to XML            ::" />
	<p:identity message=":-------------------------------------" />
	<p:identity message="" />

</p:declare-step>
