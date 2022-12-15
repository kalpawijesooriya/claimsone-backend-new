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
    <%--<script src="../../../Scripts/api.js" type="text/javascript"></script>--%>
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
            //submit();
        });

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
                data: { RegionName: val },
                dataType: "json",
                type: "GET",
                error: function () {
                    alert("An error occurred.");
                    hideLoadingImage('loadingRegion');
                },
                success: function (data) {
                    var options = "";
                    $.each(data.aaData, function (a, b) {
                        options += "<option value='" + b.Value + "'>" + b.Text + "</option>";
                    });
                    $('#UserId').html(options);
                    //hideLoadingImage('loadingRegion');
                }
            })
            hideLoadingImage('loadingRegion');
            //LoadResultsForRegion(val);
        }

        function LoadResultsForRegion(val) {
            submit();
        }

        function submit() {
        if (!$("#contact-form").valid()) {
                return false;
            }
            showLoadingImage('loadingRegion');
            var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationAjaxHandler", "Report", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            document.getElementById("totavg").innerHTML = "";
            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            //                var TimeFrom = $("#TimeFrom").val();
            //                var TimeTo = $("#TimeTo").val();
            var UserId = $("#UserId").val();
            var CSRCode = $("#CSRCode").val();
            var Username = $("#Username").val();
            var RegionName = $("#RegionName").val();



            oTable = $('#AllLogsTableView').dataTable({
                "bJQueryUI": false,
                "bServerSide": true,
                //"bProcessing": true,
                "bDestroy": true,
                "aaSorting": [[5, 'desc']],
                "sPaginationType": "full_numbers",
                "oLanguage": {
                    "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
                },
                "sAjaxSource": actionUrl,
                "fnServerParams": function (aoData) {
                    aoData.push({ "name": "DateFrom", "value": DateFrom });
                    aoData.push({ "name": "DateTo", "value": DateTo });
                    aoData.push({ "name": "RegionName", "value": RegionName });
                    aoData.push({ "name": "UserId", "value": UserId });

                    //                    $.ajax({
                    //                        "dataType": 'json',
                    //                        "type": "GET",
                    //                        "url": actionUrl,
                    //                        "data": aoData,
                    //                        "success": hideLoadingImage('loadingRegion'),
                    //                        "error": hideLoadingImage('loadingRegion')
                    //                    });
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
                        { "sName": "EPF No",
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

            $('#AllLogsTableView').on('draw.dt', function () {

                getAverage();
            });
        }

        function getAverage() {

            showLoadingImage('loadingRegion');
            var actionUrl3 = '<%: Html.ActionLink(" ", "AverageSendAjax", "Report", null, null) %>';
            actionUrl3 = actionUrl3.replace('<a href="', '');
            actionUrl3 = actionUrl3.replace('"> </a>', '');
            actionUrl3 = actionUrl3.replace('amp;', '');
            actionUrl3 = actionUrl3.replace('amp;', '');
            $.ajax(
                {
                    url: actionUrl3,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: {},
                    async: 'true',
                    cache: 'false',
                    type: "GET",
                    error: function (textStatus, error) {
                        alert("An error occurred.");
                        hideLoadingImage('loadingRegion');
                        document.getElementById("errorMessage").innerHTML = error;
                    },
                    success: function (data) {
                        document.getElementById("totavg").innerHTML = data[0];
                        var regionOfEngineer = data[1];
                        $('#RName').val(regionOfEngineer);
                        hideLoadingImage('loadingRegion');
                    }
                })
        }



        function GetExcelReport() {


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
            var RegionName = $("#RegionName").val();

            window.location = actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&RegionName=" + RegionName + "&UserId=" + UserId;

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
                var actionUrl = '<%: Html.ActionLink(" ", "OnSiteEstimationPrintPreview", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var DateFrom = $("#DateFrom").val();
                var DateTo = $("#DateTo").val();
                //                var TimeFrom = $("#TimeFrom").val();
                //                var TimeTo = $("#TimeTo").val();
                var RegionName = $("#RegionName").val();
                var UserId = $("#UserId").val();

                window.open(actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&RegionName=" + RegionName + "&UserId=" + UserId);

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

                function reset() {
                    document.getElementById("DateFrom").value = "";
                    document.getElementById("DateTo").value = "";
                   
                <% if (user.RoleName.Equals(Resources.info_role_engineer)){ %>
                    //document.getElementById("RegionName").selectedIndex = 0;
                    document.getElementById("UserId").selectedIndex = 0;
                    document.getElementById("RName").value = null;

                <%} if (!user.RoleName.Equals(Resources.info_role_engineer) && (!user.RoleName.Equals(Resources.info_role_technicalOfficer))) {%>
                    document.getElementById("RegionName").selectedIndex = 0;
                    document.getElementById("UserId").selectedIndex = 0;
                    //document.getElementById("RName").value = null;
                <%} %>
                    
                    //UserId
                }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% 
        com.IronOne.SLIC2.Models.Administration.UserDataModel user = (Session["LoggedUserDetail"] != null) ? Session["LoggedUserDetail"] as com.IronOne.SLIC2.Models.Administration.UserDataModel : null;
        string actions = (user != null) ? user.RolePermissions : string.Empty;
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
                                <% using (Html.BeginForm("OnSiteEstimation", "Report", null, FormMethod.Post, new { @id = "contact-form", @class = "form-actions-full", @novalidate = "novalidate" }))
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
                                    
                                    <%--<div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_timeFrom%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.TimeFrom, new { @class = "timepicker" })%></div>
                                    </div>--%>
                                    <% if (!(user.RoleName.Equals(Resources.info_role_engineer) || user.RoleName.Equals(Resources.info_role_technicalOfficer)))
                                       { %>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_region%></label>
                                        <div class="controls">
                                            <%: Html.DropDownListFor(model => model.RegionName, (IEnumerable<SelectListItem>)(ViewData["Regions"]), new { onchange = @"LoadTO();" })%></div>
                                    </div>
                                    <% } %>
                                    <% if (user.RoleName.Equals(Resources.info_role_engineer))
                                       { %>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_region%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.RName, new { @class = "input-large", @disabled = "disabled" })%></div>
                                    </div>
                                    <% } %>
                                </fieldset>
                                <fieldset class="form-horizontal control-group-width-half">
                                   
                                    <%--<div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_timeTo%></label>
                                        <div class="controls">
                                            <%: Html.TextBoxFor(model => model.TimeTo, new { @class = "timepicker" })%></div>
                                    </div>--%>
                                    <%--<div class="control-group">
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
                                    </div>--%>
                                    <% if (!user.RoleName.Equals(Resources.info_role_technicalOfficer))
                                       { %>
                                    <div class="control-group">
                                        <label class="control-label" for="name">
                                            <%: Resources.info_gen_csrName%></label>
                                        <div class="controls">
                                            <%: Html.DropDownListFor(model => model.UserId, (IEnumerable<SelectListItem>)(ViewData["users"]))%></div>
                                    </div>
                                    <% } %>
                                    <%} %>
                                </fieldset>
                                <fieldset class="form-horizontal control-group-width-full">
                                    <div class="control-group pagination-centered" id="loadingRegion" style="display: none;">
                                        <img src="../../../Content/images/loading.gif" />
                                    </div>
                                    <div>
                                        <input type="hidden" id="errorMessage" value="">
                                    </div>
                                </fieldset>
                                <fieldset class="form-horizontal form-actions-full">
                                    <div class="form-actions">
                                        <input type="button" onclick="submit()" class="btn btn-primary" value="<%: Resources.info_gen_search%>" />
                                        <input type="button" onclick="reset()" class="btn btn-secondary reset" value="<%: Resources.info_gen_reset %>" />
                                    </div>
                                </fieldset>
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
                            <th style="width: 15%">
                                <%: Resources.info_gen_csrCode %>
                            </th>
                            <th style="width: 40%">
                                <%: Resources.info_gen_csrName%>
                            </th>
                            <th style="width: 15%">
                                <%: Resources.info_gen_epfNo %>
                            </th>
                            <%--<th style="width: 30%">
                                <%: Resources.info_gen_regionName%>
                            </th>--%>
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
                            <%--<td colspan="6">
                                Loading Data...
                            </td>--%>
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
