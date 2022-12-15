<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Reports" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
        /// <summary>
        /// 
        ///  <title>SLIC2</title>
        ///  <description>Print preview of the onsite estimation</description>
        ///  <copyRight>Copyright (c) 2013</copyRight>
        ///  <company>IronOne Technologies (Pvt) Ltd</company>
        ///  <createdOn>2016-11-18</createdOn>
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
    <title><%: Resources.info_menu_OnsiteEstimation%></title>
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
    <%string avg = this.Session["totAverage"].ToString(); %>
    <% 
        com.IronOne.SLIC2.Models.Administration.UserDataModel user = (Session["LoggedUserDetail"] != null) ? Session["LoggedUserDetail"] as com.IronOne.SLIC2.Models.Administration.UserDataModel : null;
        string actions = (user != null) ? user.RolePermissions : string.Empty;
    %>
    <% if ((TempData["searchModel"]) != null)
       {
           string DateFrom, DateTo, TimeFrom, TimeTo, UserId, Username, Region;

           DateFrom = ((OnSiteEstimationModel)TempData["searchModel"]).DateFrom != null
                    ? ((OnSiteEstimationModel)TempData["searchModel"]).DateFrom.Value.ToString("MM/dd/yyyy") : "Any";

           DateTo = ((OnSiteEstimationModel)TempData["searchModel"]).DateTo != null
                  ? ((OnSiteEstimationModel)TempData["searchModel"]).DateTo.Value.ToString("MM/dd/yyyy") : "Any";

           //TimeFrom = ((OnSiteEstimationModel)TempData["searchModel"]).TimeFrom != null
           //         ? ((OnSiteEstimationModel)TempData["searchModel"]).TimeFrom.Value.ToString("hh:mm tt") : "Any";

           //TimeTo = ((OnSiteEstimationModel)TempData["searchModel"]).TimeTo != null
           //       ? ((OnSiteEstimationModel)TempData["searchModel"]).TimeTo.Value.ToString("hh:mm tt") : "Any";

           UserId = ((OnSiteEstimationModel)TempData["searchModel"]).UserId != "-1"
                   ? ((OnSiteEstimationModel)TempData["searchModel"]).UserId : "Any";

           Username = ((OnSiteEstimationModel)TempData["searchModel"]).UserId != "-1"
                   ? ((OnSiteEstimationModel)TempData["searchModel"]).UserName : "Any";

           if (user.RoleName.Equals(Resources.info_role_systemAdministrator) || user.RoleName.Equals(Resources.info_role_management) || user.RoleName.Equals(Resources.info_role_audit))
           {
               Region = ((OnSiteEstimationModel)TempData["searchModel"]).RegionName != "-1"
                      ? ((OnSiteEstimationModel)TempData["searchModel"]).RegionName : "Any";
           }
           else
           {
               Region = "";
           }
           
    %>
    <form name="printForm">
    <div style="margin: 10px;">
        <h3><%: Resources.info_menu_OnsiteEstimation%></h3>
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
                        <%: Resources.info_gen_csrName%></b>
                </td>
                <td>
                    <%: Username%>
                </td>
                <% if (user.RoleName.Equals(Resources.info_role_systemAdministrator) || user.RoleName.Equals(Resources.info_role_management) || user.RoleName.Equals(Resources.info_role_audit))
                   { %>
                <td>
                    <b>
                        <%: Resources.info_gen_region%></b>
                </td>
                <td>
                    <%:Region %>
                </td>
                <% }
                   else
                   { %>
                       <td></td>
                       <td></td>
                   <% } %>
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
                        <%: Resources.info_gen_csrCode%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_csrName%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_epfNo%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_totalJobs%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_estimatedJobs%></b>
                </th>
                <th>
                    <b>
                        <%: Resources.info_gen_OnsiteRatio%></b>
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
                    <%: item.UserId %>
                </td>
                <td>
                    <%: item.UserName%>
                </td>
                <td>
                    <%: item.EPFNo%>
                </td>
                <td>
                    <%: item.TotalJobs%>
                </td>
                <td>
                    <%: item.EstimatedJobs%>
                </td>
                <td>
                    <%: item.Ratio%>
                </td>
            </tr>
            <% }
               } %>
        </tbody>
        <tfoot>
            <tr>
                <th colspan="5" style="text-align: right">
                    <%: Resources.info_gen_average%>
                </th>
                <th>
                    <%: avg%>
                </th>
            </tr>
        </tfoot>
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
