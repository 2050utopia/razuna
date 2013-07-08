<!--- This URL --->
<cfset thisurl = "http://" & cgi.http_host>
<!--- Storage Decision --->
<!---
<cfif application.razuna.storage EQ "nirvanix">
	<cfset thestorage = "#application.razuna.nvxurlservices#/#attributes.nvxsession#/razuna/#session.hostid#/">
<cfelse>
--->
	<cfset thestorage = "#thisurl##cgi.context_path#/assets/#session.hostid#/">
<!--- </cfif> --->
<!--- The filename --->
<cfset pdfname = "Razuna-" & dateformat(now(),"mmddyyyy") & "-" & qry_files.folder_id_r & ".pdf">
<!--- Page Decision --->
<cfswitch expression="#attributes.format#">
	<cfcase value="9,12">
		<cfset thebreak = 2>
	</cfcase>
	<cfcase value="16">
		<cfset thebreak = 4>
	</cfcase>
	<cfcase value="25">
		<cfset thebreak = 5>
	</cfcase>
</cfswitch>
<cfinvoke component="global.cfc.cfmlengine" method="printPdf" >
	<cfinvokeargument name="name" value="content-disposition">
	<cfinvokeargument name="value" value="filename=#pdfname#">
</cfinvoke>
<cfdocument format="pdf" pagetype="#attributes.pagetype#" saveasname="#pdfname#" overwrite="true">

<cfinvoke component="global.cfc.cfmlengine" method="printPdfHeader" >
	<cfinvokeargument name="header" value="#attributes.header#">
</cfinvoke>

<cfif isDefined("cfdocument")>
	<cfinvoke component="global.cfc.cfmlengine" method="printPdfFooter" >
		<cfinvokeargument name="footer" value="#attributes.footer#">
		<cfinvokeargument name="currentpage" value="#cfdocument.currentpagenumber#">
		<cfinvokeargument name="totalpages" value="#cfdocument.totalpagecount#">
	</cfinvoke>
</cfif>
<cfoutput>
<style>
@page{
	@top-center {
		content: "Razuna http://razuna.com #attributes.header#";
	}
	@bottom-center {
		content: "Page " counter(page) " of " counter(pages) "#attributes.footer#";
	}
}  
table {
	-fs-table-paginate: paginate;
}
.breakhere {
	page-break-before: always
}
</style>
<!--- View: Thumbnails --->
<cfif attributes.view EQ "thumbnails">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<!--- Assets --->
		<tr>
		<cfloop query="qry_files">
			<td height="100%" valign="top" align="center">
				<table border="0" cellpadding="0" cellspacing="0" style="padding-bottom:20px;" width="100%">
					<!--- Images --->
					<cfif kind EQ "img">
						<tr>
							<td height="100%" colspan="2" align="center"><cfif application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix"><img src="#cloud_url#" border="0"><cfelse><img src="#thestorage##path_to_asset#/thumb_#id#.#ext#" border="0" width="200px"></cfif></td>
						</tr>
						<tr>
							<td colspan="2">#left(filename,25)#</td>
						</tr>
						<tr>
							<td colspan="2">ID: #id#</td>
						</tr>
					<!--- Videos --->
					<cfelseif kind EQ "vid">
						<tr>
							<td height="100%" colspan="2" align="center"><cfif application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix"><img src="#cloud_url#" border="0" width="200px"><cfelse><img src="#thestorage##path_to_asset#/#filename_org#" border="0" width="200px"></cfif>
							<br>#myFusebox.getApplicationData().defaults.trans("file_detail")#</td>
							</tr>
						<tr>
							<td colspan="2">#left(filename,25)#</td>
						</tr>
						<tr>
							<td colspan="2">ID: #id#</td>
						</tr>
					<!--- Audios --->
					<cfelseif kind EQ "aud">
						<tr>
							<td height="100%" colspan="2" align="center"><img src="#thisurl#/global/host/dam/images/icons/icon_<cfif ext EQ "mp3" OR ext EQ "wav">#ext#<cfelse>aud</cfif>.png" width="128" height="128" border="0">
							<br>#myFusebox.getApplicationData().defaults.trans("file_detail")#</td>
							</tr>
						<tr>
							<td colspan="2">#left(filename,25)#</td>
						</tr>
						<tr>
							<td colspan="2">ID: #id#</td>
						</tr>
					<!--- All other files --->
					<cfelse>
						<tr>
							<td height="100%" colspan="2" align="center">
								<!--- If it is a PDF we show the thumbnail --->
								<cfif (application.razuna.storage EQ "nirvanix" OR application.razuna.storage EQ "amazon") AND ext EQ "PDF">
									<cfset thethumb = replacenocase(filename_org, ".pdf", ".jpg", "all")>
									<img src="#cloud_url#" width="128" height="128" border="0">
								<cfelseif application.razuna.storage EQ "local" AND ext EQ "PDF">
									<cfset thethumb = replacenocase(filename_org, ".pdf", ".jpg", "all")>
									<cfif NOT FileExists("#attributes.assetpath#/#session.hostid#/#path_to_asset#/#thethumb#")>
										<img src="#thisurl##dynpath#/global/host/dam/images/icons/icon_#ext#.png" width="128" height="128" border="0">
									<cfelse>
										<img src="#thestorage##path_to_asset#/#thethumb#" width="128" border="0">
									</cfif>
								<cfelse>
									<cfif NOT FileExists("#ExpandPath("../../")#global/host/dam/images/icons/icon_#ext#.png")><img src="#thisurl##dynpath#/global/host/dam/images/icons/icon_txt.png" width="128" height="128" border="0"><cfelse><img src="#thisurl##dynpath#/global/host/dam/images/icons/icon_#ext#.png" width="128" height="128" border="0"></cfif>
								</cfif>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">#left(filename,25)#</td>
						</tr>
					</cfif>
				</table>
				<cfif currentrow mod attributes.format EQ 0>
					<div class="breakhere">&nbsp;</div>
				</cfif>
			</td>
			<cfif currentrow mod thebreak EQ 0>
				</tr>
				<cfif qry_files.recordcount GT currentrow><tr></cfif>
			</cfif>
		</cfloop>
	</table>
