<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<div>
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>job data result table page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-20</createdOn>
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
        $(document).ready(function () {
            var actionUrl = '<%: Html.ActionLink(" ", "CommentsListAjaxHandler2", "Job", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');            
            var jNo = "J001";

            var oTable = $('#CommentsTable').dataTable({
                "bJQueryUI": false,
                "bServerSide": true,
                "bProcessing": true,
                "sAjaxSource": actionUrl,
                "bDestroy": true,
                "iDisplayLength": 100,
                "fnServerParams": function (aoData) {
                    aoData.push({ "name": "jobNo", "value": jNo });
                },
                "aoColumns": [
                    {
                        "sName": "visitType",
                        "bSearchable": false,
                        "bSortable": true
                    },
                    {
                        "sName": "dateTime",
                        "bSearchable": true,
                        "bSortable": true
                    },
                    {
                        "sName": "commentedBy",
                        "bSearchable": true,
                        "bSortable": true
                    },
                    {
                        "sName": "comment",
                        "bSearchable": true,
                        "bSortable": true
                    }]
            }).rowGrouping({ bExpandableGrouping: true });
        });
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
</div>
