<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Reports" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
        /// <summary>
        /// 
        ///  <title>SLIC2</title>
        ///  <description>Print preview of the performance report region</description>
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
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%--Styles--%>
    <link href="../../../Content/css/bootstrap.css" rel="stylesheet" />
    <link href="../../../Content/css/bootstrap-overrides.css" rel="stylesheet" />
    <title>
        <%: Resources.info_menu_regLevPerformance%>
        Print Preview</title>
    <script type="text/javascript">
        function HideAndPrint() {
            document.printForm.PrintButton.style.visibility = 'hidden';
            document.printForm.PrintButton.disabled = 'true';
            window.print();
            return;
        }

        $('#AllJobsTableView3').dataTable({
            "bJQueryUI": false,
            "bServerSide": true,
            "bProcessing": true,
            "bDestroy": true,
            "sPaginationType": "full_numbers",
            "oLanguage": {
                "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
            },
            "sAjaxSource": actionUrl,
            "fnServerParams": function (aaData) {
                aoData.push({ "name": "DateFrom", "value": DateFrom });
                aoData.push({ "name": "DateTo", "value": DateTo });
                aoData.push({ "name": "TimeFrom", "value": TimeFrom });
                aoData.push({ "name": "TimeTo", "value": TimeTo });
                aoData.push({ "name": "UserId", "value": UserId });
            },
            "aoColumns": [
            { "sName": "TO Code",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "TO Name",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "EPF number",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "Total Jobs",
                "bSearchable": true,
                "bSortable": true
            },
                { "sName": "Estimated Jobs",
                    "bSearchable": true,
                    "bSortable": true
                },
                { "sName": "Ratio",
                    "bSearchable": true,
                    "bSortable": true
                },
            { "sName": "Percentage",
                "bSearchable": true,
                "bSortable": true
            }]
        });
    </script>
</head>
<body style="background: none">
    <% if ((TempData["searchModel"]) != null)
       {
           string DateFrom, DateTo, TOCode, Username, Region;

           DateFrom = ((PerformanceModel)TempData["searchModel"]).DateFrom != null
                    ? ((PerformanceModel)TempData["searchModel"]).DateFrom.Value.ToString("MM/dd/yyyy") : "Any";

           DateTo = ((PerformanceModel)TempData["searchModel"]).DateTo != null
                  ? ((PerformanceModel)TempData["searchModel"]).DateTo.Value.ToString("MM/dd/yyyy") : "Any";

           TOCode = ((PerformanceModel)TempData["searchModel"]).TOCode != "-1"
                   ? ((PerformanceModel)TempData["searchModel"]).TOCode : "Any";

           if (((PerformanceModel)TempData["searchModel"]).TOCode == null)
           {
               ((PerformanceModel)TempData["searchModel"]).TOCode = "Any";
           }

           Username = ((PerformanceModel)TempData["searchModel"]).Name != "-1"
                   ? ((PerformanceModel)TempData["searchModel"]).Name : "Any";

           Region = ((PerformanceModel)TempData["searchModel"]).RegionName != "-1"
                      ? ((PerformanceModel)TempData["searchModel"]).RegionName : "Any";
           Region = Region + ((PerformanceModel)TempData["searchModel"]).RegionNameDisplay;
    %>
    <form name="printForm">
    <div style="margin: 10px;">
        <h3>
            <%: Resources.info_menu_regLevPerformance%></h3>
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
                        <%: Resources.info_gen_csrCode%></b>
                </td>
                <td>
                    <%: Username%>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_region%></b>
                </td>
                <td>
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
                <th style="width: 30%">
                    <%: Resources.info_gen_nameOfTheCSR%>
                </th>
                <th style="width: 10%">
                    <%: Resources.info_gen_epfNo%>
                </th>
                <th style="width: 20%">
                    <%: Resources.info_gen_completedWithinFourHrs%>
                </th>
                <th style="width: 20%">
                    <%: Resources.info_gen_notCompletedWithinFourHrs%>
                </th>
                <th style="width: 15%">
                    <%: Resources.info_gen_totalJobs%>
                </th>
                <th style="width: 15%">
                    <%: Resources.info_gen_completedRatio%>
                </th>
            </tr>
        </thead>
        <tbody>
            <% if (Model == null || Model.Count == 0)
               { %>
            <tr>
                <td>
                    <%: Resources.err_1000%>
                </td>
            </tr>
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
                    <%: item.Name%>
                </td>
                <td>
                    <%: item.EPFNo%>
                </td>
                <td>
                    <%: item.PositiveScore%>
                </td>
                <td>
                    <%: item.negativeScore%>
                </td>
                <td>
                    <%: item.TotNoOfJobs%>
                </td>
                <td>
                    <%: item.Performance%>
                </td>
            </tr>
            <% }
               } %>
            <tr align="right">
                <th colspan="6" align="right" style="text-align: right">
                    <b>
                        <%: Resources.info_gen_regionPerformance%></b>
                </th>
                <th id="totscore">
                    <b>
                        <%: TempData["totalCount"] %></b>
                </th>
            </tr>
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
