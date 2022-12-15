<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Reports.PhotoAvailabilityModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Photo Availability Report
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
    <script src="../../../Scripts/Report/photoAvailabilitySearch.validate.js" type="text/javascript"></script>
    <script type="text/javascript">
        var oTable;
        $(function () {
            $(".idatepicker-basic").datepicker({ changeYear: true, changeMonth: true, yearRange: "-150:+0", dateFormat: '<%= ApplicationSettings.GetJqueryDateOnlyFormat %>' });
        });

        $(document).ready(function () {
            $('#istriggered').hide();
            $('#Error').hide();
            $('#OtherForm').hide();

            $('#DateFrom').change(function () {
                $('#DateFrom').valid();
            });
            $('#DateTo').change(function () {
                $('#DateTo').valid();
            });
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
            showReportType();
            showLoadingImage('loadingRegion');            
            LoadResult();
            hideLoadingImage('loadingRegion');

        }

       
        function LoadResult() {
            
            var InspectionType = $("#InspectionType").val();
            var tableName = (InspectionType === '0') ? LoadSaTable('#PerformanceTableViewSA') : LoadOtherTable('#PerformanceTableViewOther');

        }

        function LoadSaTable(tableName) {

            var actionUrl2 = '<%: Html.ActionLink(" ", "RegionalLevelPhotoAvailabilityReportsAjaxHandler", "Report", null, null) %>';
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
            var table;
            var InspectionType = $("#InspectionType").val();

            oTable = $(tableName).dataTable({
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
                    aoData.push({ "name": "InspectionType", "value": InspectionType });
                },
                "aoColumns": [
                        { "sName": "Job No",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "Vehicle No",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "TO Code",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "EPF NO",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "Assigned Date",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "Accident Images",
                            "bSearchable": false,
                            "bSortable": false
                        },
                        { "sName": "Driver Statement",
                            "bSearchable": false,
                            "bSortable": false
                        },
                        { "sName": "Officer Comments",
                            "bSearchable": false,
                            "bSortable": false
                        },
                        { "sName": "ClaimForm Images",
                            "bSearchable": false,
                            "bSortable": false
                        },
                        { "sName": "Available Images / Total Image Count",
                            "bSearchable": false,
                            "bSortable": false
                        },
                        ]
            });
                }

                function LoadOtherTable(tableName) {
                    var actionUrl2 = '<%: Html.ActionLink(" ", "RegionalLevelPhotoAvailabilityReportsAjaxHandler", "Report", null, null) %>';
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
                    var table;
                    var InspectionType = $("#InspectionType").val();

                    oTable = $(tableName).dataTable({
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
                            aoData.push({ "name": "InspectionType", "value": InspectionType });
                        },
                        "aoColumns": [
                        { "sName": "Job No",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "Vehicle No",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "TO Code",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "EPF NO",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "Visited Date",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "Accident Images",
                            "bSearchable": false,
                            "bSortable": false
                        },
                        { "sName": "Driver Statement",
                            "bSearchable": false,
                            "bSortable": false
                        },
                        { "sName": "Officer Comments",
                            "bSearchable": false,
                            "bSortable": false
                        },
                        { "sName": "Available Images / Total Image Count",
                            "bSearchable": false,
                            "bSortable": false
                        },
                        ]
                    });
                }

        function GetPrintPreview() {

            //var rowCount = $('#PerformanceTableView tbody tr').length;
            var rowCount = oTable.fnSettings().fnRecordsTotal();
            var isToBePrinted = false;
            if (rowCount <= 0) {
                alert("No data available to preview print");
                return;
            }
            
            if (rowCount > 1000) {
                isToBePrinted = confirm("Recordset is too large to print. Do you need to print anyway?");
            } else {
                isToBePrinted = true;
            }

            if (isToBePrinted) {
                var actionUrl = '<%: Html.ActionLink(" ", "RegionalLevelPhotoAvailabilityReportsPrintPreview", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var DateFrom = $("#DateFrom").val();
                var DateTo = $("#DateTo").val();
                var RegionName = $("#RegionName").val();
                var Name = $("#Name").val();
                var InspectionType = $("#InspectionType").val();
                window.open(actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&RegionName=" + RegionName + "&Name=" + Name + "&InspectionType=" + InspectionType);

            }
        }

        //Atheek | 2019-04-15
        function GetExcelReport() {
            var rowCount = oTable.fnSettings().fnRecordsTotal();
            if (rowCount <= 0) {
                alert("No data available to export to excel");
                return;
            }

            var actionUrl = '<%: Html.ActionLink(" ", "RegionalLevelPhotoAvailabilityReportToExcel", "Report", null, null) %>';
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
            var InspectionType = $("#InspectionType").val();

            window.location = actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&TimeFrom=" + TimeFrom + "&TimeTo=" + TimeTo + "&Name=" + Name + "&RegionName=" + RegionName + "&InspectionType="+InspectionType;
        }

        function showLoadingImage(img) {
            document.getElementById(img).style.display = "block";
            document.getElementById(img).style.visibility = "visible";
        }

        function hideLoadingImage(img) {
            document.getElementById(img).style.visibility = "hidden";
            document.getElementById(img).style.display = "none";
        }

        function showReportType() {
            var inspectionType = $("#InspectionType").val();
            if (inspectionType == "0") {
                $('#SAForm').show();
                $('#OtherForm').hide();
            } else {
                $('#SAForm').hide();
                $('#OtherForm').show();
            }           
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
                    <%: Resources.info_gen_photoAvailabilityReport%>
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
                                <% using (Html.BeginForm("RegionalLevelPhotoAvailabilityReports", "Report", null, FormMethod.Post, new { @id = "contact-form", @class = "form-actions-full"}))
                                   { %>
                                <%: Html.ValidationSummary(true)%>
                                <fieldset class="form-horizontal control-group-width-full" style="border-bottom: 1px dotted #CCC;">
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_visitType%></label>
                                        <div class="controls">
                                            <%: Html.DropDownListFor(model => model.InspectionType,(IEnumerable<SelectListItem>)(ViewData["InspectionType"]))%>
                                        </div>
                                    </div>
                                </fieldset>
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
                                <fieldset class="form-horizontal control-group-width-full">
                                     <% if (!user.RoleName.Equals(Resources.info_role_engineer))
                                           { %>
                                        <div class="control-group-width-half">
                                            <div class="control-group">
                                                <label class="control-label" for="name">
                                                    <%: Resources.info_gen_region%></label>
                                                <div class="controls">
                                                    <%: Html.DropDownListFor(model => model.RegionName, (IEnumerable<SelectListItem>)(ViewData["Regions"]), new { onchange = @"LoadTO();"})%></div>
                                            </div>
                                        </div>
                                        <% } %>
                                        <% if (user.RoleName.Equals(Resources.info_role_engineer))
                                           { %>
                                        <div class="control-group-width-half">
                                            <div class="control-group">
                                                <label class="control-label" for="name">
                                                    <%: Resources.info_gen_region%></label>
                                                <div class="controls">
                                                    <%: Html.TextBoxFor(model => model.RName, new { @class = "input-large", @disabled = "disabled", Value = (ViewData["RegionName"]) ?? "0" })%></div>
                                            </div>
                                        </div>
                                        <% } %>
                                    
                                    <%if (!(ViewData["Role"]).Equals(Resources.info_role_technicalOfficer))
                                      { %>
                                    <div class="control-group-width-half">
                                        <div class="control-group">
                                            <label class="control-label" for="name">
                                                <%: Resources.info_gen_csrName%></label>
                                            <div class="controls">
                                                <%: Html.DropDownListFor(model => model.Name, (IEnumerable<SelectListItem>)(ViewData["TechOfficers"]))%></div>
                                            <%--, new { onchange = @"LoadResultsForRegion();" --%>
                                        </div>
                                    </div>
                                    <%} %>
                                </fieldset>
                                
                                <fieldset class="form-horizontal control-group-width-full">
                                    <div class="control-group pagination-centered" id="loadingRegion" style="display: none;">
                                        <img src="../../../Content/images/loading.gif" />
                                    </div>                                    
                                </fieldset>
                                <fieldset class="form-horizontal form-actions-full">
                                    <div class="form-actions">
                                        <input type="button" class="btn btn-primary" onclick="LoadResultsForRegion()" value="<%: Resources.info_gen_search%>" />
                                        <input id="btnreset" type="button" class="btn btn-secondary reset" value="<%: Resources.info_gen_reset %>" />
                                        <div id="ValidateMessage" style="display: inline-block; margin-right: 50%">
                                        </div>
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
                <div id="SAForm">
                <table id="PerformanceTableViewSA" class="table table-striped table-bordered table-highlight">
                    <thead>                    
                        <tr>  
                            <th style="width: 60%" colspan="5">
                            </th>
                            <th style="width: 30%" colspan="4">
                                Photo Availability Count
                            </th>
                            <th style="width: 10%" colspan="1">
                            </th>                           
                        </tr>
                        <tr >
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
                    </thead>
                    <tbody></tbody>
                </table>

                <div class="form-actions Grid-bottom-buttons">
                    <a href="#" class="btn btn-primary btn-small" onclick="GetExcelReport();return false;">
                        <%: Resources.info_gen_exportToExcel%></a> <a href="#" class="btn btn-primary btn-small"
                            onclick="GetPrintPreview();return false;">
                            <%: Resources.info_gen_print%></a>
                </div>
                </div>

                <div id="OtherForm">
                <table id="PerformanceTableViewOther" class="table table-striped table-bordered table-highlight">
                    <thead>                    
                        <tr>                            
                           <th style="width: 58%" colspan="5">
                            </th>
                            <th style="width: 32%" colspan="3">
                                Photo Availability Count
                            </th>
                            <th style="width: 10%" colspan="1">
                            </th> 
                        </tr>                       
                        <tr >
                            <th style="width: 13%">
                                <%: Resources.info_gen_jobNo%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_vehicleNo%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_csrCode%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_epfNo%>
                            </th>
                            <th style="width: 15%">
                                <%: Resources.info_gen_visitedDate%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_technicalofficerComments%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_estimateAnyOtherComments%>
                            </th>
                            <th style="width: 12%">
                                <%: Resources.info_gen_inspectionPhotosSeenVisists%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_totalImageCount%>
                            </th>
                        </tr>
                    </thead>
                    <tbody></tbody>
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
    </div>
</asp:Content>
