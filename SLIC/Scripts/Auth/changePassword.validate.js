/* Change Password Form Validations 
*/

$(document).ready(function () {    

    $('#contact-form').validate({
        rules: {
            OldPassword: {
                minlength: 3,
                required: true
            },
            NewPassword: {
                minlength: 3,
                required: true
            },
            ConfirmPassword: {
                minlength: 3,
                required: true,
                equalTo: "#NewPassword"
            }
        },

        messages:{
            ConfirmPassword:{
                equalTo: "The new password and confirmation password do not match."
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

 