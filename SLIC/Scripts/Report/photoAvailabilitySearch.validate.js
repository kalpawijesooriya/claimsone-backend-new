/* Create-Edit Photo Availability Form Search Validations 
*/
$(document).ready(function () {

    $(".reset").click(function () {
        $("#contact-form").validate().resetForm();
    });

    ValidateSearchForm();
    $('.form').eq(0).find('input').eq(0).focus();

    $('#DateFrom').change(function () {
        ValidateSearchForm();
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
                }
            },
            messages: {
                DateFrom: {
                    required: "Please select a valid date range"
                },
                DateTo: {
                    required: "Please select a valid date range",
                    checkValidDate: ""

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

