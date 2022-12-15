<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Reports.OnSiteEstimationModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    <%: Resources.info_gen_RatioTitle2%>
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
            if (!$("#contact-form").valid()) {
                return false;
            } 
            $('#istriggered').hide();
            $('#Error').hide();

            var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationRegionAjaxHandler", "Report", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            var TimeFrom = $("#TimeFrom").val();
            var TimeTo = $("#TimeTo").val();
            var CSRCode = $("#CSRCode").val();
            var Username = $("#Username").val();
            var RegionName = $("#RegionName").val();


            oTable = $('#AllRatiosTableView').dataTable({
                "bJQueryUI": false,
                "bServerSide": true,
                "bDestroy": true,
                "sPaginationType": "full_numbers",
                "oLanguage": {
                    "sEmptyTable": "No Estimation Forms submitted matching the criteria."
                },
                "sAjaxSource": actionUrl,
                "fnServerParams": function (aoData) {
                    aoData.push({ "name": "DateFrom", "value": DateFrom });
                    aoData.push({ "name": "DateTo", "value": DateTo });
                    aoData.push({ "name": "TimeFrom", "value": TimeFrom });
                    aoData.push({ "name": "TimeTo", "value": TimeTo });
                    aoData.push({ "name": "CSRCode", "value": CSRCode });
                    aoData.push({ "name": "Username", "value": Username });
                    aoData.push({ "name": "RegionName", "value": RegionName });
                },
                "aoColumns": [
                    { "sName": "Region Code",
                        "bSearchable": true,
                        "bSortable": true
                    },
                    { "sName": "Region Name",
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
                    }]
            }
        );
        });
       
        function GetExcelReport() {
            var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationRegionToExcel", "Report", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            var TimeFrom = $("#TimeFrom").val();
            var TimeTo = $("#TimeTo").val();
            var RegionName = $("#RegionName").val();

            window.location = actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&TimeFrom=" + TimeFrom + "&TimeTo=" + TimeTo + "&RegionName=" + RegionName;
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
                var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationRegionPrintPreview", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var DateFrom = $("#DateFrom").val();
                var DateTo = $("#DateTo").val();
                var TimeFrom = $("#TimeFrom").val();
                var TimeTo = $("#TimeTo").val();
                var RegionName = $("#RegionName").val();

                window.open(actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&TimeFrom=" + TimeFrom + "&TimeTo=" + TimeTo + "&RegionName=" + RegionName);
        
            }

            }
       
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="span12 top-accordion-grid-with-search">
        <div class="widget highlight widget-accordion widget-table">
            <div class="widget-header">
                <h3>
                    <i class="icon-search"></i>
                    <%: Resources.info_gen_RatioTitle2%>
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
                                <% using (Html.BeginForm("OnSiteEstimationRegion", "Report", null, FormMethod.Post, new { @id = "contact-form", @class = "form-actions-full", @novalidate = "novalidate" }))
                                   { %>
                                <%: Html.ValidationSummary(true)%>
                                <fieldset class="form-horizontal control-group-width-half">
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_dateFrom%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.DateFrom, new { @class = "idatepicker-basic" })%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_timeFrom%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.TimeFrom, new { @class = "timepicker" })%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_region%></label>
                                        <div class="controls">
                                            <%: Html.DropDownListFor(model => model.RegionName, (IEnumerable<SelectListItem>)(ViewData["Regions"]))%></div>
                                    </div>
                                </fieldset>
                                <fieldset class="form-horizontal control-group-width-half">
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_dateTo%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.DateTo, new { @class = "idatepicker-basic" })%></div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_timeTo%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.TimeTo, new { @class = "timepicker" })%></div>
                                    </div>
                                </fieldset>
                                <fieldset class="form-horizontal form-actions-full">
                                    <div class="form-actions">
                                        <input type="submit" class="btn btn-primary" value="<%: Resources.info_gen_search%>" />
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
                <table id="AllRatiosTableView" class="table table-striped table-bordered table-highlight">
                    <thead>
                        <tr>
                            <th style="width: 20%">
                                <%: Resources.info_gen_regionCode%>
                            </th>
                            <th style="width: 30%">
                                <%: Resources.info_gen_regionName%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_totalJobs%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_estimatedJobs%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_OnsiteRatio%>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="5">
                                Loading Data...
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="form-actions Grid-bottom-buttons">
                </div>
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
