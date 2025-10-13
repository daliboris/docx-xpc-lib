<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dxd="https://www.daliboris.cz/ns/xproc/docx" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0">

	<p:import href="../xproc/docx-xpc-lib.xpl" />

	<p:documentation>
		<xhtml:section>
			<xhtml:h2 />
			<xhtml:p />
		</xhtml:section>
	</p:documentation>


	<!-- OUTPUT PORTS -->
	<p:output port="result" primary="true" sequence="false" serialization="map {'indent' : true()} "  />

	<!-- OPTIONS -->
	<p:option name="debug-path" as="xs:string?" select="()" />
	<p:option name="base-uri" as="xs:anyURI" select="static-base-uri()" />

	<p:option name="clean-markup" as="xs:boolean" select="false()" />
	<p:option name="keep-direct-formatting" as="xs:boolean" select="false()" />
	<p:option name="max-depth" as="xs:string" select="'1'" />

	<p:option name="input-directory-path" as="xs:anyURI" select="()" />
	<p:option name="output-directory-path" as="xs:anyURI?" select="()" />
	<p:option name="input-filename-pattern" as="xs:string?" select="'^.*\.[Dd][Oo][Cc][Xx]$'" />

	<!-- VARIABLES -->
	<p:variable name="include-filter" select="if(empty($input-filename-pattern)) 
		then '^.*\.[Dd][Oo][Cc][Xx]$' 
		else $input-filename-pattern" />
	<p:variable name="file-name-regex" select="'^(.*)(\..[^\.]*)$'" />

	<p:variable name="input-directory-path-uri" select="resolve-uri(p:urify($input-directory-path), $base-uri)" />
	<p:variable name="output-directory-path-uri" select="if(empty($output-directory-path))
		then resolve-uri(p:urify($input-directory-path), $base-uri)
		else resolve-uri(p:urify($output-directory-path), $base-uri)" />
	<p:variable name="debug-path-uri" select="if(empty($debug-path)) then () else resolve-uri(p:urify($debug-path), $base-uri)" />

	<p:directory-list path="{$input-directory-path-uri}" include-filter="{$include-filter}" max-depth="{$max-depth}" />
	<p:if test="exists($debug-path-uri)">
		<p:store href="{$debug-path-uri}/docx-directory-to-xml-files-01.xml" />
	</p:if>
	<p:viewport match="c:file">
		<p:variable name="base" select="/c:file/@xml:base" />
		<p:add-attribute attribute-name="full-path" attribute-value="{$base}" match="c:file" />
		<p:add-attribute attribute-name="extension" attribute-value="{replace($base, $file-name-regex, '$2')}" match="c:file" />
		<p:add-attribute attribute-name="stem" attribute-value="{replace($base, $file-name-regex, '$1')}" match="c:file" />
	</p:viewport>
	<p:make-absolute-uris match="@full-path" />
	<p:variable name="root-directory" select="/c:directory/@xml:base" />
	<p:viewport match="c:file">
		<p:variable name="full-path" select="/c:file/@full-path" />
		<p:variable name="relative-path" select="substring-after($full-path, $root-directory)" />
		<p:variable name="relative-path" select="substring-before($relative-path, /c:file/@xml:base)" />
		<p:add-attribute attribute-name="relative-path" attribute-value="{$relative-path}" match="c:file" />
	</p:viewport>
	<p:if test="exists($debug-path-uri)">
		<p:store href="{$debug-path-uri}/docx-directory-to-xml-files-02.xml" />
	</p:if>

	<p:identity message=":-------------------------------------" />
	<p:identity message="::      DOCX directory to XML       ::" />
	<p:identity message=":-------------------------------------" />
	<p:identity message=":: + input directory:          {$input-directory-path-uri}" />
	<p:identity message=":: + maximum depth:            {$max-depth}" />
	<p:identity message=":: + output directory:         {$output-directory-path-uri}" />
	<p:identity message=":: + clean markup:             {$clean-markup}" />
	<p:identity message=":: + keep direct formatting:   {$keep-direct-formatting}" />
	<p:identity message=":: + debug path:               {$debug-path-uri}" />
	<p:identity message=":-------------------------------------" />
	<p:identity message=": >>> starting " />
	<p:for-each>
		<p:output port="result" pipe="result-uri@storing" />
		<p:with-input select="//c:file" />
		<p:variable name="stem" select="/c:file/@stem" />
		<p:variable name="relative-path" select="/c:file/@relative-path" />
		<p:variable name="output-file-name" select="$stem || '.xml'" />
		<p:load href="{/c:file/@full-path}" message=": ... processing document '{/c:file/@name}'"/>
		<dxd:docx-to-xml clean-markup="{$clean-markup}" keep-direct-formatting="{$keep-direct-formatting}" debug-path="{$debug-path}" base-uri="{$base-uri}" />
		<p:store href="{$output-directory-path-uri}/{$relative-path}{$output-file-name}" name="storing" />
	</p:for-each>

	<p:wrap-sequence wrapper="c:result" />
	<p:identity message=": >>> finished " />
	<p:identity message=":-------------------------------------" />
	<p:identity message="::      DOCX directory to XML       ::" />
	<p:identity message=":-------------------------------------" />
	<p:identity message="" />
	
</p:declare-step>
