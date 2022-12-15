 
 //Custom Jquery Validator Methods

//validator method to check whether an option in the dropdown is selected
$.validator.addMethod('notNone', function (value, element, params) {
    return (value != '-1');
}, 'Please select an option.');

//validator method to check whether username is unique
//jQuery.validator.addMethod("usernameCheck", function (username) {
//    var isSuccess = false;
//    var validator = this;
//    $.ajax({
//        type: "POST",
//        url: "/Admin/IsUsernameAvailable",
//        contentType: "application/x-www-form-urlencoded",
//        data: "fmt=json&username=" + username,
//        async: 'true',
//        cache: 'false',
//        beforeSend: function () {
//            $("#usernameTrigger").show();
//        },
//        success:
//                function (data) {
//                    $('#usernameTrigger').hide();
//                    isSuccess = (data.Status.Success == "0") ? true : false;
//                      
//                    if (!isSuccess) {
//                        //Set Error
//                        validator.showErrors({ Username: data.Status.ModelErrors["err"] });
//                        //Error Msg "Username already exists. Please try another one." comes from the server
//                    }                    
//                },
//        error: function (request, status, error) {
//            alert(request.responseText);
//        }
//    });

//    return isSuccess;

//}, '');

//END Custom Jquery Validator Methods

//Other JS

/* Common JS function for getting a Json object through POST*/
function PostJsonObject(controler, action, xmlhttp, params) {
    if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
    }
    else {// code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.open("POST", "/" + controler + "/" + action, true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.setRequestHeader("Content-length", params.length);
    // xmlhttp.setRequestHeader("Connection", "close");

    /**********IMPORTANT!!! - Need this on the header to identify whether the Request is an Ajax Request.IsAjax() on server side ***********/
    xmlhttp.setRequestHeader("X-Requested-With", "XMLHttpRequest"); //Need this Tag
    return xmlhttp;
}

//27/01/2017 Uthpalap

function showLoadingImage(img) {
    document.getElementById(img).style.display = "block";
    document.getElementById(img).style.visibility = "visible";
}

function hideLoadingImage(img) {
    document.getElementById(img).style.visibility = "hidden";
    document.getElementById(img).style.display = "none";
}


// do not allow potentially dangerous characters as '<' and '>' to be entered
function AlphanumericValidation(evt) {
    var charCode = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode : ((evt.which) ? evt.which : 0));
    if (charCode == 60 || charCode == 62 || charCode == 126) {
        return false;
    }
}

function handleError(ajaxContext) {
    EndLoginRequest();
    var response = ajaxContext.get_response();
    var statusCode = response.get_statusCode();

    //Show error message in the error div
    $('.alert-error').show();
    $('.alert-error').find('.alert-heading').text(ERROR_HTTPAJAXHEADING_EN_RESOURCE + statusCode);
    $('.alert-error').find('div').text(ERROR_HTTPAJAXBODY_EN_RESOURCE + statusCode);
    // alert("Sorry, the request failed with status code " + statusCode);
}

function RedirectToHome(ajaxData) {
    try {
        var data = ajaxData.get_response().get_object();

        if (data.Status.Success == "0") {
            window.location.href = DEFAULT_INDEX_ACTION;
        } else {
            EndLoginRequest();
        }

        SetMessages(data.Status.SuccessMsg, data.Status.ModelErrors);
    } catch (e) {
    }
}

/*********************************
Sets and manages all the validation and success messages shown to the user.
**********************************/
function SetMessages(success, errors) {

    //   alert(genSuccess);
    //    alert(genError);
    //   alert(errors);

    clearMessages();    
    if (success == undefined) {
        //Do nothing
    }
    else {
        //Set Success Messages
        $('.alert-success').show();
        $('.alert-success').find('.alert-heading').text('');
        $('.alert-success').find('div').text(success);
    }

    if (errors == undefined) {
        //Do nothing
    }
    else {
        //Set Model Errors
        for (var modelError in errors) {
            try {
                //alert(errors[modelError]);
                if (modelError == 'err') {
                    //   alert(modelErrors[modelError].Message);
                    $('.alert-error').show();
                    $('.alert-error').find('.alert-heading').text('');
                    $('.alert-error').find('div').text(errors[modelError]);
                }
                else {
                    //alert(modelError);
                    //alert(errors[modelError]);
                    $('#ajaxContent').find('.field').find("[name='" + modelError + "']").next(".error").show();
                    $('#ajaxContent').find('.field').find("[name='" + modelError + "']").next(".error").text(errors[modelError]);
                }

            } catch (err) {
                // alert(err);
            }
        }
    }

}

