<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<int>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    <%: Resources.info_gen_accessLogs%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContent" runat="server">
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
    <script type="text/javascript">
        $(document).ready(function () {
            var actionUrl = '<%: Html.ActionLink(" ", "VisitLogAjaxHandler", "Report", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

        var oTable = $('#AllLogsTableView').dataTable({
            "bJQueryUI": false,
            "bServerSide": true,
            "bProcessing": true,
            "bDestroy": true,
            "sPaginationType": "full_numbers",
            "oLanguage": {
                "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
            },
            "sAjaxSource": actionUrl,
            "fnServerParams": function (aoData) {
                aoData.push({ "name": "ID", "value": $('#visitId').text() });
            },
            "aoColumns": [
            { "sName": "Date",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "VehicleNo",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "JobNo",
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
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="visitId" style="display: none">
        <%: Model %>
    </div>
    <div class="span12 top-accordion-grid-with-search">
        <div class="widget highlight widget-accordion widget-table">
            <div class="widget-header">
                <h3>
                    <i class="icon-search"></i>
                    <%: Resources.info_gen_accessLogs%>
                </h3>
            </div>
            <div class="widget-content widget-form">
                <table id="AllLogsTableView" class="table table-striped table-bordered table-highlight">
                    <thead>
                        <tr>
                            <th style="width: 9%">
                                <%: Resources.info_gen_date%>
                            </th>
                            <th style="width: 9%">
                                <%: Resources.info_gen_vehicleNo%>
                            </th>
                            <th style="width: 13%">
                                <%: Resources.info_gen_jobNo%>
                            </th>
                            <th style="width: 13%">
                                <%: Resources.info_gen_csrCode%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_userName%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_branch%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_inspectionType%>
                            </th>
                            <th style="width: 10%">
                                <%: Resources.info_gen_action%>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                <div class="form-actions Grid-bottom-buttons">
                    <%--                <a href="#" class="btn btn-primary btn-small" onclick="GetExcelReport();return false;">
                    Export to Excel</a> <a href="#" class="btn btn-primary btn-small" onclick="GetPrintPriview();return false;">
                        Print</a>--%>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
