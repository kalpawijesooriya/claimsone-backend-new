<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Reports.InvestigationMonitorModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    <%: Resources.info_gen_investiagtionMonitoringReport%>
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
    <script src="../../../Scripts/Report/InvestigationMonitoringSearch.validate.js" type="text/javascript"></script>
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

            var actionUrl2 = '<%: Html.ActionLink(" ", "InvestigationMonitoringReportAjaxHandler", "Report", null, null) %>';
            actionUrl2 = actionUrl2.replace('<a href="', '');
            actionUrl2 = actionUrl2.replace('"> </a>', '');
            actionUrl2 = actionUrl2.replace('amp;', '');
            actionUrl2 = actionUrl2.replace('amp;', '');

            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            var TimeFrom = $("#TimeFrom").val();
            var TimeTo = $("#TimeTo").val();
            var ACRFrom = $("#ACRFrom").val();
            var ACRTo = $("#ACRTo").val();
            var Relationship = $("#RelationshipId").val();
            var FurtherReview = $("#FurtherReview").val();

            oTable = $('#InvestigationTableView').dataTable({
                "bJQueryUI": false,
                "bServerSide": true,
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
                    aoData.push({ "name": "TimeFrom", "value": TimeFrom });
                    aoData.push({ "name": "TimeTo", "value": TimeTo });
                    aoData.push({ "name": "ACRFrom", "value": ACRFrom });
                    aoData.push({ "name": "ACRTo", "value": ACRTo });
                    aoData.push({ "name": "RelationshipId", "value": Relationship });
                    aoData.push({ "name": "FurtherReview", "value": FurtherReview });
                },
                "aoColumns": [
                        { "sName": "VehicleNo",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "JobNo",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "AccidentTime",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "ACRAmount",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "Name",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "ToContactNo",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "PoliceStation",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "Relationship",
                            "bSearchable": true,
                            "bSortable": true
                        },
                        { "sName": "FurtherReviewDisplay",
                            "bSearchable": false,
                            "bSortable": false
                        },
            ]
            });

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

            var rowCount = oTable.fnSettings().fnRecordsTotal();
            if (rowCount <= 0) {
                alert("No data available to export to excel");
                return;
            }

            var actionUrl = '<%: Html.ActionLink(" ", "InvestigationMonitoringReportToExcel", "Report", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            var TimeFrom = $("#TimeFrom").val();
            var TimeTo = $("#TimeTo").val();
            var ACRFrom = $("#ACRFrom").val();
            var ACRTo = $("#ACRTo").val();
            var Relationship = $("#RelationshipId").val();
            var FurtherReview = $("#FurtherReview").val();

            window.location = actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&TimeFrom=" + TimeFrom + "&TimeTo=" + TimeTo + "&ACRFrom=" + ACRFrom + "&ACRTo=" + ACRTo + "&RelationshipId=" + Relationship + "&FurtherReview=" + FurtherReview;
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
                var actionUrl = '<%: Html.ActionLink(" ", "InvestigationMonitoringReportPrintPreview", "Report", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var DateFrom = $("#DateFrom").val();
                var DateTo = $("#DateTo").val();
                var TimeFrom = $("#TimeFrom").val();
                var TimeTo = $("#TimeTo").val();
                var ACRFrom = $("#ACRFrom").val();
                var ACRTo = $("#ACRTo").val();
                var Relationship = $("#RelationshipId").val();
                var FurtherReview = $("#FurtherReview").val();

                window.open(actionUrl + "?DateFrom=" + DateFrom + "&DateTo=" + DateTo + "&TimeFrom=" + TimeFrom + "&TimeTo=" + TimeTo + "&ACRFrom=" + ACRFrom + "&ACRTo=" + ACRTo + "&RelationshipId=" + Relationship + "&FurtherReview=" + FurtherReview);

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
                    <%: Resources.info_gen_investiagtionMonitoringReport %>
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
                                <% using (Html.BeginForm("InvestigationMonitoringReport", "Report", null, FormMethod.Post, new { @id = "contact-form", @class = "form-actions-full", @novalidate = "novalidate" }))
                                   { %>
                                <%: Html.ValidationSummary(true)%>
                               
                              
                                
                                <fieldset class="form-horizontal control-group-width-full" style="border-bottom: 1px dotted #CCC;">
                                    <div class="control-group-width-half">
                                        <div class="control-group">
                                            <label class="control-label" for="name">
                                              Upload Report</label>
                                            <div class="controls">
                                                <input type="button" class="btn btn-primary" onclick="LoadData()" value="Select" />
                                             </div>
                                        </div>
                                    </div>
                                    <div class="control-group-width-half">
                                        <div class="control-group">
                                            <label class="control-label" for="name">
                                               Report.xlsx</label>
                                            <div class="controls">
                                        </div>
                                        </div>
                                    </div>
                                </fieldset>
                                <fieldset class="form-horizontal form-actions-full">
                                    <div class="form-actions">
                                        <input type="button" class="btn btn-primary" onclick="LoadData()" value="Generate Report" />
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
                <table id="InvestigationTableView" class="table table-striped table-bordered table-highlight">
                    <thead>
                        <tr>
                         
                            <th style="width: 15%">
                                <%: Resources.info_gen_jobNo %>
                            </th>
                            <th style="width: 5%">
                              SA Report Availability
                            </th>
                            <th style="width: 5%">
                               SA Report Availability
                            </th>
                            <th style="width: 5%">
                             ARI PhoTos Avalibility 
                            </th>
                           
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                <div class="form-actions Grid-bottom-buttons">
                    <a href="#" class="btn btn-primary btn-small" onclick="GetExcelReport();return false;">
                        <%: Resources.info_gen_exportToExcel%></a> <a href="#" class="btn btn-primary btn-small"
                            onclick="GetPrintPriview();return false;">
                            <%: Resources.info_gen_print%></a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               