<!--- View: List --->
<cfelseif attributes.view EQ "list">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<cfloop query="qry_files">
			<tr>
				<!--- Icon/Image --->
				<td valign="top" style="padding-bottom:20px;padding-right:20px;">
					<cfif kind EQ "img">
						<cfif application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix"><img src="#cloud_url#" border="0" width="300px"><cfelse><img src="#thestorage##path_to_asset#/thumb_#id#.#ext#" border="0" width="300px"></cfif>
					<!--- Videos --->
					<cfelseif kind EQ "vid">
						<cfif application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix"><img src="#cloud_url#" border="0" width="300px"><cfelse><img src="#thestorage##path_to_asset#/#filename_org#" border="0" width="300px"></cfif>
					<!--- Audios --->
					<cfelseif kind EQ "aud">
						<img src="#thisurl#/global/host/dam/images/icons/icon_<cfif ext EQ "mp3" OR ext EQ "wav">#ext#<cfelse>aud</cfif>.png" width="128" height="128" border="0">
					<!--- All other files --->
					<cfelse>
						<cfif (application.razuna.storage EQ "nirvanix" OR application.razuna.storage EQ "amazon") AND ext EQ "PDF">
							<img src="#cloud_url#" width="128" height="128" border="0">
						<cfelseif application.razuna.storage EQ "local" AND ext EQ "PDF">
							<cfset thethumb = replacenocase(filename_org, ".pdf", ".jpg", "all")>
							<cfif NOT FileExists("#attributes.assetpath#/#session.hostid#/#path_to_asset#/#thethumb#")>
								<img src="#thisurl##dynpath#/global/host/dam/images/icons/icon_#ext#.png" width="128" height="128" border="0">
							<cfelse>
								<img src="#thestorage##path_to_asset#/#thethumb#" width="128" border="0">
							</cfif>
						<cfelse>
							<cfif FileExists("#ExpandPath("../../")#global/host/dam/images/icons/icon_#ext#.png") IS "no"><img src="#thisurl##dynpath#/global/host/dam/images/icons/icon_txt.png" width="128" height="128" border="0"><cfelse><img src="#thisurl##dynpath#/global/host/dam/images/icons/icon_#ext#.png" width="128" height="128" border="0"></cfif>
						</cfif>
					</cfif>
				</td>
				<!--- Text --->
				<td valign="top" width="100%" style="padding-bottom:20px;">
					<strong>#filename#</strong><br />
					<cfif attributes.kind NEQ "all">
						<cfset theid = id>
						<cfloop query="qry_files_text">
							<cfif theid EQ tid>
								<cfset description = description>
								<cfset keywords = keywords>
							</cfif>
						</cfloop>
					</cfif>
					#myFusebox.getApplicationData().defaults.trans("description")#: #description#<br />
					#myFusebox.getApplicationData().defaults.trans("keywords")#: #keywords#
				</td>
			</tr>
		</cfloop>
	</table>