function GetCommentsAsync() {
    var actionUrl = JOB_COMMENTSLISTAJAXHANDLER_ACTION; // '<%: Html.ActionLink(" ", "CommentsListAjaxHandler", "Job", null, null) %>';
    actionUrl = actionUrl.replace('<a href="', '');
    actionUrl = actionUrl.replace('"> </a>', '');
    actionUrl = actionUrl.replace('amp;', '');
    actionUrl = actionUrl.replace('amp;', '');

    var visitId = $('#currentVisitId').val();

    var oTable = $('#JobDetailsCommentsTable').dataTable({
        "bJQueryUI": false,
        "bServerSide": true,
        "bProcessing": true,
        "sAjaxSource": actionUrl,
        "bDestroy": true,
        "iDisplayLength": 5,
        "sPaginationType": "full_numbers",
        "aaSorting": [[0, "desc"]], // Sort by first column descending
        "oLanguage": {
        "sEmptyTable": "No comments available."
        },
        "fnServerParams": function (aoData) {
            aoData.push({ "name": "visitId", "value": visitId });
        },
        "aoColumns": [
                    {
                        "sName": "datetime",
                        "bSearchable": true,
                        "bSortable": true,
                          "sWidth": "150"
                    },
                    {
                        "sName": "Commentedby",
                        "bSearchable": true,
                        "bSortable": true,
                         "sWidth": "200"
                    },
                    {
                        "sName": "comment",
                        "bSearchable": true,
                        "bSortable": true                      
                    }]
    });
}

function GetVisitCommentsAsync() {
    var actionUrl = JOB_COMMENTSLISTAJAXHANDLER_ACTION; // '<%: Html.ActionLink(" ", "CommentsListAjaxHandler", "Job", null, null) %>';
    actionUrl = actionUrl.replace('<a href="', '');
    actionUrl = actionUrl.replace('"> </a>', '');
    actionUrl = actionUrl.replace('amp;', '');
    actionUrl = actionUrl.replace('amp;', '');

    var visitId = $('#currentVisitId').val();

    var oTable = $('#VisitCommentsTable').dataTable({
        "bJQueryUI": false,
        "bServerSide": true,
        "bProcessing": true,
        "sAjaxSource": actionUrl,
        "bDestroy": true,
        "iDisplayLength": 5,
        "sPaginationType": "full_numbers",
        "aaSorting": [[0, "desc"]], // Sort by first column descending
        "oLanguage": {
        "sEmptyTable": "No comments available."
        },
        "fnServerParams": function (aoData) {
            aoData.push({ "name": "visitId", "value": visitId });
        },
        "aoColumns": [
                    {
                        "sName": "datetime",
                        "bSearchable": true,
                        "bSortable": true,
                        "sWidth": "150"
                    },
                    {
                        "sName": "Commentedby",
                        "bSearchable": true,
                        "bSortable": true,
                        "sWidth": "200"
                    },
                    {
                        "sName": "comment",
                        "bSearchable": true,
                        "bSortable": true,                       
                    }]
    });
}

function VisibleCommentForm(value) {
    if ($(value).find("#AddCommentForm").is(":visible")) {
        $(value).find('#AddCommentForm').slideUp(500);
        $(value).text("Show New Comment Widget");
    } else {
        $(value).find('#AddCommentForm').slideDown(500);
        $('#showHideCommentLink').text("Hide New Comment Widget");
    }
}

