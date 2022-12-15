/* Create-Edit Photo Availability Form Search Validations 
*/
$(document).ready(function () {

    $(".reset").click(function () {
        $("#contact-form").validate().resetForm();
        $('.control-group').removeClass('error');
    });

    ValidateSearchForm();
    $('.form').eq(0).find('input').eq(0).focus();   

    $('#DateFrom').change(function () {
        $('#DateFrom').valid();
    });
    $('#DateTo').change(function () {
        $('#DateTo').valid();
    });


});

$.validator.addMethod("checkValidDate", function (value, element) {
    //first date in the param is Start, second is End
    //    var param = true;
    //    var months = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'];
    //    if ($("#DateFrom").val() != "") {
    //        var parts = ($("#DateFrom").val()).split('-');
    //        var day = Number(parts[0]);
    //        var month = Number(months.indexOf(parts[1].toLowerCase()));
    //        var year = Number('20' + parts[2]);

    //        var dateFrom = new Date(year, month, day)
    //        console.log(year, month, day);
    //    }

    //    if ($("#DateTo").val() != "") {
    //        var parts2 = ($("#DateTo").val()).split('-');
    //        var day2 = Number(parts2[0]);
    //        var month2 = Number(months.indexOf(parts2[1].toLowerCase()));
    //        var year2 = Number('20' + parts2[2]);

    //        var dateTo = new Date(year2, month2, day2)
    //    }

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
                    checkValidDate: true
                },

                DateTo: {
                    checkValidDate: true
                },

                CSRCode: {
                    digits:true
                }
            },
            messages: {
                DateFrom: {                    
                },
                DateTo: {                    
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

