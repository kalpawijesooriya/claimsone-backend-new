<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Reports.AccessLogModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>Access log page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-20</createdOn>
    ///  <author>Suren Manawatta</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
    %>
    AccessLogs
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="span12">
        <div class="widget">
            <div class="widget-header">
                <h3>
                    <i class="icon-search"></i>
                    <%: Resources.info_gen_advancedSearch %>
                </h3>
            </div>
            <div class="widget-content">
                <table width="100%">
                    <tr>
                        <td>
                            <label class="control-label">
                                Date From
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.DateFrom, new { @class = "idatepicker-basic" })%>
                        </td>
                        <td style="width: 20px">
                        </td>
                        <td>
                            <label class="control-label">
                                Date To
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.DateTo, new { @class = "idatepicker-basic" })%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label">
                                Time From
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.TimeFrom, new { @class = "timepicker" })%>
                        </td>
                        <td>
                        </td>
                        <td>
                            <label class="control-label">
                                Time To
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.TimeTo, new { @class = "timepicker"})%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label">
                                Vehicle No
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.VehicleNo, new { @class = "input-large" })%>
                        </td>
                        <td>
                        </td>
                        <td>
                            <label class="control-label">
                                Job No
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.JobNo, new { @class = "input-large" })%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label">
                                CSR Code
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.CSRCode, new { @class = "input-large" })%>
                        </td>
                        <td>
                        </td>
                        <td>
                            <label class="control-label">
                                Username
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.Username, new { @class = "input-large" })%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label">
                                Branch
                            </label>
                        </td>
                        <td>
                            <%:Html.DropDownListFor(model => model.BranchId, (IEnumerable<SelectListItem>)(ViewData["Branches"]), new { id = "BranchId", @class = "input-large ui-tooltip", @placement = "right", @title = "Select a branch for the user." })%>
                        </td>
                        <td>
                            <img src="../../../../Content/img/loading.gif" alt="Pulpit rock" width="20" height="20"
                                id="istriggered" />
                        </td>
                        <td>
                            <label class="control-label">
                                Region
                            </label>
                        </td>
                        <td>
                            <%:Html.DropDownListFor(model => model.RegionId, (IEnumerable<SelectListItem>)(ViewData["Regions"]), new { id = "RegionId", @class = "input-large ui-tooltip", @placement = "right", @title = "Select a region for the user." })%>
                        </td>
                    </tr>
                </table>
                <div class="form-actions">
                    <input type="submit" class="btn btn-primary" value="Search" />
                    <input type="reset" class="btn btn-secondary" value="<%: Resources.info_gen_reset %>" />
                </div>
            </div>
        </div>
    </div>
    <div class="span12">
        <div class="widget">
            <div class="widget-header">
                <h3>
                    <i class="icon-tasks"></i>Access Log Results
                </h3>
                <div class="top-button-right">
                    <a href="#" class="btn btn-primary btn-small" onclick="GetJobPrintPreview();">
                        <%:Resources.info_gen_printPreview %></a>
                </div>
            </div>
            <div class="widget-content">
                <table id="AllJobsTableView" class="table table-striped table-bordered table-highlight">
                    <thead>
                        <tr>
                            <th>
                                Job No
                            </th>
                            <th>
                                Vehicle No
                            </th>
                            <th>
                                CSR Code
                            </th>
                            <th>
                                Username
                            </th>
                            <th>
                                Branch
                            </th>
                            <th>
                                Inspection Type
                            </th>
                            <th>
                                Options
                            </th>
                        </tr>
                    </thead>
                </table>
            </div>
            <div class="form-actions">
                <a href="#" class="btn btn-primary" onclick="GetJobPrintPreview();">
                    <%:Resources.info_gen_printPreview %></a>
            </div>
        </div>
    </div>
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
    <script type="text/javascript">
        $(function () {
            $(".idatepicker-basic").datepicker({ changeYear: true, changeMonth: true, yearRange: "-150:+0", dateFormat: '<%= ApplicationSettings.GetJqueryDateOnlyFormat %>' });
            $('.timepicker').timepicker({ convention: 12, ampm: true });
        });

        $(document).ready(function () {

            $('#istriggered').hide();
            $('#Error').hide();

            $("select#RegionId").change(function () {

                var regionid = $("#RegionId > option:selected").attr("value");

                $.ajax({
                    type: "POST",
                    url: "/Job/FindBranchesByRegionId?regionId=" + regionid + "&isClaimProcessed=true",
                    contentType: "application/json; charset=utf-8",
                    data: "{'regionId': 1}",
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
                                    options += "<option value='" + product.BranchId + "'>" + product.BranchName + "</option>";
                                }
                                $("#BranchId").removeAttr('disabled').html(options);
                            } else {
                                $('#Error').show();
                                $("#ErrorMessage").text(data);
                            }
                        } else {
                            $("#BranchId").attr('disabled', true).html('');
                        }
                    },
                    error: function (request, status, error) {
                        alert(request.responseText);
                    }
                });
            });
            
            var actionUrl = '<%: Html.ActionLink(" ", "AdvancedSearchAjaxHandler", "Job", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            var DateFrom = $("#DateFrom").val();
            var DateTo = $("#DateTo").val();
            var VehicleNo = $("#VehicleNo").val();
            var JobNo = $("#JobNo").val();
            var CSRCode = $("#CSRCode").val();
            var CSRName = $("#CSRName").val();
            var RegionId = $("#RegionId").val();
            var BranchId = $("#BranchId").val();

            var oTable = $('#AllJobsTableView').dataTable({
                "bJQueryUI": false,
                "bServerSide": true,
                "bProcessing": true,
                "sPaginationType": "full_numbers",
                "sAjaxSource": actionUrl,
                "fnServerParams": function (aoData) {
                    aoData.push({ "name": "DateFrom", "value": DateFrom });
                    aoData.push({ "name": "DateTo", "value": DateTo });
                    aoData.push({ "name": "JobNo", "value": JobNo });
                    aoData.push({ "name": "VehicleNo", "value": VehicleNo });
                    aoData.push({ "name": "CSRCode", "value": CSRCode });
                    aoData.push({ "name": "CSRName", "value": CSRName });
                    aoData.push({ "name": "RegionId", "value": RegionId });
                    aoData.push({ "name": "BranchId", "value": BranchId });
                },

                "aoColumns": [
            { "sName": "jobno",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "vehicleno",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "dateofaccident",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "csrcode",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "acr",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "saformprint",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "claimformimage",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "options",
                "bSearchable": false,
                "bSortable": false
            }]
            }
        );
    });
    
    </script>
</asp:Content>
