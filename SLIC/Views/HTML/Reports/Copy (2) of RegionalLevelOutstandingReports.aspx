<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Reports.OutstandingJobsModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Outstanding SA Report
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContent" runat="server">
    <%
        com.IronOne.SLIC2.Models.Administration.UserDataModel user = (Session["LoggedUserDetail"] != null) ? Session["LoggedUserDetail"] as com.IronOne.SLIC2.Models.Administration.UserDataModel : null;
        string actions = (user != null) ? user.RolePermissions : string.Empty;                      
    %>
    <!-- Styles -->
    <link href="../../../Content/css/ui-lightness/jquery-ui-1.8.21.custom.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../Content/js/Slate/plugins/datatables/DT_bootstrap.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.css"
        rel="stylesheet" type="text/css" />
    <!--Scripts -->
    <script src="../../../Content/js/Slate/plugins/lightbox/jquery.lightbox.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../../../Scripts/jquery-ui.js"></script>
    <script src="../../../../Content/js/media/js/jquery.dataTables.min.js" type="text/javascript"></script>
    <script src="../../../../Content/js/media/js/TableTools.min.js" type="text/javascript"></script>
    <script src="../../../../Content/js/media/js/ZeroClipboard.js" type="text/javascript"></script>
    <link href="../../../Content/js/Slate/plugins/timepicker/jquery.ui.timepicker.css"
        rel="stylesheet" type="text/css" />
    <script src="../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.js"
        type="text/javascript"></script>
    <script src="../../../Content/js/Slate/plugins/timepicker/jquery.ui.timepicker.min.js"
        type="text/javascript"></script>
        <script src="../../../Scripts/Report/Search.validate.js" type="text/javascript"></script>
    <script type="text/javascript">
        var oTable;
        $(function () {
            $(".idatepicker-basic").datepicker({ changeYear: true, changeMonth: true, yearRange: "-150:+0", dateFormat: '<%= ApplicationSettings.GetJqueryDateOnlyFormat %>' });
        });

        $(document).ready(function () {
            $('#istriggered').hide();
            $('#Error').hide();

            //LoadResultsForRegion();
        });

        var dropdwn = '@Html.DropDownListFor(model => model.Name)';

        function LoadTO() {
            showLoadingImage('loadingRegion');
            var actionUrl = '<%: Html.ActionLink(" ", "SelectTO", "Report", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            var val = $("#RegionName").val();

            $.ajax(
            {
                url: actionUrl,
                contentType: "application/json; charset=utf-8",
                data: { RegionName: val },
                dataType: "json",
                async: 'true',
                cache: 'false',
                type: "GET",
                error: function () {
                    alert("An error occurred.");
                },
                success: function (data) {
                    var options = "";
                    // options = "<option value='-1'>None</option>"; // uncomment if you want this item
                    $.each(data.aaData, function (a, b) {
                        options += "<option value='" + b.Value + "'>" + b.Text + "</option>";
                    });
                    $('#Name').html(options);
                    hideLoadingImage('loadingRegion');
                }
            });
            hideLoadingImage('loadingRegion');
            //LoadResultsForRegion();
        }
        function LoadResultsForRegion() {
            if (!$("#contact-form").valid()) {
                return false;
            }
            showLoadingImage('loadingRegion');
            var actionUrl2 = '<%: Html.ActionLink(" ", "RegionalLevelOutstandingReportsAjaxHandler", "Report", null, null) %>';
            actionUrl2 = actionUrl2.replace('<a href="', '');
            actionUrl2 = actionUrl2.replace('"> </a>', '');
            actionUrl2 = actionUrl2.replace('amp;', '');
            actionUrl2 = actionUrl2.replace('amp;', '');

            var Username = $("#Username").val();
            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            var RegionName = $("#RegionName").val();
            var Name = $("#Name").val();
            var regionOfEngineer;

            oTable = $('#PerformanceTableView').dataTable({                
                "bJQueryUI": false,
                "bServerSide": true,
//                "bProcessing": true,
                "bDestroy": true,
                "aaSorting": [[0, 'desc']],
                "sPaginationType": "full_numbers",                
                "oLanguage": {
                    "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
                },
                "sAjaxSource": actionUrl2,
                "fnServerParams": function (aoData) {
                    aoData.push({ "name": "DateFrom", "value": DateFrom });
                    aoData.push({ "name": "DateTo", "value": DateTo });
                    aoData.push({ "name": "RegionName", "value": RegionName });
                    aoData.push({ "name": "Name", "value": Name });
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
                        { "sName": "Vehicle No",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "Job No",
                            "bSearchable": true,
                            "bSortable": true
                        },                        
                        { "sName": "Job Assigned On",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        ]
                    });
                    hideLoadingImage('loadingRegion');
        }
        function GetPrintPreview() {

            var rowCount = oTable.fnSettings().fnRecordsTotal();
            var isToBePrinted = false;
            if (rowCount > 1000) {
                isToBePrinted = confirm("Recordset is too large to print. Do you need to print anyway?");
            } else {
                isToBePrinted = true;
            }

            if (isToBePrinted) {
                var actionUrl = '<%: Html.ActionLink(" ", "RegionalLevelOutstandingReportPrintPreview", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var DateFrom = $("#DateFrom").val();
                var DateTo = $("#DateTo").val();
                var RegionName = $("#RegionName").val();
                var Name = $("#Name").val();
                window.open(actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&RegionName=" + RegionName + "&Name=" + Name);

            }
        }

        //DulajP | 2016-12-09
        function GetExcelReport() {
            var actionUrl = '<%: Html.ActionLink(" ", "RegionalLevelOutstandingReportToExcel", "Report", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            var TimeFrom = $("#TimeFrom").val();
            var TimeTo = $("#TimeTo").val();
            var Name = $("#Name").val();
            var RegionName = $("#RegionName").val();

            window.location = actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&TimeFrom=" + TimeFrom + "&TimeTo=" + TimeTo + "&Name=" + Name + "&RegionName=" + RegionName;
        }

        function showLoadingImage(img) {
            document.getElementById(img).style.display = "block";
            document.getElementById(img).style.visibility = "visible";
        }

        function hideLoadingImage(img) {
            document.getElementById(img).style.visibility = "hidden";
            document.getElementById(img).style.display = "none";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%--20161104 Uthpalap--%>
    <% 
        com.IronOne.SLIC2.Models.Administration.UserDataModel user = (Session["LoggedUserDetail"] != null) ? Session["LoggedUserDetail"] as com.IronOne.SLIC2.Models.Administration.UserDataModel : null;
        string actions = (user != null) ? user.RolePermissions : string.Empty;                       
    %>
    <div class="span12 top-accordion-grid-with-search">
        <div class="widget highlight widget-accordion widget-table">
            <div class="widget-header">
                <h3>
                    <i class="icon-search"></i>
                    <%: Resources.info_gen_outstandingReport%>
                </h3>
            </div>
            <div class="widget-content widget-form">
                <div class="accordion" id="sample-accordion">
                    <div class="accordion-group audit-log">
                        <div class="accordion-heading">
                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#sample-accordion"
                                href="#collapseFour"><span class="leftPadder-medium"></span>
                                <%:Resources.info_gen_searchOption%>
                                <i class="icon-plus toggle-icon"></i></a>
                        </div>
                        <div id="collapseFour" class="accordion-body in collapse">
                            <div class="accordion-inner">
                                <% using (Html.BeginForm("RegionalLevelOutstandingReports", "Report", null, FormMethod.Post, new { @id = "contact-form", @class = "form-actions-full", @novalidate = "novalidate" }))
                                   { %>
                                <%: Html.ValidationSummary(true)%>
                                 <fieldset class="form-horizontal control-group-width-full" style="border-bottom: 1px dotted #CCC;">
                                    <div class="control-group-width-half">
                                        <div class="control-group">
                                            <label class="control-label" for="name">
                                                <%: Resources.info_gen_dateFrom%></label>
                                            <div class="controls">
                                                <%: Html.TextBoxFor(model => model.DateFrom, new { @class = "idatepicker-basic"})%></div>
                                        </div>
                                    </div>

                                    <div class="control-group-width-half">
                                        <div class="control-group">
                                            <label class="control-label" for="name">
                                                <%: Resources.info_gen_dateTo%></label>
                                            <div class="controls">
                                                <%: Html.TextBoxFor(model => model.DateTo, new { @class = "idatepicker-basic" })%></div>
                                        </div>
                                    </div>
                                </fieldset>
                                <fieldset class="form-horizontal control-group-width-half">
                                    <% if (!user.RoleName.Equals(Resources.info_role_engineer))
                                       { %>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_region%></label>
                                        <div class="controls">
                                            <%: Html.DropDownListFor(model => model.RegionName, (IEnumerable<SelectListItem>)(ViewData["Regions"]), new { onchange = @"LoadTO();"})%></div>
                                    </div>
                                    <% } %>
                                    <% if (user.RoleName.Equals(Resources.info_role_engineer))
                                       { %>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_region%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.RName, new { @class = "input-large", @disabled = "disabled", Value = (ViewData["RegionName"]) ?? "0" })%></div>
                                    </div>
                                    <% } %>
                                </fieldset>
                                <fieldset class="form-horizontal control-group-width-half">
                                    <%if (!(ViewData["Role"]).Equals(Resources.info_role_technicalOfficer))
                                      { %>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_csrName%></label>
                                        <div class="controls">
                                            <%: Html.DropDownListFor(model => model.Name, (IEnumerable<SelectListItem>)(ViewData["TechOfficers"]))%></div>
                                            <%--, new { onchange = @"LoadResultsForRegion();" --%>
                                    </div>
                                    <%} %>
                                </fieldset>
                                <fieldset class="form-horizontal control-group-width-full">
                                    <div class="control-group pagination-centered" id="loadingRegion" style="display:none;">
                                        <img src="../../../Content/images/loading.gif" />
                                    </div>
                                    <div>
                                        <input type="hidden" id="Hidden1" value="">
                                    </div>
                                </fieldset>
                                <fieldset class="form-horizontal form-actions-full">
                                    <div class="form-actions">
                                        <input type="button" class="btn btn-primary" onclick="LoadResultsForRegion()" value="<%: Resources.info_gen_search%>" />
                                        <input type="button" class="btn btn-secondary reset" value="<%: Resources.info_gen_reset %>" />
                                    </div>
                                </fieldset>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <div class="alert alert-info">
                        <h4 class="alert-heading">
                            <%: Resources.info_gen_searchCriteria%></h4>
                        <div id="searchCriteria">
                        </div>
                    </div>
                </div>
                <div class="alert alert-error" id="Error" style="display: none">
                    <h4 class="alert-heading">
                        <%: Resources.info_gen_errorOccurred%></h4>
                    <div id="ErrorMessage">
                    </div>
                </div>
                <table id="PerformanceTableView" class="table table-striped table-bordered table-highlight">
                    <thead>
                        <tr>
                            <th style="width: 15%">
                                <%: Resources.info_gen_csrCode%>
                            </th>
                            <th style="width: 25%">
                                <%: Resources.info_gen_nameOfTheCSR%>
                            </th>
                            <th style="width: 20%">
                                <%: Resources.info_gen_vehicleNo%>
                            </th>
                            <th style="width: 15%">
                                <%: Resources.info_gen_jobNo%>
                            </th>
                            <th style="width: 20%">
                                <%: Resources.info_gen_originalTimeReported%>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <%--<td colspan="5">
                                Loading Data...
                            </td>--%>
                        </tr>
                    </tbody>
                </table>                
                <div class="form-actions Grid-bottom-buttons">
                    <a href="#" class="btn btn-primary btn-small" onclick="GetExcelReport();return false;">
                        <%: Resources.info_gen_exportToExcel%></a> <a href="#" class="btn btn-primary btn-small"
                            onclick="GetPrintPreview();return false;">
                            <%: Resources.info_gen_print%></a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
