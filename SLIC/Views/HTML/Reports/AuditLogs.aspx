<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Reports.AccessLogModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    <%: Resources.info_gen_accessLogs%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContent" runat="server">
    <!-- Styles -->
    <link href="../../../Content/css/ui-lightness/jquery-ui-1.8.21.custom.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../Content/js/Slate/plugins/datatables/DT_bootstrap.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.css"
        rel="stylesheet" type="text/css" />
    <script src="../../../Content/js/Slate/plugins/lightbox/jquery.lightbox.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../../../Scripts/jquery-ui.js"></script>
    <script src="../../../../Content/js/media/js/jquery.dataTables.min.js" type="text/javascript"></script>
    <script src="../../../../Content/js/media/js/TableTools.min.js" type="text/javascript"></script>
    <script src="../../../../Content/js/media/js/ZeroClipboard.js" type="text/javascript"></script>
    <link href="../../../Content/js/Slate/plugins/timepicker/jquery.ui.timepicker.css"
        rel="stylesheet" type="text/css" />
    <script src="../../../Content/js/Slate/plugins/timepicker/jquery.ui.timepicker.min.js"
        type="text/javascript"></script>
    <script src="../../../Scripts/Report/Search.validate.js" type="text/javascript"></script>
    <script type="text/javascript">
        var oTable;
        $(function () {
            $(".idatepicker-basic").datepicker({ changeYear: true, changeMonth: true, yearRange: "-150:+0", dateFormat: '<%= ApplicationSettings.GetJqueryDateOnlyFormat %>' });
            $('.timepicker').timepicker({ convention: 12, ampm: true });
        });

        $(document).ready(function () {
            $('#istriggered').hide();
            $('#Error').hide();


        });

        function LoadData() {
            if (!$("#contact-form").valid()) {
                return false;
            } 

            $("select#RegionName").change(function () {
                loadRegions();
            });

            showLoadingImage('loadingRegion');

            var actionUrl = '<%: Html.ActionLink(" ", "AuditLogAjaxHandler", "Report", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');


            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            var TimeFrom = $("#TimeFrom").val();
            var TimeTo = $("#TimeTo").val();
            var VehicleNo = $("#VehicleNo").val();
            var JobNo = $("#JobNo").val();
            var CSRCode = $("#CSRCode").val();
            var Username = $("#Username").val();
            var BranchName = $("#BranchName").val();
            var RegionName = $("#RegionName").val();
            var InspectionTypeName = $("#InspectionTypeName").val();
            var EFPNo = $("#EFPNo").val();

            oTable = $('#AllLogsTableView').dataTable({
                "bJQueryUI": false,
                "bServerSide": true,
                //"bProcessing": true,
                "bDestroy": true,
                "sPaginationType": "full_numbers",
                "sAjaxSource": actionUrl,
                "fnServerParams": function (aoData) {
                    aoData.push({ "name": "DateFrom", "value": DateFrom });
                    aoData.push({ "name": "DateTo", "value": DateTo });
                    aoData.push({ "name": "TimeFrom", "value": TimeFrom });
                    aoData.push({ "name": "TimeTo", "value": TimeTo });
                    aoData.push({ "name": "VehicleNo", "value": VehicleNo });
                    aoData.push({ "name": "JobNo", "value": JobNo });
                    aoData.push({ "name": "CSRCode", "value": CSRCode });
                    aoData.push({ "name": "Username", "value": Username });
                    aoData.push({ "name": "BranchName", "value": BranchName });
                    aoData.push({ "name": "RegionName", "value": RegionName });
                    aoData.push({ "name": "InspectionTypeName", "value": InspectionTypeName });
                    aoData.push({ "name": "EFPNo", "value": EFPNo });
                },
                "aoColumns": [
            { "sName": "Date",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "JobNo",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "VehicleNo",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "CSRCode",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "Username",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "BranchName",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "InspectionTypeName",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "Action",
                "bSearchable": true,
                "bSortable": true
            }]
            }
        );
            hideLoadingImage('loadingRegion');
        }

        function loadRegions() {
            var regionid = $("#RegionName option:selected").attr("value");
            showLoadingImage('loadingRegion');
            $.ajax({
                type: "POST",
                url: "/Report/FindBranchesByRegionId?regionName=" + regionid,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: 'true',
                cache: 'false',
                beforeSend: function () {
                    $("#istriggered").show();
                },
                success: function (data) {
                    $('#istriggered').hide();
                    $('#Error').hide();
                    if (data && data.length > 0) {

                        if (data instanceof Array) {

                            var options = '';
                            for (p in data) {
                                var product = data[p];
                                options += "<option value='" + product.BranchName + "'>" + product.BranchName + "</option>";
                            }
                            $("#BranchName").removeAttr('disabled').html(options);
                        } else {
                            $('#Error').show();
                            $("#ErrorMessage").text(data);
                        }
                    } else {
                        $("#BranchName").attr('disabled', true).html('');
                    }
                },
                error: function (request, status, error) {
                    alert(request.responseText);
                }
            });
            hideLoadingImage('loadingRegion');
        }
        function GetExcelReport() {
            var actionUrl = '<%: Html.ActionLink(" ", "AuditLogToExcel", "Report", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            var TimeFrom = $("#TimeFrom").val();
            var TimeTo = $("#TimeTo").val();
            var VehicleNo = $("#VehicleNo").val();
            var JobNo = $("#JobNo").val();
            var CSRCode = $("#CSRCode").val();
            var Username = $("#Username").val();
            var BranchName = $("#BranchName").val();
            var RegionName = $("#RegionName").val();
            var InspectionTypeName = $("#InspectionTypeName").val();
            var EFPNo = $("#EFPNo").val();

            window.location = actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&TimeFrom=" + TimeFrom + "&TimeTo=" + TimeTo + "&VehicleNo=" + VehicleNo + "&JobNo=" + JobNo + "&CSRCode=" + CSRCode + "&Username=" + Username + "&BranchName=" + BranchName + "&RegionName=" + RegionName + "&InspectionTypeName=" + InspectionTypeName + "&EFPNo=" + EFPNo;
        }

        function GetPrintPriview() {
            var rowCount = oTable.fnSettings().fnRecordsTotal();
            var isToBePrinted = false;
            if (rowCount > 1000) {
                isToBePrinted = confirm("Recordset is too large to print. Do you need to print anyway?");
            } else {
                isToBePrinted = true;
            }

            if (isToBePrinted) {
                var actionUrl = '<%: Html.ActionLink(" ", "AuditLogPrintPreview", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var DateFrom = $("#DateFrom").val();
                var DateTo = $("#DateTo").val();
                var TimeFrom = $("#TimeFrom").val();
                var TimeTo = $("#TimeTo").val();
                var VehicleNo = $("#VehicleNo").val();
                var JobNo = $("#JobNo").val();
                var CSRCode = $("#CSRCode").val();
                var Username = $("#Username").val();
                var BranchName = $("#BranchName").val();
                var RegionName = $("#RegionName").val();
                var InspectionTypeName = $("#InspectionTypeName").val();
                var EFPNo = $("#EFPNo").val();

                window.open(actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&TimeFrom=" + TimeFrom + "&TimeTo=" + TimeTo + "&VehicleNo=" + VehicleNo + "&JobNo=" + JobNo + "&CSRCode=" + CSRCode + "&Username=" + Username + "&BranchName=" + BranchName + "&RegionName=" + RegionName + "&InspectionTypeName=" + InspectionTypeName + "&EFPNo=" + EFPNo);

            }
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
    <div class="span12 top-accordion-grid-with-search">
        <div class="widget highlight widget-accordion widget-table">
            <div class="widget-header">
                <h3>
                    <i class="icon-search"></i>
                    <%: Resources.info_gen_accessLogs %>
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
                                <% using (Html.BeginForm("AuditLog", "Report", null, FormMethod.Post, new { @id = "contact-form", @class = "form-actions-full", @novalidate = "novalidate" }))
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
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_timeFrom%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.TimeFrom, new { @class = "timepicker" })%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_vehicleNo%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.VehicleNo, new { @class = "input-large" })%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_csrCode%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.CSRCode, new { @class = "input-large" })%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_region%></label>
                                        <div class="controls">
                                            <%: Html.DropDownListFor(model => model.RegionName, (IEnumerable<SelectListItem>)(ViewData["Regions"]), new { onchange = @"loadRegions();" })%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_inspectionType%></label>
                                        <div class="controls">
                                            <%: Html.DropDownListFor(model => model.InspectionTypeName, (IEnumerable<SelectListItem>)(ViewData["InspectionType"]))%></div>
                                    </div>
                                </fieldset>
                                <fieldset class="form-horizontal control-group-width-half">                                    
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_timeTo%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.TimeTo, new { @class = "timepicker" })%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_jobNo%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.JobNo, new { @class = "input-large" })%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_userName%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.Username, new { @class = "input-large" })%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_branch%></label>
                                        <div class="controls">
                                            <%: Html.DropDownListFor(model => model.BranchName, (IEnumerable<SelectListItem>)(ViewData["Branches"]))%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_epfNo%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.EFPNo, new { @class = "input-large" })%></div>
                                    </div>
                                </fieldset>
                                <fieldset class="form-horizontal control-group-width-full">
                                    <div class="control-group pagination-centered" id="loadingRegion" style="display: none;">
                                        <img src="../../../Content/images/loading.gif" />
                                    </div>
                                    <div>
                                        <input type="hidden" id="Hidden1" value="">
                                    </div>
                                </fieldset>
                                <fieldset class="form-horizontal form-actions-full">
                                    <div class="form-actions">
                                        <input type="button" class="btn btn-primary" onclick="LoadData()" value="<%: Resources.info_gen_search%>" />
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
                <table id="AllLogsTableView" class="table table-striped table-bordered table-highlight">
                    <thead>
                        <tr>
                            <th style="width: 9%">
                                <%: Resources.info_gen_date %>
                            </th>
                            <th style="width: 9%">
                                <%: Resources.info_gen_vehicleNo %>
                            </th>
                            <th style="width: 13%">
                                <%: Resources.info_gen_jobNo%>
                            </th>
                            <th style="width: 13%">
                                <%: Resources.info_gen_csrCode %>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_userName %>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_branch %>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_inspectionType %>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_action %>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                <div class="form-actions Grid-bottom-buttons">
                    <a href="#" class="btn btn-primary btn-small" onclick="GetExcelReport();return false;">
                        <%: Resources.info_gen_exportToExcel%></a>
                    <a href="#" class="btn btn-primary btn-small" onclick="GetPrintPriview();return false;">
                            <%: Resources.info_gen_print%></a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
