/* Create-Edit Region Form Validations 
*/

$(document).ready(function () {

    jQuery.validator.addMethod("lettersonly", function (value, element) {
        return this.optional(element) || /^[a-z\s]+$/i.test(value);
    }, "Digits not allowed");

    $('#contact-form').validate({
        rules: {
            RegionCode: {
                minlength: 2,
                required: true
            },
            RegionName: {
                required: true,
                lettersonly: true,
                minlength: 3


            }
        },
        focusCleanup: false,

        highlight: function (label) {
            $(label).closest('.control-group').removeClass('success').addClass('error');
        },
        success: function (label) {
            label
	    		.text('OK!').addClass('valid')
	    		.closest('.control-group').addClass('success');
        },
        errorPlacement: function (error, element) {
            error.appendTo(element.parents('.controls'));
        }
    });
    $('.form').eq(0).find('input').eq(0).focus();

}); // end document.ready