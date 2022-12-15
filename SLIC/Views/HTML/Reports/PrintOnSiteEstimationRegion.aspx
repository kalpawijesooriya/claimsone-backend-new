<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Reports" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
        /// <summary>
        /// 
        ///  <title>SLIC2</title>
        ///  <description>Print preview of the onsite estimation - region</description>
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

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <%--Styles--%>
    <link href="../../../Content/css/bootstrap.css" rel="stylesheet" />
    <link href="../../../Content/css/bootstrap-overrides.css" rel="stylesheet" />
    <title><%: Resources.info_gen_onsiteestimateregionheader%></title>
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
    <%
        string avg = this.Session["totAverage"].ToString(); 
      %>
    <% if ((TempData["searchModel"]) != null)
       {
           string DateFrom, DateTo, TimeFrom, TimeTo,RegionCode;

           DateFrom = ((OnSiteEstimationModel)TempData["searchModel"]).DateFrom != null
                    ? ((OnSiteEstimationModel)TempData["searchModel"]).DateFrom.Value.ToString("MM/dd/yyyy") : "Any";

           DateTo = ((OnSiteEstimationModel)TempData["searchModel"]).DateTo != null
                  ? ((OnSiteEstimationModel)TempData["searchModel"]).DateTo.Value.ToString("MM/dd/yyyy") : "Any";

           //TimeFrom = ((OnSiteEstimationModel)TempData["searchModel"]).TimeFrom != null
           //         ? ((OnSiteEstimationModel)TempData["searchModel"]).TimeFrom.Value.ToString("hh:mm tt") : "Any";

           //TimeTo = ((OnSiteEstimationModel)TempData["searchModel"]).TimeTo != null
           //       ? ((OnSiteEstimationModel)TempData["searchModel"]).TimeTo.Value.ToString("hh:mm tt") : "Any";
           
           RegionCode = ((OnSiteEstimationModel)TempData["searchModel"]).RegionCode != null
                  ? ((OnSiteEstimationModel)TempData["searchModel"]).RegionCode : "Any";
    %>
    <form name="printForm">
    <div style="margin: 10px;">
        <h3><%: Resources.info_gen_onsiteestimateregionheader%></h3>
    </div>
    <table class="table table-bordered table-condensed">
        <thead>
            <tr>
                <th colspan="4">
                    <b><%: Resources.info_gen_searchCriteria%></b>&nbsp;&nbsp;&nbsp;
                    <input class="btn btn-primary btn-small" type="button" name="PrintButton" onclick="HideAndPrint();"
                        value="<%: Resources.info_gen_printReport%>" />
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <b><%: Resources.info_gen_dateFrom%></b>
                </td>
                <td>
                    <%: DateFrom %>
                </td>
                <td>
                    <b><%: Resources.info_gen_dateTo%></b>
                </td>
                <td>
                    <%: DateTo %>
                </td>
            </tr>
            <%--<tr>
                <td>
                    <b><%: Resources.info_gen_timeFrom%></b>
                </td>
                <td>
                    <%: TimeFrom %>
                </td>
                <td>
                    <b><%: Resources.info_gen_timeTo%></b>
                </td>
                <td>
                    <%: TimeTo %>
                </td>
            </tr>--%>
            <tr>
                <td>
                    <b><%: Resources.info_gen_regionName%></b>
                </td>
                <td>
                    <%: RegionCode%>
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
    <table id="AllRatiosTableView" class="table table-bordered table-condensed">
        <thead>
            <tr>
                <th style="width: 20%">
                    <b><%: Resources.info_gen_regionCode%></b>
                </th>
                <th style="width: 30%">
                    <b><%: Resources.info_gen_regionName%></b>
                </th>
                <th style="width: 10%">
                    <b><%: Resources.info_gen_totalJobs%></b>
                </th>
                <th style="width: 10%">
                    <b><%: Resources.info_gen_estimatedJobs%></b>
                </th>
                <th style="width: 10%">
                    <b><%: Resources.info_gen_OnsiteRatio%></b>
                </th>
            </tr>
        </thead>
        <tbody>
            <% if (Model == null || Model.Count == 0)   
               { %>
                    <tr><td><%: Resources.err_1000%></td></tr>
            <% }
               else
               {
                foreach (var item in Model)
                { %>
                <tr>                
                <td>
                    <%: item.RegionId%>
                </td>
                <td>
                    <%: item.RegionName%>
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
                <th colspan="4" style="text-align: right">
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
               com.IronOne.SLIC2.Models.Administration.UserDataModel printUser =  (com.IronOne.SLIC2.Models.Administration.UserDataModel)ViewData["PrintUser"];%>
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