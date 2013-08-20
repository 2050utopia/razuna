<!---
*
* Copyright (C) 2005-2008 Razuna
*
* This file is part of Razuna - Enterprise Digital Asset Management.
*
* Razuna is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Razuna is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero Public License for more details.
*
* You should have received a copy of the GNU Affero Public License
* along with Razuna. If not, see <http://www.gnu.org/licenses/>.
*
* You may restribute this Program with a special exception to the terms
* and conditions of version 3.0 of the AGPL as described in Razuna's
* FLOSS exception. You should have received a copy of the FLOSS exception
* along with Razuna. If not, see <http://www.razuna.com/licenses/>.
*
--->
<cfoutput>
<cfcontent reset="true">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" >
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" >
<head>
<title>Razuna - the open source alternative to Digital Asset Management</title>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<!--- Control the cache
<cfheader name="Expires" value="#GetHttpTimeString(DateAdd('d', 1, Now()))#">
<cfheader name="PRAGMA" value="#GetHttpTimeString(DateAdd('d', 1, Now()))#"> --->
<meta http-equiv="X-UA-Compatible" content="chrome=1">
<cfheader name="Expires" value="#GetHttpTimeString(Now())#">
<cfheader name="CACHE-CONTROL" value="NO-CACHE, no-store, must-revalidate">
<cfheader name="PRAGMA" value="#GetHttpTimeString(Now())#">
<link rel="SHORTCUT ICON" href="favicon.ico" />
<script language="JavaScript" type="text/javascript">var dynpath = '#dynpath#';</script>
<!--- CSS --->
<link rel="stylesheet" type="text/css" href="views/layouts/login.css" />
<link rel="stylesheet" type="text/css" href="views/layouts/error.css" />
<!--- JS --->
<script type="text/javascript" src="#dynpath#/global/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="#dynpath#/global/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="#dynpath#/global/js/jquery.form.js"></script>
<script type="text/javascript" src="js/login.js"></script>
<script type="text/javascript" src="js/global.js"></script>
</head>
<body>
<div id="container">
#trim( thecontent )#
</div>
</body>
</html>
</cfoutput>