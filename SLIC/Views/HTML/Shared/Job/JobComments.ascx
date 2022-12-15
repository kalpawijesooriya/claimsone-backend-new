<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>job comments view page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2013-01-06</createdOn>
    ///  <author>Suren Manawatta</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
%>
<script src="../../../../Content/js/media/js/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="../../../../Content/js/media/js/TableTools.min.js" type="text/javascript"></script>
<script src="../../../../Content/js/media/js/ZeroClipboard.js" type="text/javascript"></script>
<script src="../../../../Scripts/jquery.dataTables.rowGrouping.js" type="text/javascript"></script>
<script src="../../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.js"
    type="text/javascript"></script>
<link href="../../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.css"
    rel="stylesheet" type="text/css" />
<script type="text/javascript">
</script>
<table id="CommentsTable" class="table table-striped table-bordered table-highlight">
    <thead>
        <tr>
            <th>
                <%:Resources.info_gen_visitType%>
            </th>
            <th>
                <%:Resources.info_gen_commentedDate%>
            </th>
            <th>
                <%:Resources.info_gen_commentedBy%>
            </th>
            <th>
                <%:Resources.info_gen_comment%>
            </th>
        </tr>
    </thead>
    <tbody>
    </tbody>
</table>