function CreateComment() {
    var actionUrl = JOB_CREATECOMMENT_ACTION; // '<%: Html.ActionLink(" ", "CreateComment", "Job", null, null) %>';
    actionUrl = actionUrl.replace('<a href="', '');
    actionUrl = actionUrl.replace('"> </a>', '');
    actionUrl = actionUrl.replace('amp;', '');
    actionUrl = actionUrl.replace('amp;', '');

    if ($('#comment').val() == "") {
       $('#errormsg').text('Please enter comment');
        $('#comment').focus();
    } else {
      //  $('#commentPostButton').hide(500);
        $('#commentPostButton').attr('disabled', 'disabled');   
        $.ajax({
            type: "POST",
            url: actionUrl + "?fmt=JSON",
            contentType: "application/x-www-form-urlencoded",
            data: { 'visitId': $('#currentVisitId').val(),
                    'comment': $('#comment').val() },
            dataType: "json",

            success: function (data) {          
                try {
                    if (data["code"] == 0) {
                        $('#smsg').text(data["msg"]);
                        $('#successHeader').slideDown(500);
                        $('#errorHeader').slideUp(500);
                        $('#comment').val('');
                        GetCommentsAsync();
                    } else {        
                        $('#errormsg').text(data["msg"]);
                        $('#errorHeader').slideDown(500);
                        $('#successHeader').slideUp(500);
                       // $('#errorHeaderi').append('<span>'+data["msg"]+'</span>');
                    }
                } catch (e) {
                }
            },
            error: function () {
                $('#errorHeader').slideDown(500);
                $('#successHeader').slideUp(500);
            },
            complete: function () {
                $('#commentPostButton').removeAttr('disabled'); 
               //  $('#errorHeaderi').find('span').remove();    
             //   $('#commentPostButton').show(500);
            }
        });
    }
}

function CreateVisitComment() {
    var actionUrl = JOB_CREATECOMMENT_ACTION; // '<%: Html.ActionLink(" ", "CreateComment", "Job", null, null) %>';
    actionUrl = actionUrl.replace('<a href="', '');
    actionUrl = actionUrl.replace('"> </a>', '');
    actionUrl = actionUrl.replace('amp;', '');
    actionUrl = actionUrl.replace('amp;', '');

    if ($('#visitComment').val() == "") {
       $('#errorHeaderi').find('span').text('Please enter comment');
        $('#visitComment').focus();
    } else {
        //$('#visitCommentPostButton').hide(500);
        $('#visitCommentPostButton').attr('disabled', 'disabled');      

        $.ajax({
            type: "POST",
            url: actionUrl + "?fmt=JSON",
            contentType: "application/x-www-form-urlencoded",
            data: { 'visitId': $('#currentVisitId').val(),
                    'comment': $('#visitComment').val() },
            dataType: "json",

            success: function (data) {
                try {
                    if (data["code"] == 0) {
                        $('#smsgi').text(data["msg"]);
                        $('#successHeaderi').slideDown(500);
                        $('#errorHeaderi').slideUp(500);
                        $('#visitComment').val('');
                        GetVisitCommentsAsync();
                    } else {      
                        $('#errorHeaderi').find('span').remove();                    
                      //  $('#errormsg').text(data["msg"]);
                        $('#errorHeaderi').slideDown(500);
                        $('#successHeaderi').slideUp(500); 
                        $('#errorHeaderi').append('<span>'+data["msg"]+'</span>');
                        // alert( $('#errormsg').text());                  
                    }
                } catch (e) {
                }
            },
            error: function () {
                $('#errorHeaderi').slideDown(500);
                $('#successHeaderi').slideUp(500);
            },
            complete: function () {               
                 $('#visitCommentPostButton').removeAttr('disabled');  
            }
        });
    }
}

