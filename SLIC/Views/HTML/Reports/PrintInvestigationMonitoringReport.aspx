<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Reports" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>Print preview of the Investigation Monitoring Report</description>
    ///  <copyRight>Copyright (c) 2019</copyRight>
    ///  <company>Ellipsis (Pvt) Ltd</company>
    ///  <createdOn>2019-07-24</createdOn>
    ///  <author>Atheek Azmy</author>
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
           string DateFrom, DateTo, ACRFrom, ACRTo, TimeFrom, TimeTo, Relationship, FurtherReview;

           DateFrom = ((InvestigationMonitorModel)TempData["searchModel"]).DateFrom != null
                    ? ((InvestigationMonitorModel)TempData["searchModel"]).DateFrom.Value.ToString("MM/dd/yyyy") : "Any";

           DateTo = ((InvestigationMonitorModel)TempData["searchModel"]).DateTo != null
                  ? ((InvestigationMonitorModel)TempData["searchModel"]).DateTo.Value.ToString("MM/dd/yyyy") : "Any";

           ACRFrom = ((InvestigationMonitorModel)TempData["searchModel"]).ACRFrom != null
                     ? ((InvestigationMonitorModel)TempData["searchModel"]).ACRFrom : "Any";

           ACRTo = ((InvestigationMonitorModel)TempData["searchModel"]).ACRTo != null
                 ? ((InvestigationMonitorModel)TempData["searchModel"]).ACRTo : "Any";

           TimeFrom = ((InvestigationMonitorModel)TempData["searchModel"]).TimeFrom != null
                   ? ((InvestigationMonitorModel)TempData["searchModel"]).TimeFrom.Value.ToString("hh:mm tt") : "Any";

           TimeTo = ((InvestigationMonitorModel)TempData["searchModel"]).TimeTo != null
                   ? ((InvestigationMonitorModel)TempData["searchModel"]).TimeTo.Value.ToString("hh:mm tt") : "Any";

           Relationship = ((InvestigationMonitorModel)TempData["searchModel"]).Relationship != null
                   ? ((InvestigationMonitorModel)TempData["searchModel"]).Relationship : "Any";

           FurtherReview = ((InvestigationMonitorModel)TempData["searchModel"]).FurtherReviewDisplay != null
                   ? ((InvestigationMonitorModel)TempData["searchModel"]).FurtherReviewDisplay : "Any";              
           

    %>
    <form name="printForm">
    <div style="margin: 10px;">
        <h3>
            <%: Resources.info_gen_investiagtionMonitoringReport %>
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
                <col width="25%">
                <col width="25%">
                <col width="25%">
                <col width="25%">
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
                        <%: Resources.info_gen_acrFrom%></b>
                </td>
                <td>
                    <%: ACRFrom%>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_acrTo%></b>
                </td>
                <td>
                    <%: ACRTo%>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <%: Resources.info_gen_timeFrom%></b>
                </td>
                <td>
                    <%: TimeFrom%>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_timeTo%></b>
                </td>
                <td>
                    <%: TimeTo%>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <%: Resources.info_gen_relationshipBetweenDriverAndInsured%></b>
                </td>
                <td>
                    <%: Relationship%>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_furtherReview%></b>
                </td>
                <td>
                    <%: FurtherReview%>
                </td>
            </tr>
        </tbody>
    </table>
    <div style="height: 15px;">
    </div>
    <table id="AllJobsTableView3" class="table table-bordered table-condensed">
        <thead>
            <tr>
                <th style="width: 9%">
                    <%: Resources.info_gen_vehicleNo %>
                </th>
                <th style="width: 9%">
                    <%: Resources.info_gen_jobNo %>
                </th>
                <th style="width: 12%">
                    <%: Resources.info_gen_dateAndTimeOfAccident %>
                </th>
                <th style="width: 10%">
                    <%: Resources.info_gen_acr %>
                </th>
                <th style="width: 15%">
                    <%: Resources.info_gen_csrName %>
                </th>
                <th style="width: 10%">
                    <%: Resources.info_gen_contactNumber %>
                </th>
                <th style="width: 10%">
                    <%: Resources.info_gen_policeStation %>
                </th>
                <th style="width: 15%">
                    <%: Resources.info_gen_relationshipBetweenDriverAndInsured %>
                </th>
                <th style="width: 10%">
                    <%: Resources.info_gen_furtherReview %>
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
                    <%: item.VehicleNo%>
                </td>
                <td>
                    <%: item.JobNo%>
                </td>
                <td>
                    <%: item.AccidentTimeDisplay%>
                </td>
                <td>
                    <%: item.ACRAmount%>
                </td>
                <td>
                    <%: item.Name%>
                </td>
                <td>
                    <%: item.ToContactNo%>
                </td>
                <td>
                    <%: item.PoliceStation%>
                </td>
                <td>
                    <%: item.Relationship%>
                </td>
                <td>
                    <%: item.FurtherReviewDisplay%>
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
