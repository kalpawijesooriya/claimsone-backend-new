<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>job data result page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-20</createdOn>
    ///  <author>Suren Manawatta</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    /// </summary>                                                                                 
%>
<script type="text/javascript" src="../../../../Scripts/jquery-ui.js"></script>
<script src="../../../../Content/js/media/js/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="../../../../Content/js/media/js/TableTools.min.js" type="text/javascript"></script>
<script src="../../../../Content/js/media/js/ZeroClipboard.js" type="text/javascript"></script>
<script src="../../../Content/js/Slate/plugins/msgAlert/js/msgAlert.js" type="text/javascript"></script>
<link href="../../../Content/js/Slate/plugins/msgAlert/css/msgAlert.css" rel="stylesheet"
    type="text/css" />
<script type="text/javascript">
    var oTable;
    var saview = false;
    var sacliamimages = false;
    var accidentimages = false;
    var visitinspection = false;
    var totalJobCount = 0;

    
    $(document).ready(function () {
        //$('#AllJobsTableView_processing').hide();
        console.log("Document.ready function of tableusercontrolasync");
        
        var dateFrom = $("#DateFrom").val();
        var dateTo = $("#DateTo").val();
        var vehicleNo = $("#VehicleNo").val();
        var jobNo = $("#JobNo").val();
        var csrCode = $("#CSRCode").val();
        var csrName = $("#CSRName").val();
        var regionId = $("#RegionId").val();
        var claimProcessingBranchId = $("#BranchId").val();
        var epfNo = $("#EPFNo").val();

//        console.log("if (jobNo == null && vehicleNo == null )");
//        console.log(jobNo)
//        console.log(vehicleNo)

        if (jobNo || vehicleNo) {
//            console.log("if (jobNo || vehicleNo) {")
            $('#AllJobsTableView_processing').show();

            var actionUrl = '<%: Html.ActionLink(" ", "AdvancedSearchAjaxHandler", "Job", null, null) %>';
//            console.log("actionurl was set. inside the if.")
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');
        }

        oTable = $('#AllJobsTableView').dataTable({
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
                aoData.push({ "name": "DateFrom", "value": dateFrom });
                aoData.push({ "name": "DateTo", "value": dateTo });
                aoData.push({ "name": "VehicleNo", "value": vehicleNo });
                aoData.push({ "name": "JobNo", "value": jobNo });
                aoData.push({ "name": "CSRCode", "value": csrCode });
                aoData.push({ "name": "CSRName", "value": csrName });
                aoData.push({ "name": "RegionId", "value": regionId });
                aoData.push({ "name": "BranchId", "value": claimProcessingBranchId });
                aoData.push({ "name": "EPFNo", "value": epfNo });
            },
            "aoColumns": [
            { "sName": "vehicleno",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "jobno",
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
                "bSortable": true,
                "sClass": "alignRight"
            },
            { "sName": "saformprint",
                "bSearchable": false,
                "bSortable": false,
                "sClass": "alignCenter"
            },
            { "sName": "claimformimage",
                "bSearchable": false,
                "bSortable": false,
                "sClass": "alignCenter"
            },
            { "sName": "claimprocessingbranch",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "printedbranchdate",
                          "bSearchable": false,
                          "bSortable": false,
                          
            },
            { "sName": "options",
                "bSearchable": false,
                "bSortable": false,
                "sClass": "alignCenter"
            }]
        });
        $('#AllJobsTableView_processing').hide();
    });

    
    //Fill the visit view of a job on the popup
    function CreateVisitTable(row) {
        //isVisitTableCreated = true;
        var actionUrlVisits = '<%: Html.ActionLink(" ", "GetVisitsOfJobsAjaxHandler", "Job", null, null) %>';
        actionUrlVisits = actionUrlVisits.replace('<a href="', '');
        actionUrlVisits = actionUrlVisits.replace('"> </a>', '');
        actionUrlVisits = actionUrlVisits.replace('amp;', '');
        actionUrlVisits = actionUrlVisits.replace('amp;', '');

        var visitTable = $('#VisitTable').dataTable({
            "bJQueryUI": false,
            "bServerSide": true,
            "bDestroy": true,
            "bProcessing": true,
            "sPaginationType":"full_numbers",
            
            "oLanguage": {
                "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
            },
            "sAjaxSource": actionUrlVisits,
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
    
    $('.viewsaform').live('click', function () {
        saview = true;
    });

    $('.saclaimform').live('click', function () {
        sacliamimages = true;
    });

    $('.accidentimages').live('click', function () {
        accidentimages = true;
    });

    $('.visitinspection').live('click', function () {
        visitinspection = true;
    });

    $('.visitAccesslog').live('click', function () {
        var visitId = $(this).parents('tr').find('td:eq(0) .value').text();
        window.open("../Report/VisitLog/" + visitId);
        return false;
    });

    $('.jobAccesslog').live('click', function () {
        var visitId = $(this).parents('tr').find('td:eq(0) .value').text();
        window.location = "../Report/VisitLog/" + visitId;
        return false;
    });

    $('.printJob').live('click', function () {
        var jobNo = $(this).parents('tr').find('td:eq(1)').text();
        window.open("JobFullPrintPreview?jobNo=" + jobNo, '', 'width=800,height=600,scrollbars=yes,resizable=yes');
        return false;
    });

    //2017/03/03
    
    $('.printJobWithImages').live('click', function () {
        var jobNo = $(this).parents('tr').find('td:eq(1)').text();
        window.open("JobWithImagesPrintPreview?jobNo=" + jobNo, '', 'width=800,height=600,scrollbars=yes,resizable=yes');
        return false;
    });
    

    $('.printVisit').live('click', function () {

        var row = $(this).parents('tr');
        var visitId = $(row).find('td:eq(0) .value').text();
        if ($(row).index() == 0) {       
            window.open("JobDetailsPrintPreview?visitId=" + visitId, '', 'width=800,height=600,scrollbars=yes,resizable=yes');
        } else {           
            window.open("VisitDetailsPrintPreview?visitId=" + visitId, '', 'width=800,height=600,scrollbars=yes,resizable=yes');
        }
        return false;
    });

    $("#AllJobsTableView tr").live("click", function () {

        var row = $(this).find('td:eq(1)').text();
        var vehNo = $(this).find('td:eq(0) .vehicleNoValue').text();      
        var tmp = $(this).find('.value').text();
      
        $('#jobNoHeading').text(row);
        $('#vehNoHeading').text(vehNo);
        $('#currentVisitId').val(tmp);
        CreateVisitTable(row);

        $("#panel").toggle("slide", "fast");
        $(this).toggleClass("active");
        return false;
    });

    function jobSearchCall() {
       // alert("inside jobSearchCall");
        //$("#AllJobsTableView_processing").css("display","block");
        //console.log("loading image display block");
        //console.log('loading image display block');

        var actionUrl = '<%: Html.ActionLink(" ", "AdvancedSearchAjaxHandler", "Job", null, null) %>';
        actionUrl = actionUrl.replace('<a href="', '');
        actionUrl = actionUrl.replace('"> </a>', '');
        actionUrl = actionUrl.replace('amp;', '');
        actionUrl = actionUrl.replace('amp;', '');
        
        var dateFrom = $("#DateFrom").val();
        var dateTo = $("#DateTo").val();
        var vehicleNo = $("#VehicleNo").val();
        var jobNo = $("#JobNo").val();
        var csrCode = $("#CSRCode").val();
        var csrName = $("#CSRName").val();
        var regionId = $("#RegionId").val();
        var claimProcessingBranchId = $("#BranchId").val();
        var epfNo = $("#EPFNo").val();
        
        oTable = $('#AllJobsTableView').dataTable({
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
                aoData.push({ "name": "DateFrom", "value": dateFrom });
                aoData.push({ "name": "DateTo", "value": dateTo });
                aoData.push({ "name": "VehicleNo", "value": vehicleNo });
                aoData.push({ "name": "JobNo", "value": jobNo });
                aoData.push({ "name": "CSRCode", "value": csrCode });
                aoData.push({ "name": "CSRName", "value": csrName });
                aoData.push({ "name": "RegionId", "value": regionId });
                aoData.push({ "name": "BranchId", "value": claimProcessingBranchId });
                aoData.push({ "name": "EPFNo", "value": epfNo });
                
            },
             "fnRowCallback": function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                  if(aData){
                    hideLoadingImage('AllJobsTableView_processing');
                  }
            },
            "aoColumns": [
            { "sName": "vehicleno",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "jobno",
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
                "bSortable": true,
                "sClass": "alignRight"
            },
            { "sName": "saformprint",
                "bSearchable": false,
                "bSortable": false,
                "sClass": "alignCenter"
            },
            { "sName": "claimformimage",
                "bSearchable": false,
                "bSortable": false,
                "sClass": "alignCenter"
            },
            { "sName": "claimprocessingbranch",
                "bSearchable": true,
                "bSortable": true
            },
            { "sName": "printedbranchdate",
                          "bSearchable": false,
                          "bSortable": false,
                          
            },
            { "sName": "options",
                "bSearchable": false,
                "bSortable": false,
                "sClass": "alignCenter"
            }]
        });
        
        //$("#AllJobsTableView_processing").css("display","none");
     }

     function showLoadingImage(img) {
            document.getElementById(img).style.display = "block";
            document.getElementById(img).style.visibility = "visible";
        }

        function hideLoadingImage(img) {
            //document.getElementById(img).style.visibility = "hidden";
            document.getElementById(img).style.display = "none";
        }

</script>
<table id="AllJobsTableView" class="table table-striped table-bordered table-highlight">
    <thead>
        <tr>
            <th>
                <%:Resources.info_gen_vehicleNo %>
            </th>
            <th>
                <%:Resources.info_gen_jobNo %>
            </th>
            <th style="width: 12%">
                <%:Resources.info_gen_dateOfAccident %>
            </th>
            <th>
                <%:Resources.info_gen_csrCode %>
            </th>
            <th style="width: 10%">
                <%:Resources.info_gen_acr %>
            </th>
            <th style="width: 10%">
                SA Form
                <br />
                Print
                <%:Resources.info_gen_yesno %>
            </th>
            <th style="width: 11%">
                Claim Form
                <br />
                Available
                <%:Resources.info_gen_yesno %>
            </th>
            <th>
                Claim
                <br />
                Processing
                <br />
                Branch
            </th>
            <th style="width: 10%">
                Printed Branch
                <br />
                and Date
            </th>
            <th>
                <%:Resources.info_gen_options%>
            </th>
        </tr>
    </thead>
    <%--<tbody><tr><td colspan="10">Loading Data...</td></tr>
                    </tbody>--%>
</table>
<div class="form-actions Grid-bottom-buttons">
    <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized("AdvancedSearchResultPrintPreview_HTML"))
      { %>
    <a href="#" class="btn btn-primary" onclick="GetJobPrintPreview();">
        <%:Resources.info_gen_printPreview%></a>
    <%} %>
</div>
