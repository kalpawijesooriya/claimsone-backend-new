<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%--com.IronOne.SLIC2.Models.Job.AdvancedSearch--%>
<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Job" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Visit" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%
        /// <summary>
        /// 
        ///  <title>SLIC2</title>
        ///  <description>inquiry report page</description>
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
    <link href="../../../Content/css/ui-lightness/jquery-ui-1.8.21.custom.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../Content/js/Slate/plugins/datatables/DT_bootstrap.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.css"
        rel="stylesheet" type="text/css" />
    <script src="../../../Content/js/Slate/plugins/lightbox/jquery.lightbox.js" type="text/javascript"></script>
    <script type="text/javascript">
        var oTable;
        var saview = false;
        var sacliamimages = false;
        var accidentimages = false;
        var visitinspection = false;
        var totalJobCount = 0;
        $(function () {
            //showLoadingImage('loadingRegion');
            $("#AllJobsTableView_processing").css("display", "block");
        });


        function ShowVisitRecords() {

            var row = '<%:ViewData["JobNo"]%>';  //$(this).find('td:eq(1)').text();                  
            var vehNo = '<%:ViewData["VehicleNo"]%>'; //$(this).find('td:eq(0) .vehicleNoValue').text();
            var tmp = '<%:ViewData["VisitID"]%>'; //$(this).find('.value').text();           

            $('#jobNoHeading').text(row);
            $('#vehNoHeading').text(vehNo);
            $('#currentVisitId').val(tmp);
            $('#jobNoPopupHeading').text(row);
            CreateVisitTable(row);

            $("#panel").toggle("slide", "fast");
            $(this).toggleClass("active");
            return false;
        }

        function CreateVisitTable(row) {
            //isVisitTableCreated = true;
            var actionUrl = '<%: Html.ActionLink(" ", "GetVisitsOfJobsAjaxHandler", "Job", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            var visitTable = $('#VisitTable').dataTable({
                "bJQueryUI": false,
                "bServerSide": true,
                "bDestroy": true,
                "bProcessing": true,
                "sPaginationType": "full_numbers",
                "oLanguage": {
                    "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
                },
                "sAjaxSource": actionUrl,
                "fnServerParams": function (aoData) {
                    aoData.push({ "name": "jobNo", "value": row });
                },
                "fnDrawCallback": function () {
                    if (saview) {
                        try {
                            $('#VisitTable tbody tr:first-child').trigger('click');
                        } catch (e) {
                        }
                        saview = false;
                    }
                    if (sacliamimages) {
                        try {
                            $('#VisitTable tbody tr:first-child').trigger('click');
                            $('.widget-tabs .nav-tabs li:nth-child(7) a').trigger('click');
                            $('#imageTypes li:nth-child(5) a').trigger('click');
                        } catch (e) {
                        }
                        sacliamimages = false;
                    }
                    if (accidentimages) {
                        try {
                            $('#VisitTable tbody tr:first-child').trigger('click');
                            $('.widget-tabs .nav-tabs li:nth-child(7) a').trigger('click');
                            $('#imageTypes li:nth-child(2) a').trigger('click');
                        } catch (e) {
                        }
                        accidentimages = false;
                    }
                    if (visitinspection) {
                        try {
                            $('#VisitTable tbody tr:first-child').trigger('click');
                            $('.widget-tabs .nav-tabs li:nth-child(7) a').trigger('click');
                            $('#imageTypes li:nth-child(9) a').trigger('click');
                        } catch (e) {
                        }
                        visitinspection = false;
                    }
                },
                "aoColumns": [
            { "sName": "visitno",
                "bSearchable": false,
                "bSortable": false,
                "sWidth": "100"
            },
            { "sName": "inspectiontype",
                "bSearchable": false,
                "bSortable": false
            },
            { "sName": "dateofaccident",
                "bSearchable": false,
                "bSortable": false,
                "sWidth": "150"
            },
            { "sName": "csrcode",
                "bSearchable": false,
                "bSortable": false
            },
            { "sName": "options",
                "bSearchable": false,
                "bSortable": false,
                "sClass": "btnColumn-small",
                "sWidth": "70"
            }]
            });
        }

        $(document).ready(function () {
            ShowVisitRecords();
            //Make All fields read only on the form
            $("#step-slide2").find("input[type='text']").attr("readonly", "readonly");
            $("#step-slide2").find("textarea").attr("readonly", "readonly");
            $("#comment").removeAttr("readonly");
            $("#visitComment").removeAttr("readonly");

            if (GetURLParameter('JobNo') != undefined || GetURLParameter('VehicleNo') != undefined) {
                $(".advance-search .accordion-heading .accordion-toggle").trigger('click');
            }

            function GetURLParameter(sParam) {
                var sPageURL = window.location.search.substring(1);
                var sURLVariables = sPageURL.split('&');
                for (var i = 0; i < sURLVariables.length; i++) {
                    var sParameterName = sURLVariables[i].split('=');
                    if (sParameterName[0] == sParam) {
                        return sParameterName[1];
                    }
                }
            }

            //hideLoadingImage('loadingRegion');
            //$("#AllJobsTableView_processing").css("display", "none");

            //On Damaged Items tab click of the SA Form
            $(".nav-tabs li:nth-child(4) a").live('click', function () {
                var damagedItems = $('form').find("[name='DamagesModel.DamagedItems']").val();
                var PerDamagedItems = $('form').find("[name='DamagesModel.PreAccDamages']").val();
                var possibleDR = $('form').find("[name='DamagesModel.PossibleDR']").val();

                $("#DamagesModel_DamagedItems_TreeView").html("<img href='../../Content/img/loading.gif' />");
                $("#DamagesModel_PreAccDamages_TreeView").html("<img href='../../Content/img/loading.gif' />");
                $("#DamagesModel_PossibleDR_TreeView").html("<img href='../../Content/img/loading.gif' />");

                var actionUrl = '<%: Html.ActionLink(" ", "DamagedItems", "Job", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var possibleDRUrl = '<%: Html.ActionLink(" ", "PossibleDR", "Job", null, null) %>';
                possibleDRUrl = possibleDRUrl.replace('<a href="', '');
                possibleDRUrl = possibleDRUrl.replace('"> </a>', '');
                possibleDRUrl = possibleDRUrl.replace('amp;', '');
                possibleDRUrl = possibleDRUrl.replace('amp;', '');

                jQuery.ajax({
                    url: actionUrl + "?items=" + damagedItems,
                    success: function (data) {
                        try {
                            $("#DamagesModel_DamagedItems_TreeView").html(data);
                        } catch (e) { }
                    },
                    async: false
                });

                jQuery.ajax({
                    url: actionUrl + "?items=" + PerDamagedItems,
                    success: function (data) {
                        try {
                            $("#DamagesModel_PreAccDamages_TreeView").html(data);
                        } catch (e) { }
                    },
                    async: false
                });

                jQuery.ajax({
                    url: possibleDRUrl + "?xmlString=" + possibleDR,
                    success: function (data) {
                        try {
                            $("#DamagesModel_PossibleDR_TreeView").html(data);
                        } catch (e) { }
                    },
                    async: false
                });
            });
        });

        $('.ViewVisit').live('click', function () {

            var row = $(this).parents('tr');
            var visitId = $(row).find('td:eq(0) .value').text();
            if ($(row).index() == 0) {
                window.open("/job/JobDetailsPrintPreview?visitId=" + visitId, '', 'width=800,height=600,scrollbars=yes,resizable=yes');
            } else {
                window.open("/job/VisitDetailsPrintPreview?visitId=" + visitId, '', 'width=800,height=600,scrollbars=yes,resizable=yes');
            }
            return false;
        });

        $('.printVisit').live('click', function () {
            var row = $(this).parents('tr');
            var visitId = $(row).find('td:eq(0) .value').text();
            var showImages = false;
            if ($(row).index() == 0) {
                window.open("/job/JobDetailsPrintPreview?visitId=" + visitId + '&IsShowImages=' + showImages, '', 'width=800,height=600,scrollbars=yes,resizable=yes');
            } else {

                window.open("/job/VisitDetailsPrintPreview?visitId=" + visitId + '&IsShowImages=' + showImages, '', 'width=800,height=600,scrollbars=yes,resizable=yes');

            }
            return false;
        });


        $("#VisitTable tbody tr").live("click", function () {

            var tmp = $(this).find('.value').text();
            var type = $(this).find('td:eq(1)').text();
            var selector;
            //Set VisitId to hidden field
            $('#currentVisitId').val(tmp);

            if (($(this).index() == 0)) {
                //SA form click
                selector = $('.step-row1');
                GetJobDetailsAsync(tmp);
            } else {
                //Visit Click 
                // alert($('.step-row2 .widget .widget-header h3 #visitType').html());
                selector = $('.step-row2');
                GetVisitDetailsAsync(tmp);
            }

            //Set Header
            $(selector).find('.widget .widget-header h3 #visitType').text(type);
            //Select first tab as default
            $('.widget-tabs ul li:first-child a').trigger('click');
        });

        //hideLoadingImage('loadingRegion');
        $("#AllJobsTableView_processing").css("display", "none");

        function GetJobDetailsAsync(visitId) {
            var actionUrl = '<%: Html.ActionLink(" ", "GetJobDetailsAjaxHandler", "Job", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            $.ajax({
                type: "POST",
                url: actionUrl + "?fmt=JSON",
                contentType: "application/x-www-form-urlencoded",
                data: { 'visitId': visitId },
                dataType: "json",

                success: function (data) {
                    try {
                        $('#step-slide2 form').find("input[type='text']").val('');
                        $('#step-slide2 form').find('textarea').val('');
                        AssignDataToPopup(data);
                    } catch (e) {
                    }
                },
                error: function () {
                    $('#step-slide2 form').find("input [type='text']").val('');
                    $('#step-slide2 form').find('textarea').val('');
                },
                complete: function () {
                }
            });
        }

        function AssignDataToPopup(data) {
            var rslt = data.result;

            for (var model in rslt) {
                var value = rslt[model];

                for (var property in value) {
                    //Set values to text boxes
                    $('form').find("[name='" + model + "." + property + "']").val(value[property]);

                    //Set values to date types
                    if (value[property] != null && value[property].toString().indexOf("/Date(") != -1) {
                        var dateTimeFormat = '<%: ApplicationSettings.GetDateTimeFormat %>';
                        var matches = value[property].match(/([0-9]+)/);
                        var d = parseInt(matches[0]);

                        var convDate = new Date(d).format(dateTimeFormat);
                        $('form').find("[name='" + model + "." + property + "']").val(convDate);
                    }
                }
            }
        }

        function GetJobPrintPreview() {

            var jobCount = oTable.fnSettings().fnRecordsTotal();
            var isToBePrinted = false;
            if (jobCount > 1000) {
                isToBePrinted = confirm("Recordset is too large to print. Do you need to print anyway?");
            } else {
                isToBePrinted = true;
            }

            if (isToBePrinted) {
                var actionUrl = '<%: Html.ActionLink(" ", "AdvancedSearchResultPrintPreview", "Job", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                actionUrl = actionUrl + "?DateFrom=" + $('#DateFrom').val() + "&DateTo=" + $('#DateTo').val() +
                                    "&JobNo=" + $('#JobNo').val() + "&VehicleNo=" + $('#VehicleNo').val() +
                                    "&CSRCode=" + $('#CSRCode').val() + "&CSRName=" + $('#CSRName').val() +
                                    "&BranchId=" + $('#BranchId').val() + "&RegionId=" + $('#RegionId').val() +
                                    "&EPFNo=" + $('#EPFNo').val();
                javascript: window.open(actionUrl, "Popup", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=500,left=0, top=0,screenX=0,screenY=0"); return false;
            }
        }

        //2017-02-17
        function GetJobCountPrintPreview() {
            var actionUrl = '<%: Html.ActionLink(" ", "GetJobsCount", "Job", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            actionUrl = actionUrl + "?DateFrom=" + $('#DateFrom').val() + "&DateTo=" + $('#DateTo').val() +
                                    "&JobNo=" + $('#JobNo').val() + "&VehicleNo=" + $('#VehicleNo').val() +
                                    "&CSRCode=" + $('#CSRCode').val() + "&CSRName=" + $('#CSRName').val() +
                                    "&BranchId=" + $('#BranchId').val() + "&RegionId=" + $('#RegionId').val() +
                                    "&EPFNo=" + $('#EPFNo').val();

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
                        var displayRecords = confirm("");
                        //document.getElementById("totavg").innerHTML = data;
                    }
                })

            //if yes for the alert,
            GetJobPrintPreview();
            //else
        }

        function GetJobDetailsPrintPreview() {
            var actionUrl = '<%: Html.ActionLink(" ", "JobDetailsPrintPreview", "Job", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            actionUrl = actionUrl + "?visitId=" + $('#currentVisitId').val();
            javascript: window.open(actionUrl, "Popup1", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=500,left=0, top=0,screenX=0,screenY=0"); return false;
        }

        function GetVisitDetailsPrintPreview() {
            var actionUrl = '<%: Html.ActionLink(" ", "VisitDetailsPrintPreview", "Job", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            actionUrl = actionUrl + "?visitId=" + $('#currentVisitId').val();
            javascript: window.open(actionUrl, "Popup1", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=500,left=0, top=0,screenX=0,screenY=0"); return false;
        }

        function GetVisitListPrintPreview() {
            var actionUrl = '<%: Html.ActionLink(" ", "JobVisitResultPrintPreview", "Job", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            actionUrl = actionUrl + "?jobNo=" + $('#jobNoHeading').text();
            javascript: window.open(actionUrl, "Popup1", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=500,left=0, top=0,screenX=0,screenY=0"); return false;
        }       
    </script>
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <%:Resources.info_gen_advancedSearch%>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="myModal" style="display: block; margin-left: 25px;">
        <div class="modal-header" style="padding-left: 27px; border-bottom: 0px">
            <h3>
                Job No&nbsp;
                <div id="jobNoPopupHeading" style="display: inline">
                </div>
                &nbsp;
            </h3>
        </div>
        <div class="modal-body" style="padding-left: 20px">
            <div class="stepContainer">
                <div id="step-slide1" class="content">
                    <div class="widget widget-table">
                        <div class="widget-header">
                            <h3>
                                <i class="icon-bar-chart"></i>
                                <%:Resources.info_gen_jobVisits%>
                                <div style="display: inline" id="jobNoHeading">
                                </div>
                                &nbsp;<%:Resources.info_gen_andVehicleNo%>
                                <span id="vehNoHeading"></span>
                                <%--  <div style="display: none" id="visitIdHidden">
                                </div>--%>
                                <input type="hidden" id="currentVisitId" />
                            </h3>
                            <a href="#" class="btn btn-primary btn-small View-comments" onclick="GetJobAllComments();">
                                <%:Resources.info_gen_allComments %></a>
                            <%--<%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized("JobVisitResultPrintPreview_HTML"))
                              { %>--%>
                            <a href="#" class="btn btn-primary btn-small" onclick="GetVisitListPrintPreview();">
                                <%:Resources.info_gen_preview%></a>
                            <%-- <%} %>--%>
                        </div>
                        <div class="widget-content">
                            <table id="VisitTable" class="table table-bordered table-striped table-highlight">
                                <thead>
                                    <tr>
                                        <th>
                                            <%:Resources.info_gen_visitNo%>
                                        </th>
                                        <th>
                                            <%:Resources.info_gen_inspectionType%>
                                        </th>
                                        <th>
                                            <%:Resources.info_gen_visitDate%>
                                        </th>
                                        <th>
                                            <%:Resources.info_gen_csrCode %>
                                        </th>
                                        <th>
                                            <%:Resources.info_gen_options%>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div id="step-slide2" class="content">
                    <%--<div id="slidebar"></div>--%>
                    <div class="step-row1">
                        <div class="widget widget-table control-widget ">
                            <div class="widget-header">
                                <h3>
                                    <i class="icon-bar-chart"></i>
                                    <%--   Job Details--%>
                                    <div style="display: inline" id="visitType">
                                    </div>
                                </h3>
                                <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized("JobDetailsPrintPreview_HTML"))
                                  { %>
                                <a href="#" class="btn btn-primary btn-small" onclick="GetJobDetailsPrintPreview();">
                                    <%:Resources.info_gen_preview%></a>
                                <%} %>
                            </div>
                            <div class="widget-content widget-tabs">
                                <ul class="nav nav-tabs">
                                    <li class="active"><a href="#genInfo">
                                        <%:Resources.info_gen_generalInfo%></a> </li>
                                    <li><a href="#policyCoverInfo">
                                        <%:Resources.info_gen_policyCoverNoteInfo%></a></li>
                                    <li><a href="#vehicleAndDriverInfo">
                                        <%:Resources.info_gen_vehicleAndDriverInfo%></a></li>
                                    <li><a href="#damagesAndVehicleCondition">
                                        <%:Resources.info_gen_damagesAndVehicleCondition%></a></li>
                                    <li><a href="#other">
                                        <%:Resources.info_gen_otherInfo%></a></li>
                                    <li><a href="#Comments" onclick="ShowJobCommentsPanel();">
                                        <%:Resources.info_gen_comments%></a></li>
                                    <li><a href="#Gallery">
                                        <%:Resources.info_gen_gallery%></a></li>
                                </ul>
                            </div>
                            <% Html.RenderPartial("~/Views/HTML/Shared/Job/JobDetails.ascx", new JobDataModel()); %>
                        </div>
                    </div>
                    <div class="step-row2">
                        <div class="widget widget-table control-widget ">
                            <div class="widget-header">
                                <h3>
                                    <i class="icon-bar-chart"></i>
                                    <%-- Visit Details--%>
                                    <div style="display: inline" id="visitType">
                                    </div>
                                </h3>
                                <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized("VisitDetailsPrintPreview_HTML"))
                                  { %>
                                <a href="#" class="btn btn-primary btn-small" onclick="GetVisitDetailsPrintPreview();">
                                    <%:Resources.info_gen_printPreview%></a>
                                <%} %>
                            </div>
                            <div class="widget-content widget-tabs">
                                <ul class="nav nav-tabs">
                                    <li class="active"><a href="#VisitInfo">
                                        <%:Resources.info_gen_visitDetails%></a></li>
                                    <li><a href="#VisitComments" onclick="ShowVisitCommentsPanel();">
                                        <%:Resources.info_gen_comments%></a></li>
                                    <li><a href="#visitGallery">
                                        <%:Resources.info_gen_gallery%></a> </li>
                                </ul>
                            </div>
                            <% Html.RenderPartial("~/Views/HTML/Shared/Job/VisitDetails.ascx", new VisitDetailModel()); %>
                        </div>
                    </div>
                    <div class="step-row3">
                        <div class="widget widget-table control-widget ">
                            <div class="widget-header">
                                <h3>
                                    <i class="icon-bar-chart"></i>
                                    <%:Resources.info_gen_comments%>
                                    <div style="display: inline" id="Div4">
                                    </div>
                                </h3>
                            </div>
                            <%Html.RenderPartial("~/Views/HTML/Shared/Job/JobComments.ascx"); %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