<!--- View: Detail --->
<cfelseif attributes.view EQ "detail">
	<!--- Images --->
	<cfif attributes.thetype EQ "img">
		<!--- If width of org image is bigger then 600 --->
		<cfif qry_detail.detail.orgwidth GT 600>
			<cfset thewidth = 600>
		<cfelse>
			<cfset thewidth = qry_detail.detail.orgwidth>
		</cfif>
		<!--- Set vars --->
		<cfset filename_org = qry_detail.detail.img_filename_org>
		<cfset filename = qry_detail.detail.img_filename>
		<cfset description = qry_detail.desc.img_description>
		<cfset keywords = qry_detail.desc.img_keywords>
		<cfset width = qry_detail.detail.orgwidth>
		<cfset heigth = qry_detail.detail.orgheight>
		<cfset format = qry_detail.detail.orgformat>
		<cfset folderid = qry_detail.detail.folder_id_r>
	<!--- Videos --->
	<cfelseif attributes.thetype EQ "vid">
		<!--- If width of org image is bigger then 600 --->
		<cfif qry_detail.detail.vwidth GT 600>
			<cfset thewidth = 600>
		<cfelse>
			<cfset thewidth = qry_detail.detail.vwidth>
		</cfif>
		<!--- Set vars --->
		<cfset filename_org = qry_detail.detail.vid_name_image>
		<cfset filename = qry_detail.detail.vid_filename>
		<cfset description = qry_detail.desc.vid_description>
		<cfset keywords = qry_detail.desc.vid_keywords>
		<cfset width = qry_detail.detail.vwidth>
		<cfset heigth = qry_detail.detail.vheight>
		<cfset format = qry_detail.detail.vid_extension>
		<cfset folderid = qry_detail.detail.folder_id_r>
	<!--- Audios --->
	<cfelseif attributes.thetype EQ "aud">
		<cfset thewidth = 120>
		<!--- Set vars --->
		<cfset filename_org = qry_detail.detail.aud_name_org>
		<cfset filename = qry_detail.detail.aud_name>
		<cfset description = qry_detail.desc.aud_description>
		<cfset keywords = qry_detail.desc.aud_keywords>
		<cfset format = qry_detail.detail.aud_extension>
		<cfset folderid = qry_detail.detail.folder_id_r>
	<!--- Documents --->
	<cfelse>
		<!--- If width of org image is bigger then 600 --->
		<cfset thewidth = 128>
		<!--- Set vars --->
		<cfset filename_org = qry_detail.detail.file_name_org>
		<cfset filename = qry_detail.detail.file_name>
		<cfset description = qry_detail.desc.file_desc>
		<cfset keywords = qry_detail.desc.file_keywords>
		<cfset format = qry_detail.detail.file_extension>
		<cfset folderid = qry_detail.detail.folder_id_r>
	</cfif>
	<cfset path_to_asset = qry_detail.detail.path_to_asset>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td colspan="2" align="center" style="padding-bottom:20px;">
				<cfif attributes.thetype EQ "img" OR attributes.thetype EQ "vid">
					<cfif application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix"><img src="#qry_detail.detail.cloud_url#" border="0"><cfelse><img src="#thestorage##path_to_asset#/#filename_org#" border="0" width="#thewidth#"></cfif>
				<cfelseif attributes.thetype EQ "aud">
					<img src="#thisurl#/global/host/dam/images/icons/icon_<cfif format EQ "mp3" OR format EQ "wav">#format#<cfelse>aud</cfif>.png" border="0">
				<cfelse>
					<cfif (application.razuna.storage EQ "nirvanix" OR application.razuna.storage EQ "amazon") AND format EQ "PDF">
						<img src="#qry_detail.detail.cloud_url#" width="128" height="128" border="0">
					<cfelseif application.razuna.storage EQ "local" AND format EQ "PDF">
						<cfset thethumb = replacenocase(filename_org, ".pdf", ".jpg", "all")>
						<cfif FileExists("#attributes.assetpath#/#session.hostid#/#folderid#/doc/#attributes.file_id#/#thethumb#") EQ "no">
							<img src="#thisurl##dynpath#/global/host/dam/images/icons/icon_#format#.png" width="128" height="128" border="0">
						<cfelse>
							<img src="#thestorage##path_to_asset#/#thethumb#" width="128" border="0">
						</cfif>
					<cfelse>
						<cfif FileExists("#ExpandPath("../../")#global/host/dam/images/icons/icon_#format#.png") IS "no"><img src="#thisurl##dynpath#/global/host/dam/images/icons/icon_txt.png" width="128" height="128" border="0"><cfelse><img src="#thisurl##dynpath#/global/host/dam/images/icons/icon_#format#.png" width="128" height="128" border="0"></cfif>
					</cfif>
				</cfif>
			</td>
		</tr>
		<tr>
			<td nowrap="true" style="padding-right:10px;"><strong>#myFusebox.getApplicationData().defaults.trans("file_name")#</strong></td>
			<td width="100%">#filename#</td>
		</tr>
		<tr>
			<td valign="top" nowrap="true" style="padding-right:10px;"><strong>#myFusebox.getApplicationData().defaults.trans("description")#</strong></td>
			<td width="100%">#description#</td>
		</tr>
		<tr>
			<td valign="top" nowrap="true" style="padding-right:10px;"><strong>#myFusebox.getApplicationData().defaults.trans("keywords")#</strong></td>
			<td width="100%">#keywords#</td>
		</tr>
		<cfif attributes.thetype NEQ "doc">
			<tr>
				<td nowrap="true" style="padding-right:10px;"><strong>#myFusebox.getApplicationData().defaults.trans("size")#</strong></td>
				<td width="100%">#qry_detail.thesize# MB<cfif attributes.thetype NEQ "aud"> (#width#x#heigth#)</cfif></td>
			</tr>
		</cfif>
		<tr>
			<td nowrap="true" style="padding-right:10px;"><strong>#myFusebox.getApplicationData().defaults.trans("format")#</strong></td>
			<td width="100%">#ucase(format)#</td>
		</tr>
	</table>
</cfif>
</cfoutput>
</cfdocument>