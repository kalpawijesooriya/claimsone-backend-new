$(document).ready(function () {

    // Validate
    // http://bassistance.de/jquery-plugins/jquery-plugin-validation/
    // http://docs.jquery.com/Plugins/Validation/
    // http://docs.jquery.com/Plugins/Validation/validate#toptions
    if ($("#Id").val() > 0) {
        ValidateUpdateUserForm();
    } else {
        ValidateCreateUserForm();
    }

    $('.form').eq(0).find('input').eq(0).focus();
});
// end document.ready 

function ValidateCreateUserForm() {

    var branchDependency = function () {
        return Boolean($("#RoleName").val() != 'Engineer');
    };

    var requiredWhen = function () {
        return Boolean($("#RoleName").val() == 'Technical Officer');
    };

    $('#contact-form').validate({
        rules: {
            // Suren Manawatta
            // 2012-12-07            

            // User Form Validations STARTS
            Username: {
                minlength: 3,             
                required: true
                //  ,usernameCheck: true
            },
            CSRCode: {
                required: { depends: requiredWhen }
            },
            EPFNo: {
                rangelength: [0, 5],
                required: true
            },
            FirstName: {              
                required: true
            },
            LastName: {              
                required: true
            },
            Email: {
                required: true,
                email: true
            },
            ContactNo: {
                minlength: 10,
                maxlength: 10,
                //rangelength: [09, 11],
                required: true,
                //PhoneNumber:true
            },
            Password: {
                minlength: 3,
                required: true
            },
            ConfirmPassword: {
                minlength: 3,
                equalTo: "#Password"
            },
            RoleName: {
                notNone: true
            },
            RegionId: {
                notNone: true
            }
           ,
            BranchId: {
                notNone: { depends: branchDependency }
            },
            DataAccessLevel: {
                notNone: true
            }
            // User Form Validations ENDS            
        },
        messages: {         
            EPFNo: {
                rangelength: "Please enter only 5 characters"           
            }
        },
        focusCleanup: false,

        highlight: function (label) {
            $(label).closest('.control-group').removeClass('success').addClass('error');
        },
        success: function (label) {
            //debugger;
            // alert("All Success");
            label
	    		.text('OK!').addClass('valid')
	    		.closest('.control-group').addClass('success');
        },
        errorPlacement: function (error, element) {
            //  debugger;
            //  alert(error);
            error.appendTo(element.parents('.controls'));
        }
    });
}
// end func.ValidateCreateUserForm

function ValidateUpdateUserForm() {

    var branchDependency = function () {
        return Boolean($("#RoleName").val() != 'Engineer');
    };

    $('#contact-form').validate({
        rules: {
            // Suren Manawatta
            // 2012-12-07            

            // User Form Validations STARTS
            Username: {
                minlength: 3,          
                required: true
            },
            CSRCode: {               
                required: true
            },
            EPFNo: {
                rangelength: [0, 5],
                required: true
            },
            FirstName: {               
                required: true
            },
            LastName: {              
                required: true
            },
            Email: {
                required: true,
                email: true
            },
            ContactNo: {
                //rangelength: [10, 12],
                minlength: 10,
                maxlength: 10,
                required: true,
                //PhoneNumber: true
            },
            RoleName: {
                notNone: true
            },
            RegionId: {
                notNone: true
            },
            BranchId: {
                notNone: { depends: branchDependency }
            },
            DataAccessLevel: {
                notNone: true
            }
            // User Form Validations ENDS            
        }, 
        messages: {
            EPFNo: {
                rangelength: "Please enter only 5 characters"
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
}
// end func.ValidateUpdateUserForm