function GetJobAllComments() {
    var actionUrl = JOB_COMMENTSLISTAJXHANDLER2; // '<%: Html.ActionLink(" ", "CommentsListAjaxHandler2", "Job", null, null) %>';
    actionUrl = actionUrl.replace('<a href="', '');
    actionUrl = actionUrl.replace('"> </a>', '');
    actionUrl = actionUrl.replace('amp;', '');
    actionUrl = actionUrl.replace('amp;', '');

    var jNo = $('#jobNoPopupHeading').text();    
    var oTable = $('#CommentsTable').dataTable({
        "bJQueryUI": false, 
        "bServerSide": true,
        "bProcessing": true,
        "sAjaxSource": actionUrl,
        "bDestroy": true,
        "iDisplayLength": 10,
        "sPaginationType": "full_numbers",
        "bSearchable": true,      
        "oLanguage": {
        "sEmptyTable": "No comments available."
        },
        "fnServerParams": function (aoData) {
            aoData.push({ "name": "jobNo", "value": jNo });
        },
        "aoColumns": [
                    {
                        "sName": "visitType",
                        "bSearchable": true,
                        "bSortable": false,
                        "sClass" : "commentGroup"
                    },
                    {
                        "sName": "dateTime",
                        "bSearchable": true,
                        "bSortable": false,
                         "sWidth": "150"
                    },
                    {
                        "sName": "commentedBy",
                        "bSearchable": true,
                        "bSortable": false,
                        "sWidth": "200"
                    },
                    {
                        "sName": "comment",
                        "bSearchable": true,
                        "bSortable": false
                    }]
                }).rowGrouping({ bExpandableGrouping: true,
                                iExpandGroupOffset: -1,
                                iGroupingColumnIndex: 0,
                                bHideGroupingColumn: true });
}

// Clear messages  
function clearMessages() {
    $('.error').html('');
    $('.alert-error').hide();
    $('.alert-success').hide();
    $('.alert-info').hide();
    $('.alert-block').hide();
}

function BeginAjaxRequest() {
    //Common Begin Ajax Request
}

function EndAjaxRequest() {
    //Common End Ajax Request
}

function BeginLoginRequest() {
    $("input").attr("disabled", "disabled");
    $('.submitbutton input').hide();
}

function EndLoginRequest() {
    $("input").removeAttr("disabled");
    $('.submitbutton input').show();
}

function closeModal(){
    $('#myModal').css('display', 'none');
    $('#myModal').removeClass('in');
    $('body').removeClass('modal-open');
    $('body').find('.modal-backdrop').remove();
    $('.stepContainer').css('left', '3px');
    $('#step-slide2').find('#slidebar').remove();

}

function closePopup() {
    $('#panel').hide();
}

function printVisit(visitId) {         

            $.ajax({
                type: "POST",
                url: "/Job/PrintVisit?fmt=json&visitId=" + visitId + "",
                contentType: "application/x-www-form-urlencoded",
                dataType: "json",
                async: 'true',
                cache: 'false',
                success: function (data) {
                if(data.Status.Success == "0"){
                 window.print();
                }else{
                window.close();
                }                   
                },
                error: function (request, status, error) {
                    alert(error);window.close();
                }
                });
}

var inspectionimages = false;

