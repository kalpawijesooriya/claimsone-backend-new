// 
//	jQuery Validate example script
//
//	Prepared by David Cochran
//	
//	Free for your use -- No warranties, no guarantees!
//

$(document).ready(function () {
    // Validate
    // http://bassistance.de/jquery-plugins/jquery-plugin-validation/
    // http://docs.jquery.com/Plugins/Validation/
    // http://docs.jquery.com/Plugins/Validation/validate#toptions
});

function validateCommentForm() {
    $('#Comments #contact-form').validate({
        rules: {

            // Suren Manawatta
            // 2012-12-07            

            // Comment Add Form Validations STARTS
            comment: {
                minlength: 5,
                required: true
            }
            // Comment Add Form Validations ENDS
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
}