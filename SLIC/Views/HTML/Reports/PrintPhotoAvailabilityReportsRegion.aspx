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
    <title>Photo Availability Report Print Preview</title>
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
           string DateFrom, DateTo, VehicleNo, JobNo, TOCode, ToName, Region, RName, VisitType = "";

           DateFrom = ((PhotoAvailabilityModel)TempData["searchModel"]).DateFrom != null
                    ? ((PhotoAvailabilityModel)TempData["searchModel"]).DateFrom.Value.ToString("MM/dd/yyyy") : "Any";

           DateTo = ((PhotoAvailabilityModel)TempData["searchModel"]).DateTo != null
                  ? ((PhotoAvailabilityModel)TempData["searchModel"]).DateTo.Value.ToString("MM/dd/yyyy") : "Any";

           VehicleNo = ((PhotoAvailabilityModel)TempData["searchModel"]).VehicleNo != null
                     ? ((PhotoAvailabilityModel)TempData["searchModel"]).VehicleNo : "--";

           JobNo = ((PhotoAvailabilityModel)TempData["searchModel"]).JobNo != null
                 ? ((PhotoAvailabilityModel)TempData["searchModel"]).JobNo : "--";

           TOCode = ((PhotoAvailabilityModel)TempData["searchModel"]).TOCode != null
                   ? ((PhotoAvailabilityModel)TempData["searchModel"]).TOCode : "Any";

           VisitType = ((PhotoAvailabilityModel)TempData["searchModel"]).InspectionTypeName;

           if (((PhotoAvailabilityModel)TempData["searchModel"]).Name != null)
           {
               ToName = ((PhotoAvailabilityModel)TempData["searchModel"]).Name != "-1"
                   ? ((PhotoAvailabilityModel)TempData["searchModel"]).Name : "Any";
           }
           else
           {
               ToName = ((PhotoAvailabilityModel)TempData["searchModel"]).Name != null
                   ? ((PhotoAvailabilityModel)TempData["searchModel"]).Name : "Any";
           }

           if (String.IsNullOrWhiteSpace(((PhotoAvailabilityModel)TempData["searchModel"]).RegionName) || (((PhotoAvailabilityModel)TempData["searchModel"]).RegionName == ""))
               Region = "Any";

           Region = ((PhotoAvailabilityModel)TempData["searchModel"]).RegionName != "-1"
                      ? ((PhotoAvailabilityModel)TempData["searchModel"]).RegionName : "Any";

           RName = String.IsNullOrWhiteSpace(((PhotoAvailabilityModel)TempData["searchModel"]).RName) ? "" : ((PhotoAvailabilityModel)TempData["searchModel"]).RName + " - ";
    %>
    <form name="printForm">
    <div style="margin: 10px;">
        <h3>
            Photo Availability Report</h3>
    </div>
    <table class="table table-bordered table-condensed">
        <thead>
            <tr>
                <th colspan="9">
                    <b>
                        <%: Resources.info_gen_searchCriteria%></b>&nbsp;&nbsp;&nbsp;
                    <input class="btn btn-primary btn-small" type="button" name="PrintButton" onclick="HideAndPrint()"
                        value="<%: Resources.info_gen_printReport%>" />
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <col width="12.5%">
                <col width="37.5%">
                <col width="12.5%">
                <col width="12.5%">
                <col width="12.5%">
                <col width="12.5%">
                <td>
                    <b>
                        <%: Resources.info_gen_visitType%></b>
                </td>
                <td>
                    <%: VisitType %>
                </td>
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
                    <%: ToName%>
                </td>
                <td>
                    <b>
                        <%: Resources.info_gen_region%></b>
                </td>
                <td colspan="6">
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
                <th class="tg-0lax" colspan="5" />
                <th class="tg-0lax" colspan="5" style="text-align: center">
                    Photo Availability Count
                </th>
            </tr>
            <% if (VisitType == "SA Form")
               { %>
            <tr id="Tr1">
                <th style="width: 10%">
                    <%: Resources.info_gen_jobNo%>
                </th>
                <th style="width: 8%">
                    <%: Resources.info_gen_vehicleNo%>
                </th>
                <th style="width: 7%">
                    <%: Resources.info_gen_csrCode%>
                </th>
                <th style="width: 7%">
                    <%: Resources.info_gen_epfNo%>
                </th>
                <th style="width: 13%">
                    <%: Resources.info_gen_assignedDate%>
                </th>
                <th style="width: 10%">
                    <%: Resources.info_gen_accidentImages%>
                </th>
                <th style="width: 10%">
                    <%: Resources.info_gen_driverStatement%>
                </th>
                <th style="width: 10%">
                    <%: Resources.info_gen_technicalofficerComments%>
                </th>
                <th style="width: 13%">
                    <%: Resources.info_gen_claimFormImage%>
                </th>
                <th style="width: 12%">
                    <%: Resources.info_gen_totalImageCount%>
                </th>
            </tr>
            <%
                }
               else
               {%>
            <tr id="OtherForm">
                <th style="width: 13%; text-align: center">
                    <%: Resources.info_gen_jobNo%>
                </th>
                <th style="width: 10%; text-align: center">
                    <%: Resources.info_gen_vehicleNo%>
                </th>
                <th style="width: 10%; text-align: center">
                    <%: Resources.info_gen_csrCode%>
                </th>
                <th style="width: 10%; text-align: center">
                    <%: Resources.info_gen_epfNo%>
                </th>
                <th style="width: 15%; text-align: center">
                    <%: Resources.info_gen_visitDate%>
                </th>
                <th style="width: 10%; text-align: center">
                    <%: Resources.info_gen_officerComments%>
                </th>
                <th style="width: 10%; text-align: center">
                    <%: Resources.info_gen_estimateAnyOtherComments%>
                </th>
                <th style="width: 12%; text-align: center">
                    <%: Resources.info_gen_inspectionPhotosSeenVisists%>
                </th>
                <th style="width: 10%; text-align: center">
                    <%: Resources.info_gen_totalImageCount%>
                </th>
            </tr>
            <%
                }
            %>
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
                   if (VisitType == "SA Form")
                   {
                       foreach (var item in Model)
                       { %>
            <tr>
                <td>
                    <%: item.JobNo%>
                </td>
                <td>
                    <%: item.VehicleNo%>
                </td>
                <td>
                    <%: item.TOCode%>
                </td>
                <td>
                    <%: item.EPFNo%>
                </td>
                <td>
                    <%: item.AssignedDate%>
                </td>
                <td>
                    <%: item.C3%>
                </td>
                <td>
                    <%: item.C4%>
                </td>
                <td>
                    <%: item.C5%>
                </td>
                <td>
                    <%: item.C6%>
                </td>
                <td>
                    <%: item.TotalImageAvailable%>
                </td>
            </tr>
            <% }
                   }
                   else
                   {
                       foreach (var item in Model)
                       { %>
            <tr>
                <td>
                    <%: item.JobNo%>
                </td>
                <td>
                    <%: item.VehicleNo%>
                </td>
                <td>
                    <%: item.TOCode%>
                </td>
                <td>
                    <%: item.EPFNo%>
                </td>
                <td>
                    <%: item.VisitedDateDisplay%>
                </td>
                <td>
                    <%: item.C5%>
                </td>
                <td>
                    <%: item.C21%>
                </td>
                <td>
                    <%: item.C20%>
                </td>
                <td>
                    <%: item.TotalImageAvailable%>
                </td>
            </tr>
            <%
                }
                   }
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
