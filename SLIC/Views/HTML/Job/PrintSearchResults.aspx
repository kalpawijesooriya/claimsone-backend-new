<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<List<com.IronOne.SLIC2.Models.EntityModel.GetJobs_Result>>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Job" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
        /// <summary>
        /// 
        ///  <title>SLIC2</title>
        ///  <description>Print preview of the inquiry report</description>
        ///  <copyRight>Copyright (c) 2012</copyRight>
        ///  <company>IronOne Technologies (Pvt) Ltd</company>
        ///  <createdOn>2012-12-10</createdOn>
        ///  <author>Suren Manawatta</author>
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
        <%:Resources.info_gen_inquireReports%></title>
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
           string DateFrom, DateTo, JobNo, VehicleNo, CSRCode, CSRName, BranchName, RegionName, EPFNo;

           DateFrom = ((AdvancedSearch)TempData["searchModel"]).DateFrom != null
                    ? ((AdvancedSearch)TempData["searchModel"]).DateFrom.ToString() : "Any";

           DateTo = ((AdvancedSearch)TempData["searchModel"]).DateTo != null
                  ? ((AdvancedSearch)TempData["searchModel"]).DateTo.ToString() : "Any";

           JobNo = ((AdvancedSearch)TempData["searchModel"]).JobNo != null
                 ? ((AdvancedSearch)TempData["searchModel"]).JobNo : "--";

           VehicleNo = ((AdvancedSearch)TempData["searchModel"]).VehicleNo != null
                     ? ((AdvancedSearch)TempData["searchModel"]).VehicleNo : "--";

           CSRCode = ((AdvancedSearch)TempData["searchModel"]).CSRCode != null
                   ? ((AdvancedSearch)TempData["searchModel"]).CSRCode : "--";

           EPFNo = ((AdvancedSearch)TempData["searchModel"]).EPFNo != null
                   ? ((AdvancedSearch)TempData["searchModel"]).EPFNo : "--";

           CSRName = ((AdvancedSearch)TempData["searchModel"]).CSRName != null
                   ? ((AdvancedSearch)TempData["searchModel"]).CSRName : "--";

           BranchName = ((AdvancedSearch)TempData["searchModel"]).BranchName != null
                      ? ((AdvancedSearch)TempData["searchModel"]).BranchName : "Any";

           RegionName = ((AdvancedSearch)TempData["searchModel"]).RegionName != null
                      ? ((AdvancedSearch)TempData["searchModel"]).RegionName : "Any";
    %>
    <form name="printForm">
    <div style="margin: 10px;">
        <h3>
            <%:Resources.info_gen_inquireReports%></h3>
    </div>
    <table class="table table-bordered table-condensed">
        <thead>
            <tr>
                <th colspan="4">
                    <b>
                        <%:Resources.info_gen_searchCriteria%></b>&nbsp;&nbsp;&nbsp;
                    <input class="btn btn-primary btn-small" type="button" name="PrintButton" onclick="HideAndPrint();"
                        value="Print Report" />
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <b>
                        <%:Resources.info_gen_dateFrom%></b>
                </td>
                <td>
                    <%: DateFrom %>
                </td>
                <td>
                    <b>
                        <%:Resources.info_gen_dateTo%></b>
                </td>
                <td>
                    <%: DateTo %>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <%:Resources.info_gen_jobNo%></b>
                </td>
                <td>
                    <%: JobNo %>
                </td>
                <td>
                    <b>
                        <%:Resources.info_gen_vehicleNo%></b>
                </td>
                <td>
                    <%: VehicleNo %>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <%:Resources.info_gen_csrCode%></b>
                </td>
                <td>
                    <%: CSRCode %>
                </td>
                <td>
                    <b>
                        <%:Resources.info_gen_csrName%></b>
                </td>
                <td>
                    <%: CSRName %>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <%:Resources.info_gen_region%></b>
                </td>
                <td>
                    <%: RegionName %>
                </td>
                <td>
                    <b>
                        <%:Resources.info_gen_branch%></b>
                </td>
                <td>
                    <%: BranchName %>
                </td>
            </tr>
            <tr>
                <td>
                    <b>
                        <%:Resources.info_gen_epfNo%></b>
                </td>
                <td>
                    <%: EPFNo %>
                </td>
                <td>
                </td>
                <td>
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
                        <%:Resources.info_gen_vehicleNo%></b>
                </th>
                <th>
                    <b>
                        <%:Resources.info_gen_jobNo%></b>
                </th>
                <th>
                    <b>
                        <%:Resources.info_gen_dateAndTimeOfAccident%></b>
                </th>
                <th>
                    <b>
                        <%:Resources.info_gen_csrCode%></b>
                </th>
                <th>
                    <b>
                        <%:Resources.info_gen_acr + " " + Resources.info_gen_rs%></b>
                </th>
                <th>
                    <b>
                        <%:Resources.info_gen_saFormPrint + " " + Resources.info_gen_yesno%></b>
                </th>
                <th>
                    <b>
                        <%:Resources.info_gen_claimFormAvailable + " " + Resources.info_gen_yesno%></b>
                </th>
                <th>
                    <b>
                        <%:Resources.info_gen_printedBranchNameDate%></b>
                </th>
                <th>
                    <b>
                        <%:Resources.info_gen_claimProcessingBranch%></b>
                </th>
            </tr>
        </thead>
        <tbody>
            <% if (Model == null)
               { %>
                    <tr><td><%:Resources.err_1000%></td></tr>
            <% }
               else
               {
                   foreach (var item in Model)
                   { %>
            <tr>
                <td>
                    <%: item.GEN_VehicleNo %>
                </td>
                <td>
                    <%: item.JobNo %>
                </td>
                <td>
                    <%: item.GEN_Acc_Time.ToString(ApplicationSettings.GetDateTimeFormat) %>
                </td>
                <td>
                    <%: item.Code %>
                </td>
                <td>
                    <%: item.OTH_Approx_RepairCost %>
                </td>
                <td>
                    <% if (item.IsPrinted)
                       { %>
                    Y
                    <% }
                       else
                       { %>
                    N
                    <% } %>
                </td>
                <td>
                    N
                </td>
                <td>
                    <%: item.PrintedBranch + "  " + item.PrintedDate.GetValueOrDefault().ToString(ApplicationSettings.GetDateOnlyFormat)%>
                </td>
                <td>
                    <%: item.ProcessingBranchName %>
                </td>
            </tr>
            <% }
               } %>
        </tbody>
    </table>
    <div id="foo" class="span12">
        &nbsp; &copy;
        <%=DateTime.Now.Year %>
        <%:com.IronOne.SLIC2.Lang.Resources.info_gen_copyright%>
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
