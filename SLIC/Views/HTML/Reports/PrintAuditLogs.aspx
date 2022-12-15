<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<List<com.IronOne.SLIC2.Models.Reports.AccessLogModel>>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Reports" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
        /// <summary>
        /// 
        ///  <title>SLIC2</title>
        ///  <description>Print preview of the audit log</description>
        ///  <copyRight>Copyright (c) 2013</copyRight>
        ///  <company>IronOne Technologies (Pvt) Ltd</company>
        ///  <createdOn>2013-04-09</createdOn>
        ///  <author>Maduranga Gunasekara</author>
        ///  <modification>
        ///     <modifiedBy></modifiedBy>
        ///      <modifiedDate></modifiedDate>
        ///     <description></description>
        ///  </modification> 
        ///
        /// </summary>                                                                                 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%--Styles--%>
    <link href="../../../Content/css/bootstrap.css" rel="stylesheet" />
    <link href="../../../Content/css/bootstrap-overrides.css" rel="stylesheet" />
    <title>
        <%: Resources.info_gen_accessLogReport%></title>
    <script type="text/javascript">
        function HideAndPrint() {
            document.printForm.PrintButton.style.visibility = 'hidden';
            document.printForm.PrintButton.disabled = 'true';
            window.print();
            return;
        }
    </script>
</head>
<body style="background: none">
    <% if ((TempData["searchModel"]) != null)
       {
           string DateFrom, DateTo, TimeFrom, TimeTo, VehicleNo, JobNo, CSRCode, Username, Branch, Region, InspectionType, EPFNo;

           DateFrom = ((AccessLogModel)TempData["searchModel"]).DateFrom != null
                    ? ((AccessLogModel)TempData["searchModel"]).DateFrom.Value.ToString("MM/dd/yyyy") : "Any";

           DateTo = ((AccessLogModel)TempData["searchModel"]).DateTo != null
                  ? ((AccessLogModel)TempData["searchModel"]).DateTo.Value.ToString("MM/dd/yyyy") : "Any";

           //TimeFrom = ((AccessLogModel)TempData["searchModel"]).TimeFrom != null
           //         ? ((AccessLogModel)TempData["searchModel"]).TimeFrom.Value.ToString("hh:mm tt") : "Any";

           //TimeTo = ((AccessLogModel)TempData["searchModel"]).TimeTo != null
           //       ? ((AccessLogModel)TempData["searchModel"]).TimeTo.Value.ToString("hh:mm tt") : "Any";

           VehicleNo = ((AccessLogModel)TempData["searchModel"]).VehicleNo != null
                     ? ((AccessLogModel)TempData["searchModel"]).VehicleNo : "--";

           JobNo = ((AccessLogModel)TempData["searchModel"]).JobNo != null
                 ? ((AccessLogModel)TempData["searchModel"]).JobNo : "--";

           CSRCode = ((AccessLogModel)TempData["searchModel"]).CSRCode != null
                   ? ((AccessLogModel)TempData["searchModel"]).CSRCode : "--";

           Username = ((AccessLogModel)TempData["searchModel"]).Username != null
                   ? ((AccessLogModel)TempData["searchModel"]).Username : "--";

           Branch = ((AccessLogModel)TempData["searchModel"]).BranchName != "-1"
                      ? ((AccessLogModel)TempData["searchModel"]).BranchName : "Any";

           Region = ((AccessLogModel)TempData["searchModel"]).RegionName != "-1"
                      ? ((AccessLogModel)TempData["searchModel"]).RegionName : "Any";

           InspectionType = ((AccessLogModel)TempData["searchModel"]).InspectionTypeName != "-1"
                   ? ((AccessLogModel)TempData["searchModel"]).InspectionTypeName : "Any";

           EPFNo = ((AccessLogModel)TempData["searchModel"]).EFPNo != null
                   ? ((AccessLogModel)TempData["searchModel"]).EFPNo : "--";
    %>
    <form name="printForm">
    <div style="margin: 10px;">
        <h3>
            <%: Resources.info_gen_accessLogReport%></h3>
    </div>
    <table class="table table-bordered table-condensed">
        <thead>
            <tr>
                <th colspan="4">
                    <b>
                        <%: Resources.info_gen_searchCriteria%></b>&nbsp;&nbsp;&nbsp;
                    <input class="btn btn-primary btn-small" type="button" name="PrintButton" onclick="HideAndPrint();"
                        value="<%: Resources.info_gen_printReport%>" />
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <b>
                        <%: Resources.info_gen_dateFrom%></b>
                </td>
                <td>
                    <%: DateFrom %>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_dateTo%></b>
                </td>
                <td>
                    <%: DateTo %>
                </td>
            </tr>
            <%--<tr>
                <td>
                    <b>
                        <%: Resources.info_gen_timeFrom%></b>
                </td>
                <td>
                    <%: TimeFrom %>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_timeTo%></b>
                </td>
                <td>
                    <%: TimeTo %>
                </td>
            </tr>--%>
            <tr>
                <td>
                    <b>
                        <%: Resources.info_gen_vehicleNo%></b>
                </td>
                <td>
                    <%: VehicleNo %>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_jobNo%></b>
                </td>
                <td>
                    <%: JobNo %>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <%: Resources.info_gen_csrCode%></b>
                </td>
                <td>
                    <%: CSRCode %>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_userName%></b>
                </td>
                <td>
                    <%: Username %>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <%: Resources.info_gen_branch%></b>
                </td>
                <td>
                    <%: Branch %>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_region%></b>
                </td>
                <td>
                    <%: Region %>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <%: Resources.info_gen_inspectionType%></b>
                </td>
                <td>
                    <%: InspectionType %>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_epfNo%></b>
                </td>
                <td>
                    <%: EPFNo %>
                </td>
            </tr>
        </tbody>
    </table>
    <div style="height: 15px;">
    </div>
    <table id="AllJobsTableView3" class="table table-bordered table-condensed">
        <thead>
            <tr>
                <th>
                    <b>
                        <%: Resources.info_gen_vehicleNo%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_jobNo%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_csrCode%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_userName%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_branch%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_inspectionType%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_action%></b>
                </th>
            </tr>
        </thead>
        <tbody>
            <% if (Model == null || Model.Count == 0)
               { %>
            <tr>
                <td>
                    <%: Resources.err_1000%>
            </tr>
            </td>
            <% }
               else
               {
                   foreach (var item in Model)
                   { %>
            <tr>
                <td>
                    <%: item.VehicleNo %>
                </td>
                <td>
                    <%: item.JobNo %>
                </td>
                <td>
                    <%: item.CSRCode%>
                </td>
                <td>
                    <%: item.Username%>
                </td>
                <td>
                    <%: item.BranchName%>
                </td>
                <td>
                    <%: item.InspectionTypeName%>
                </td>
                <td>
                    <%: item.Action%>
                </td>
            </tr>
            <% }
               } %>
        </tbody>
    </table>
    <div id="foo" class="span12">
        &nbsp; &copy;
        <%=DateTime.Now.Year %>
        <%:Resources.info_gen_copyright%>
        <span style="float: right">
            <%     
           if (ViewData["PrintUser"] != null)
           {
               com.IronOne.SLIC2.Models.Administration.UserDataModel printUser = (com.IronOne.SLIC2.Models.Administration.UserDataModel)ViewData["PrintUser"];%>
            <i>Printed by
                <%=printUser.FirstName%>
                <%=printUser.LastName%>
                |
                <%=printUser.EPFNo%>
                |
                <%=printUser.BranchName%>
            </i>
            <%   }%>
        </span>
    </div>
    </form>
    <% } %>
</body>
</html>
