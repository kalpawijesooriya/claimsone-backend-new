<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<IEnumerable<com.IronOne.SLIC2.Models.Job.JobDataModel>>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>print preview page with export options</description>
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
    <script src="../../../Content/js/media/js/jquery.dataTables.js" type="text/javascript"></script>
    <script src="../../../Content/js/media/js/jquery.dataTables.min.js" type="text/javascript"></script>
    <script src="../../../Content/js/media/js/TableTools.min.js" type="text/javascript"></script>
    <script src="../../../Content/js/media/js/ZeroClipboard.js" type="text/javascript"></script>
    <link href="../../../Content/js/media/css/TableTools.css" rel="stylesheet" type="text/css" />
    <link href="../../../Content/js/media/css/TableTools_JUI.css" rel="stylesheet" type="text/css" />   
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <%:Resources.info_gen_printExportPage%>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%:Resources.info_gen_printExportPage%></h2>
    <table id="AllJobsTableView3">
        <thead>
            <tr>
                <th>
                    <%:Resources.info_gen_jobNo%>
                </th>
                <th>
                    <%:Resources.info_gen_printExportPage%>
                </th>
                <th>
                    <%:Resources.info_gen_vehicleNo%>
                </th>
                <th>
                    <%:Resources.info_gen_callerContactNo%>
                </th>
                <th>
                    <%:Resources.info_gen_vehicleDescription%>
                </th>
            </tr>
        </thead>
        <tbody>
            <% foreach (var item in Model)
               { %>
            <tr>
                <td>
                    <%: item.JobNo %>
                </td>
                <td>
                    <%: String.Format("{0:g}", item.TimeReported) %>
                </td>
                <td>
                    <%: item.VehicleNo %>
                </td>
                <td>
                    <%: item.Caller_ContactNo %>
                </td>
                <td>
                    <%: item.VehicleDescription %>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</asp:Content>
