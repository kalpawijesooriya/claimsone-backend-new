<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Reports" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>Print preview of the outstanding reports region</description>
    ///  <copyRight>Copyright (c) 2013</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2016-12-07</createdOn>
    ///  <author>Uthpala Pathirana</author>
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
    <title>Site Visit Monitoring Report Print Preview</title>
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
           string DateFrom, DateTo, VehicleNo, JobNo, TOCode, TOName, Region, RName = "";

           DateFrom = ((VisitedTimeDifferenceModel)TempData["searchModel"]).DateFrom != null
                    ? ((VisitedTimeDifferenceModel)TempData["searchModel"]).DateFrom.Value.ToString("MM/dd/yyyy") : "Any";

           DateTo = ((VisitedTimeDifferenceModel)TempData["searchModel"]).DateTo != null
                  ? ((VisitedTimeDifferenceModel)TempData["searchModel"]).DateTo.Value.ToString("MM/dd/yyyy") : "Any";

           VehicleNo = ((VisitedTimeDifferenceModel)TempData["searchModel"]).VehicleNo != null
                     ? ((VisitedTimeDifferenceModel)TempData["searchModel"]).VehicleNo : "--";

           JobNo = ((VisitedTimeDifferenceModel)TempData["searchModel"]).JobNo != null
                 ? ((VisitedTimeDifferenceModel)TempData["searchModel"]).JobNo : "--";

           TOCode = ((VisitedTimeDifferenceModel)TempData["searchModel"]).TOCode != null
                   ? ((VisitedTimeDifferenceModel)TempData["searchModel"]).TOCode : "Any";

           if (((VisitedTimeDifferenceModel)TempData["searchModel"]).Name != null)
           {
               TOName = ((VisitedTimeDifferenceModel)TempData["searchModel"]).Name != "-1"
                   ? ((VisitedTimeDifferenceModel)TempData["searchModel"]).Name : "Any";
           }
           else
           {
               TOName = ((VisitedTimeDifferenceModel)TempData["searchModel"]).Name != null
                   ? ((VisitedTimeDifferenceModel)TempData["searchModel"]).Name : "Any";
           }

           if (String.IsNullOrWhiteSpace(((VisitedTimeDifferenceModel)TempData["searchModel"]).RegionName) || (((VisitedTimeDifferenceModel)TempData["searchModel"]).RegionName == ""))
               Region = "Any";

           Region = ((VisitedTimeDifferenceModel)TempData["searchModel"]).RegionName != "-1"
                      ? ((VisitedTimeDifferenceModel)TempData["searchModel"]).RegionName : "Any";

           RName = String.IsNullOrWhiteSpace(((VisitedTimeDifferenceModel)TempData["searchModel"]).RName) ? "" : ((VisitedTimeDifferenceModel)TempData["searchModel"]).RName + " - ";
    %>
    <form name="printForm">
    <div style="margin: 10px;">
        <h3>
            Site Visit Monitoring Report
        </h3>
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
            <tr>
                <td>
                    <b>
                        <%: Resources.info_gen_csrName%></b>
                </td>
                <td>
                    <%: TOName%>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_region%></b>
                </td>
                <td>
                    <%: RName%>
                    <%: Region %>
                </td>
            </tr>
        </tbody>
    </table>
    <div style="height: 15px;">
    </div>
    <table id="AllJobsTableView3" class="table table-bordered table-condensed">
        <thead>
            <tr>
                <th style="width: 10%">
                    <%: Resources.info_gen_csrCode%>
                </th>
                <th style="width: 20%">
                    <%: Resources.info_gen_nameOfTheCSR%>
                </th>
                <th style="width: 12%">
                    <%: Resources.info_gen_vehicleNo%>
                </th>
                <th style="width: 13%">
                    <%: Resources.info_gen_jobNo%>
                </th>
                <th style="width: 15%">
                    <%: Resources.info_gen_assignedTime%>
                </th>
                <th style="width: 15%">
                    <%: Resources.info_gen_timeVisited%>
                </th>
                <th style="width: 15%">
                    <%: Resources.info_gen_TimeDifference%>
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
                    <%: item.TOCode %>
                </td>
                <td>
                    <%: (item.Name == null) ? " " : item.Name%>
                </td>
                <td>
                    <%: item.VehicleNo%>
                </td>
                <td>
                    <%: item.JobNo%>
                </td>
                <td>
                    <%: item.AssignedTimeDisplay%>
                </td>
                <td>
                    <%: item.VisitedTimeDisplay%>
                </td>
                <td>
                    <%: item.TimeDifference%>
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
