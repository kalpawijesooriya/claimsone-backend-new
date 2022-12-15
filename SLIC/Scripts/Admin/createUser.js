$(document).ready(function () {

    //Initialize User creation form
    InitializeForm();

    //Hide certain element on load (error div, loader etc)
    $('#branchTrigger').hide();
    $('#usernameTrigger').hide();
    $('#Error').hide();

    //Bind "On Role selection change" event (hide/show branch)
    $("select#RoleName").change(function () {
        hideBranch($(this).val());
        hideCSRCode($(this).val());
        hideContactNo($(this).val());   
    });

    //On region change get branch list from database
    $("select#RegionId").change(function () {

        var regionid = $("#RegionId > option:selected").attr("value");

        $.ajax({
            type: "POST",
            url: "/Job/FindBranchesByRegionId?regionId=" + regionid + "&isClaimProcessed=false",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: 'true',
            cache: 'false',
            beforeSend: function () {
                $("#branchTrigger").show();
            },
            success: function (data) {
                $('#branchTrigger').hide();
                $('#Error').hide();
                if (data && data.length > 0) {

                    if (data instanceof Array) {

                        var options = '';
                        for (p in data) {
                            var product = data[p];
                            //create html for element
                            options += "<option value='" + product.BranchId + "'>" + product.BranchName + "</option>";
                        }
                        //bind branch list to the drop down
                        $("#BranchId").removeAttr('disabled').html(options);
                    } else {
                        //alert(data);

                        $('#Error').show();
                        $("#ErrorMessage").text(data);
                    }
                } else {
                    $("#BranchId").attr('disabled', true).html('');

                }
            },
            error: function (request, status, error) {
                // alert(request);
                $("#BranchId").attr('disabled', true).html('');
                $('#branchTrigger').hide();
            }
        });
    });
});

window.onload = function () {
    $("#Validation").hide();
};

//Initialize Create/Update User Form
function InitializeForm() {
    hideBranch($("#RoleName").find(":selected").text());
    hideCSRCode($("#RoleName").find(":selected").text());
    hideContactNo($("#RoleName").find(":selected").text());
}

//Hide the branch dropdown for the role Engineer
function hideBranch(role) {
    try {
        if (role.toLowerCase() == 'engineer') {
            $("#tdBranch").hide();
            $("#tdBranchLoader").hide();
            //remove branch only from data access level
                      
            $("#DataAccessLevel option[value='2']").remove();
        } else {
            $("#tdBranch").show();
            $("#tdBranchLoader").show();
            if ($("#DataAccessLevel option[value='2']").length <= 0) {
                $('#DataAccessLevel').append("<option value='2' selected='selected'>Branch Only</option>");
            }           
        }
    } catch (e) {

    }
}

function hideCSRCode(role) {
    try {
        if (role.toLowerCase() == 'technical officer') {
            $("#tdCSRCode").show();         
        } else {
            $("#tdCSRCode").hide();          
        }
    } catch (e) {

    }
}
function hideContactNo(role) {
    try {
        if (role.toLowerCase() == 'technical officer') {
            $("#tdContactNo").show();
        } else {
            $("#tdContactNo").hide();
        }
    } catch (e) {

    }
}