$(document).ready(function () {


      $(".reset").click(function() {       
        $(this).closest('form').find("input[type=text], textarea").val("");
        $(this).closest('form').find("select").prop('selectedIndex', 0);
        $(this).closest('form').find('.control-group').removeClass('error');
    });

 
    //On image click on the opions-column
    $('.donothing').live('click', function () {
        return false;
    });

    //Make all the table headers center in the data-table
    $('.widget-content .table thead tr th').addClass('alignCenter');

    $("#AllJobsTableView tbody tr").live("click", function () {
        var jobNo = $(this).find('td:eq(1)').text();
        $('#myModal').css('display', 'block');
        $('#myModal').addClass('in');
        $('body').addClass('modal-open');
        $('body').prepend('<div class="modal-backdrop fade in"></div>');
        $('#jobNoPopupHeading').text(jobNo);
        //var visitId = $(this).find('.value').text();
    });

    $(".modal-backdrop").live("click", function () {
        closeModal();
    });

    $(".top-accordion-grid-with-search .alert-info").hide();

    $(".advance-search .accordion-heading").live('click', function () {
        // Note: on click the SLATE Jquery already adds the "Open" class if the accordian is not open!!!
        // So, we need to check the current state of the accordian

        if (!$(this).parent(".accordion-group").hasClass("open")) {
            $("i.toggle-icon").has('.icon-plus').removeClass('icon-plus').addClass('icon-minus');
            generateSearchCriteria();
            $(".top-accordion-grid-with-search .alert-info").show();
            //$('icon-plus').addClass('icon-minus').removeClass('icon-plus');
        } else {
            $(".top-accordion-grid-with-search .alert-info").hide();
        };
    });

    $(".audit-log .accordion-heading").live('click', function () {
        // Note: on click the SLATE Jquery already adds the "Open" class if the accordian is not open!!!
        // So, we need to check the current state of the accordian

        if (!$(this).parent(".accordion-group").hasClass("open")) {
            $("i.toggle-icon").has('.icon-plus').removeClass('icon-plus').addClass('icon-minus');
            generateAuditLogSearchCriteria();
            $(".top-accordion-grid-with-search .alert-info").show();
            //$('icon-plus').addClass('icon-minus').removeClass('icon-plus');
        } else {
            $(".top-accordion-grid-with-search .alert-info").hide();
        };
    });

    $('.View-comments').live('click', function () {
        $('.stepContainer').animate({ left: '-100%' }, "slow");
        $('#step-slide2').append('<div id="slidebar"></div>');
        $(".step-row1").css('display', 'none');
        $(".step-row2").css('display', 'none');
        $(".step-row3").css('display', 'block');
    });

    $('#VisitTable tbody tr').live('click', function () {
        //alert($(".stepContainer").width());
        $('.stepContainer').animate({ left: '-100%' }, "slow");
        $('#step-slide2').append('<div id="slidebar"></div>');

        if (($(this).index() == 0)) {
            //SA form click
            $(".step-row1").css('display', 'block');
            $(".step-row2").css('display', 'none');
            $(".step-row3").css('display', 'none');
        } else {
            //Visit Click
            $(".step-row1").css('display', 'none');
            $(".step-row2").css('display', 'block');
            $(".step-row3").css('display', 'none');
        }
        if (inspectionimages) {
            try {
                $('.widget-tabs .nav-tabs li:nth-child(3) a').trigger('click');
                $('.widget-tabs .nav-tabs li:nth-child(7) a').trigger('click');
            } catch (e) {

            }
            inspectionimages = false;
        }
    });

    $('.inspectionimages').live('click', function () {
        inspectionimages = true;
    });

    $('#slidebar').live('click', function () {
        $('.stepContainer').animate({ left: '3px' }, "slow");
        $('#step-slide2').find('#slidebar').remove();
    });

    function generateAuditLogSearchCriteria() {
        var textCriteria = "";
        var DateFrom = $('#DateFrom').val().trim();
        var DateTo = $('#DateTo').val().trim();
        var TimeFrom = $('#TimeFrom').val().trim();
        var TimeTo = $('#TimeTo').val().trim();
        var VehicleNo = $('#VehicleNo').val().trim();
        var JobNo = $('#JobNo').val().trim();
        var CSRCode = $('#CSRCode').val().trim();
        var Username = $("#Username").text().trim();
        var BranchName = $("#BranchName option:selected").text().trim();
        var RegionName = $("#RegionName option:selected").text().trim();
        var InspectionTypeName = $("#InspectionTypeName option:selected").text().trim();
        var EFPNo = $("#EFPNo").text().trim();

        if (DateFrom != "") {
            textCriteria = textCriteria + "Date from " + DateFrom;
        }
        if (DateTo != "") {
            if (DateFrom != "") {
                textCriteria = textCriteria + " to " + DateTo;
            } else {
                textCriteria = textCriteria + "Date to " + DateTo;
            }
        }

        textCriteria = buildText(textCriteria, TimeFrom, "Time from");

        if (TimeTo != "") {
            if (TimeFrom != "") {
                textCriteria = textCriteria + " to " + TimeTo;
            } else {
                textCriteria = textCriteria + "Time to " + TimeTo;
            }
        }

        textCriteria = buildText(textCriteria, VehicleNo, "Vehicle No");
        textCriteria = buildText(textCriteria, JobNo, "Job No");
        textCriteria = buildText(textCriteria, CSRCode, "CSR Code");
        textCriteria = buildText(textCriteria, Username, "Username");
        if (BranchName != "All")
        {
            textCriteria = buildText(textCriteria, BranchName, "Branch Name");
        }
        if (RegionName != "All")
        {
            textCriteria = buildText(textCriteria, RegionName, "Region Name");
        }
        if (InspectionTypeName != "All")
        {
            textCriteria = buildText(textCriteria, InspectionTypeName, "Inspection Type");
        }
        textCriteria = buildText(textCriteria, EFPNo, "EFP No");

        if (textCriteria == "") {
            textCriteria = "No search criteria has been used";
        }
        $('#searchCriteria').text(textCriteria + ".");
    }

    function buildText(textCriteria, text, displayText)
    {
        if (text != "") {
            if (textCriteria != "") {
                textCriteria = textCriteria + " and " + displayText + " " + text;
            } else {
                textCriteria = textCriteria + displayText + " " + text;
            }
        }
        return textCriteria;
    }

    function generateSearchCriteria() {
        var textCriteria = "";
        var dateFrom = $('#DateFrom').val().trim();
        var dateTo = $('#DateTo').val().trim();
        var jobNo = $('#JobNo').val().trim();
        var vehicleNo = $('#VehicleNo').val().trim();
        var csrCode = $('#CSRCode').val().trim();
        var epfNo = $('#EPFNo').val().trim();
        var csrName = $('#CSRName').val().trim();
        var regionName = $("#RegionId option:selected").text().trim();
        var branchName = $("#BranchId option:selected").text().trim();

        if (dateFrom != "") {
            textCriteria = textCriteria + "Date from " + dateFrom;
        }
        if (dateTo != "") {
            if (dateFrom != "") {
                textCriteria = textCriteria + " to " + dateTo;
            } else {
                textCriteria = textCriteria + "Date to " + dateTo;
            }
        }
        if (jobNo != "") {
            if (textCriteria != "") {
                textCriteria = textCriteria + " and job no " + jobNo;
            } else {
                textCriteria = textCriteria + "Job no " + jobNo;
            }
        }
        if (vehicleNo != "") {
            if (textCriteria != "") {
                textCriteria = textCriteria + " and vehicle no " + vehicleNo;
            } else {
                textCriteria = textCriteria + "Vehicle no " + vehicleNo;
            }
        }
        if (csrCode != "") {
            if (textCriteria != "") {
                textCriteria = textCriteria + " and CSR code " + csrCode;
            } else {
                textCriteria = textCriteria + "CSR code " + csrCode;
            }
        }
        if (epfNo != "") {
            if (textCriteria != "") {
                textCriteria = textCriteria + " and EPF no " + epfNo;
            } else {
                textCriteria = textCriteria + "EPF no " + epfNo;
            }
        }
        if (csrName != "") {
            if (textCriteria != "") {
                textCriteria = textCriteria + " and CSR name " + csrName;
            } else {
                textCriteria = textCriteria + "CSR name " + csrName;
            }
        }
        if (regionName != "" && regionName != "All") {
            if (textCriteria != "") {
                textCriteria = textCriteria + " and region name " + regionName;
            } else {
                textCriteria = textCriteria + "Region name " + regionName;
            }
        }
        if (branchName != "" && branchName != "All") {
            if (textCriteria != "") {
                textCriteria = textCriteria + " and branch name " + branchName;
            } else {
                textCriteria = textCriteria + "Branch name " + branchName;
            }
        }
        if (textCriteria == "") {
            textCriteria = "No search criteria has been used";
        }
        $('#searchCriteria').text(textCriteria + ".");
    };

});
//Login action

function ShowJobCommentsPanel(){
$('#Comments').find('#successHeader').hide();
$('#Comments').find('#errorHeader').hide();
$('#comment').val('');

GetCommentsAsync();
}

function ShowVisitCommentsPanel(){

$('#VisitComments').find('#successHeaderi').hide();
$('#VisitComments').find('#errorHeaderi').hide();
$('#visitComment').val('');
//alert($('#VisitComments form').html());
//alert($($('.errorHeaderi'));
GetVisitCommentsAsync();
}

