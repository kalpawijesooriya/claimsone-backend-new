/* Create-Edit Photo Availability Form Search Validations 
*/
$(document).ready(function () {

    $(".reset").click(function () {
        $("#contact-form").validate().resetForm();
    });

    ValidateSearchForm();
    $('.form').eq(0).find('input').eq(0).focus();

    $('#DateFrom').change(function () {
        $('#DateFrom').valid();
    });
    $('#DateTo').change(function () {
        $('#DateTo').valid();
        $('#DateFrom').valid();
    });
    $('#TimeFrom').change(function () {
        $('#TimeFrom').valid();
    });
    $('#TimeTo').change(function () {
        $('#TimeTo').valid();
        $('#TimeFrom').valid();
    });
   


});

$.validator.addMethod("checkValidDate", function (value, element) {

    var months = { jan: 0, feb: 1, mar: 2, apr: 3, may: 4, jun: 5,
        jul: 6, aug: 7, sep: 8, oct: 9, nov: 10, dec: 11
    };

    if ($("#DateFrom").val() != "") {
        var val = ($("#DateFrom").val()).split('-');
        var dateFrom = new Date(val[2], months[val[1].toLowerCase()], val[0]);
    }

    if ($("#DateTo").val() != "") {
        var val2 = ($("#DateTo").val()).split('-');
        var dateTo = new Date(val2[2], months[val2[1].toLowerCase()], val2[0]);
    }
    var param = true;
    if ($("#DateTo").val() != "" && dateFrom > dateTo) {
        param = false;
    }
    return param;
}, "Date From value exceeds the Date To value. Please select a valid date range.");

$.validator.addMethod("checkACRRange", function (value, element) {


    if ($("#ACRFrom").val() != "") {
        var ACRFrom = $("#ACRFrom").val();
        ACRFrom = parseFloat(ACRFrom);
    }

    if ($("#ACRTo").val() != "") {
        var ACRTo = $("#ACRTo").val();
        ACRTo = parseFloat(ACRTo);
    }
    var param = true;
    if ($("#ACRFrom").val() != "" && $("#ACRTo").val() != "" && ACRFrom > ACRTo) {
        param = false;
    }
    return param;

}, "ACR From value exceeds the ACR To value. Please enter a valid ACR range.");


$.validator.addMethod("checkValidTime", function (value, element) {

    var timeFrom = ($("#TimeFrom").val() != "") ? getCorrectTime($("#TimeFrom").val()) : "";
    var timeTo = ($("#TimeTo").val() != "") ? getCorrectTime($("#TimeTo").val()) : "";


    var params = true;
    if (timeFrom != "" && timeTo != "" && timeFrom > timeTo)
        params = false;

    return params
}, "Time From value exceeds the Time To value. Please enter a valid Time range.");

function getCorrectTime(value) {
    var time = value;
    var hours = Number(time.match(/^(\d+)/)[1]);
    var minutes = Number(time.match(/:(\d+)/)[1]);
    var AMPM = time.match(/\s(.*)$/)[1];
    if (AMPM == "pm" && hours < 12) hours = hours + 12;
    if (AMPM == "am" && hours == 12) hours = hours - 12;
    var sHours = hours.toString();
    var sMinutes = minutes.toString();
    if (hours < 10) sHours = "0" + sHours;
    if (minutes < 10) sMinutes = "0" + sMinutes;
    var result = sHours + ":" + sMinutes;
    return result;
}


function ValidateSearchForm() {

    $('#contact-form').validate({
        rules: {
            DateFrom: {
                required: true,
                checkValidDate: true
            },

            DateTo: {
                required: true,
                checkValidDate: true
            },
            ACRFrom: {
                number: true,
                checkACRRange: true
            },
            ACRTo: {
                number: true,
                checkACRRange: true
            },
            TimeFrom: {
                checkValidTime: true
            },
            TimeTo: {
                checkValidTime: true
            }

        },
        messages: {
            DateFrom: {
                required: "Please select a valid date range"
            },
            DateTo: {
                required: "Please select a valid date range",
                checkValidDate: ""
            },
            ACRFrom: {
                number: "Please enter a valid amount."
            },
            ACRTo: {
                number: "Please enter a valid amount.",
                checkACRRange: ""
            },
            TimeTo: {
                checkValidTime:""
            }
        },

        focusCleanup: false,

        highlight: function (label) {
            $(label).closest('.control-group').removeClass('success').addClass('error');
        },
        success: function (label) {
            label
	    		.closest('.control-group').removeClass('error');
        },
        errorPlacement: function (error, element) {
            error.appendTo(element.parents('.controls'));
        }
    });
}
// end document.ready

