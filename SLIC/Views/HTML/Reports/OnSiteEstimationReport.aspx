<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Reports.OnSiteEstimationModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    <%: Resources.info_menu_OnsiteEstimation%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContent" runat="server">
    <% 
        com.IronOne.SLIC2.Models.Administration.UserDataModel user = (Session["LoggedUserDetail"] != null) ? Session["LoggedUserDetail"] as com.IronOne.SLIC2.Models.Administration.UserDataModel : null;
        string actions = (user != null) ? user.RolePermissions : string.Empty;
        string presentAction = (ViewData["ReportType"] != null) ? ViewData["ReportType"].ToString() : "TO";
    %>
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

            var loggedUser = '<%= user.RoleName.Equals("Engineer") || user.RoleName.Equals("Technical Officer") %>';
            if (loggedUser == "True") {
                $('#divTO').hide();
                $('#divRegion').hide();
            }

            var presentAction = '<%= presentAction == "TO"%>';
            if (presentAction == 'True') {
                var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationAjaxHandler", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');
            } else {
                var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationRegionAjaxHandler", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');
            }

            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            var TimeFrom = $("#TimeFrom").val();
            var TimeTo = $("#TimeTo").val();
            var UserId = $("#UserId").val();
            var CSRCode = $("#CSRCode").val();
            var Username = $("#Username").val();
            var RegionName = $("#RegionName").val();

            document.getElementById('divTO').style.display = "block";
            document.getElementById('divRegion').style.display = "none";

            oTable = $('#AllLogsTableView').dataTable({
                "bJQueryUI": false,
                "bServerSide": true,
                "bDestroy": true,
                "bProcessing": true,
                "aaSorting": [[5, 'desc']],
                "sPaginationType": "full_numbers",
                "oLanguage": {
                    "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
                },
                "sAjaxSource": actionUrl,
                "fnServerParams": function (aoData) {
                    aoData.push({ "name": "DateFrom", "value": DateFrom });
                    aoData.push({ "name": "DateTo", "value": DateTo });
                    aoData.push({ "name": "TimeFrom", "value": TimeFrom });
                    aoData.push({ "name": "TimeTo", "value": TimeTo });
                    aoData.push({ "name": "UserId", "value": UserId });
                    aoData.push({ "name": "CSRCode", "value": CSRCode });
                    aoData.push({ "name": "Username", "value": Username });
                    aoData.push({ "name": "RegionName", "value": RegionName });
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
                    }]
            }
        );

            myfunction();
            getAverage();

            var loggedUser = '<%= user.RoleName.Equals("Engineer") || user.RoleName.Equals("Technical Officer") %>';
            if (loggedUser == "True") {
                $('#divTO').hide();
                $('#divRegion').hide();
                if ('<%= user.RoleName.Equals("Engineer") %>') {
                    radiobtn = document.getElementById("Type");
                    radiobtn.value = "TO";
                    radiobtn.checked = true;
                }
            } else {
                radiobtn = document.getElementById("Type");
                radiobtn.value = "TO";
                radiobtn.checked = true;
            }
        });

        function myfunction() {
            for (var index = 7; index <= 11; index++) {
                var tbl = document.getElementById('AllLogsTableView');

                $('th:nth-child(' + index + ')').hide();

                $('AllLogsTableView').each(function () {
                    $('td:eq(' + index + ')', this).toggle();
                });
            };
        }

        function getAverage() {
            $('#AllLogsTableView').on('draw.dt', function () {

                var actionUrl = '<%: Html.ActionLink(" ", "AverageSendAjax", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');
                $.ajax(
                {
                    url: actionUrl,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: {},
                    async: 'true',
                    cache: 'false',
                    type: "GET",
                    error: function () {
                        alert("An error occurred.");
                    },
                    success: function (data) {
                        document.getElementById("totavg").innerHTML = data;
                    }
                })
            });
        }

        function radioTypeChanged(type) {

            var loggedUser = '<%= user.RoleName.Equals("Technical Officer") %>';
            if (loggedUser == "True") {
                type = "TO";
            };

            document.getElementById('divTO').style.display = "block";
            document.getElementById('divRegion').style.display = "block";

            //show all columns
            for (var index = 1; index <= 11; index++) {
                $('th:nth-child(' + index + ')').show();
            }

            if (type == null) {
                var radioSelected = $('input[id="Type"]:checked').val();
                var presentAction = (radioSelected == "TO");

                if (presentAction == true) {
                    type = "TO";
                } else {
                    type = "Region";
                }
            }

            if (type == 'Region') {
                //hide drpdwnTO and show drpdwnRegion
                document.getElementById('divTO').style.visibility = "hidden";
                document.getElementById('divTO').style.display = "none";
                document.getElementById('divRegion').style.visibility = "visible";

                var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationRegionAjaxHandler", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var Type = "Region";

                var DateFrom = $("#DateFrom").val();
                var DateTo = $("#DateTo").val();
                var TimeFrom = $("#TimeFrom").val();
                var TimeTo = $("#TimeTo").val();
                var UserId = $("#UserId").val();
                var CSRCode = $("#CSRCode").val();
                var Username = $("#Username").val();
                var RegionName = $("#RegionName").val();

                $('#AllLogsTableView').dataTable({
                    "bJQueryUI": false,
                    "bServerSide": true,
                    "bDestroy": true,
                    "bProcessing": true,
                    "aaSorting": [[4, 'desc']],
                    "sPaginationType": "full_numbers",
                    "oLanguage": {
                        "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
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

                //hide TO columns
                for (var index = 6; index > 0; index--) {
                    $('th:nth-child(' + index + ')').toggle();
                }

                var table = document.getElementById('AllLogsTableView');
                table.tFoot.rows[0].cells[0].style.display = 'table-cell';
                table.tFoot.rows[0].cells[1].style.display = 'table-cell';
                table.tFoot.rows[0].cells[0].colSpan = 4;
            } else {
                //show drpdwnTO and hide drpdwnRegion
                document.getElementById('divTO').style.display = "block";
                document.getElementById('divTO').style.visibility = "visible";
                document.getElementById('divRegion').style.display = "none";

                var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationAjaxHandler", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var Type = "TO";

                var DateFrom = $("#DateFrom").val();
                var DateTo = $("#DateTo").val();
                var TimeFrom = $("#TimeFrom").val();
                var TimeTo = $("#TimeTo").val();
                var UserId = $("#UserId").val();
                var CSRCode = $("#CSRCode").val();
                var Username = $("#Username").val();
                var RegionName = $("#RegionName").val();

                $('#AllLogsTableView').dataTable({
                    "bJQueryUI": false,
                    "bServerSide": true,
                    "bDestroy": true,
                    "bProcessing": true,
                    "aaSorting": [[5, 'desc']],
                    "sPaginationType": "full_numbers",
                    "oLanguage": {
                        "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
                    },
                    "sAjaxSource": actionUrl,
                    "fnServerParams": function (aoData) {
                        aoData.push({ "name": "DateFrom", "value": DateFrom });
                        aoData.push({ "name": "DateTo", "value": DateTo });
                        aoData.push({ "name": "TimeFrom", "value": TimeFrom });
                        aoData.push({ "name": "TimeTo", "value": TimeTo });
                        aoData.push({ "name": "UserId", "value": UserId });
                        aoData.push({ "name": "CSRCode", "value": CSRCode });
                        aoData.push({ "name": "Username", "value": Username });
                        aoData.push({ "name": "RegionName", "value": RegionName });
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
                    }]
                });
                //hide region columns
                for (var index = 7; index <= 11; index++) {
                    $('th:nth-child(' + index + ')').toggle();
                }

                var table = document.getElementById('AllLogsTableView');
                table.tFoot.rows[0].cells[0].style.display = 'table-cell';
                table.tFoot.rows[0].cells[1].style.display = 'table-cell';
                table.tFoot.rows[0].cells[0].colSpan = 5;
            }

            getAverage();

            var loggedUser = '<%= user.RoleName.Equals("Engineer") || user.RoleName.Equals("Technical Officer") %>';
            if (loggedUser == "True") {
                $('#divTO').hide();
                $('#divRegion').hide();
            }
        }

        function GetExcelReport() {
            var radioSelected = $('input[id="Type"]:checked').val();
            var loggedUser = '<%= user.RoleName.Equals("Technical Officer") %>';
            if (loggedUser == "True") {
                radioSelected = "TO";
            };
            var presentAction = (radioSelected == "TO");
            if (presentAction == true) {
                var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationToExcel", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var DateFrom = $("#DateFrom").val();
                var DateTo = $("#DateTo").val();
//                var TimeFrom = $("#TimeFrom").val();
//                var TimeTo = $("#TimeTo").val();
                var UserId = $("#UserId").val();

                window.location = actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&UserId=" + UserId;
            } else {

                var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationRegionToExcel", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var DateFrom = $("#DateFrom").val();
                var DateTo = $("#DateTo").val();
//                var TimeFrom = $("#TimeFrom").val();
//                var TimeTo = $("#TimeTo").val();
                var RegionName = $("#RegionName").val();

                window.location = actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&RegionName=" + RegionName;
            }
        }

        function GetPrintPreview() {
            var radioSelected = $('input[id="Type"]:checked').val();
            var loggedUser = '<%= user.RoleName.Equals("Technical Officer") %>';
            if (loggedUser == "True") {
                radioSelected = "TO";
            };

            var presentAction = (radioSelected == "TO");

            var rowCount = oTable.fnSettings().fnRecordsTotal();
            var isToBePrinted = false;
            if (rowCount > 1000) {
                isToBePrinted = confirm("Recordset is too large to print. Do you need to print anyway?");
            } else {
                isToBePrinted = true;
            }

            if (isToBePrinted) {
                if (presentAction == true) {
                    var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationPrintPreview", "Report", null, null) %>';
                    actionUrl = actionUrl.replace('<a href="', '');
                    actionUrl = actionUrl.replace('"> </a>', '');
                    actionUrl = actionUrl.replace('amp;', '');
                    actionUrl = actionUrl.replace('amp;', '');

                    var DateFrom = $("#DateFrom").val();
                    var DateTo = $("#DateTo").val();
                    //                var TimeFrom = $("#TimeFrom").val();
                    //                var TimeTo = $("#TimeTo").val();
                    var InspectionTypeName = $("#InspectionTypeName").val();

                    var UserId = $("#UserId").val();

                    window.open(actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&UserId=" + UserId + "&InspectionTypeName=" + InspectionTypeName);
                } else {

                    var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationRegionPrintPreview", "Report", null, null) %>';
                    actionUrl = actionUrl.replace('<a href="', '');
                    actionUrl = actionUrl.replace('"> </a>', '');
                    actionUrl = actionUrl.replace('amp;', '');
                    actionUrl = actionUrl.replace('amp;', '');

                    var DateFrom = $("#DateFrom").val();
                    var DateTo = $("#DateTo").val();
                    //                var TimeFrom = $("#TimeFrom").val();
                    //                var TimeTo = $("#TimeTo").val();
                    var RegionName = $("#RegionName").val();

                    window.open(actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&RegionName=" + RegionName);
                }
            }

        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% 
        com.IronOne.SLIC2.Models.Administration.UserDataModel user = (Session["LoggedUserDetail"] != null) ? Session["LoggedUserDetail"] as com.IronOne.SLIC2.Models.Administration.UserDataModel : null;
        string actions = (user != null) ? user.RolePermissions : string.Empty;
        string presentAction = (ViewData["ReportType"] != null) ? ViewData["ReportType"].ToString() : "TO";
    %>
    <div class="span12 top-accordion-grid-with-search">
        <div class="widget highlight widget-accordion widget-table">
            <div class="widget-header">
                <h3>
                    <i class="icon-search"></i>
                    <%: Resources.info_menu_OnsiteEstimation%>
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
                                <% string view;
                                   presentAction = (ViewData["ReportType"] != null) ? ViewData["ReportType"].ToString() : "TO";
                                   if (presentAction.Equals("TO"))
                                   {
                                       view = "OnSiteEstimation";
                                   }
                                   else
                                   {
                                       view = "OnSiteEstimationRegion";
                                   } %>
                                <% using (Html.BeginForm(view.ToString(), "Report", null, FormMethod.Post, new { @id = "contact-form", @class = "form-actions-full", @novalidate = "novalidate" }))
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
                                        <%if (!user.RoleName.Equals(Resources.info_role_technicalOfficer))
                                          { %>
                                        <div style="display: inline; float: left; margin-top: 5px; margin-left: 70px;">
                                            <%: Html.RadioButtonFor(model => model.Type, "TO", new { @checked = "checked", onclick = "radioTypeChanged('TO')" }) %>TO
                                            wise</div>
                                        <%--<div style="display: inline;">--%>
                                        <%--<label class="control-label" style="display: inline; text-align: left;" for="name">
                                                &nbsp;TO wise</label></div>--%>
                                        <div style="display: inline; float: left; margin-top: 5px; margin-left: 20px;">
                                            <%: Html.RadioButtonFor(model => model.Type, "Region", new { @checked = "checked", onclick = "radioTypeChanged('Region')" })%>Region
                                            wise</div>
                                        <%--<div style="display: inline;">--%>
                                        <%--<label class="control-label" style="text-align: left;" for="name">
                                                &nbsp;Region wise</label></div>--%>
                                        <%} %>
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
                                    <div class="control-group">
                                        <div id="divTO">
                                            <label class="control-label" for="name">
                                                <%: Resources.info_gen_csrName%></label>
                                            <div class="controls">
                                                <%: Html.DropDownListFor(model => model.UserId, (IEnumerable<SelectListItem>)(ViewData["users"]))%></div>
                                        </div>
                                        <div id="divRegion">
                                            <label class="control-label" for="name">
                                                <%: Resources.info_gen_region%></label>
                                            <div class="controls">
                                                <%: Html.DropDownListFor(model => model.RegionName, (IEnumerable<SelectListItem>)(ViewData["Regions"]))%></div>
                                        </div>
                                    </div>
                                </fieldset>
                                <fieldset class="form-horizontal form-actions-full">
                                    <div class="form-actions">
                                        <input type="button" onclick="radioTypeChanged(null)" class="btn btn-primary" value="<%: Resources.info_gen_search%>" />
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
                        <% if (presentAction.Equals("TO"))
                           { %>
                        <tr>
                            <th style="width: 15%">
                                <%: Resources.info_gen_csrCode %>
                            </th>
                            <th style="width: 40%">
                                <%: Resources.info_gen_csrName%>
                            </th>
                            <th style="width: 15%">
                                <%: Resources.info_gen_epfNo %>
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
                            <%--<%} else{%>--%>
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
                        <%} %>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="6">
                                Loading Data...
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="5" style="text-align: right">
                                <%: Resources.info_gen_average%>
                            </th>
                            <th id="totavg">
                            </th>
                        </tr>
                    </tfoot>
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
