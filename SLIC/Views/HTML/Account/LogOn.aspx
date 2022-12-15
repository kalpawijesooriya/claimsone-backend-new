<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.LogOnModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
        /// <summary>
        /// 
        ///  <title>SLIC</title>
        ///  <description>Log on page for Log on to the User</description>
        ///  <copyRight>Copyright (c) 2011</copyRight>
        ///  <company>IronOne Technologies (Pvt) Ltd</company>
        ///  <createdOn>2011-08-05</createdOn>
        ///  <author></author>
        ///  <modification>
        ///     <modifiedBy>Abul Azad</modifiedBy>
        ///      <modifiedDate>23-11-2012</modifiedDate>
        ///     <description>Phase 4 UI Revamp</description>
        ///  </modification>
        ///
        /// </summary>                                                                                 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!-- Favicon-->
    <link rel="shortcut icon" type="image/png" href="../../../Content/img/favicon.ico" />
    <!-- Meta Tags-->
    <%--<meta http-equiv="X-UA-Compatible" content="IE=9" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <meta name="description" content="Sri Lanka Insurance Corporation Motor Claim System" />
    <meta name="keywords" content="Sri Lanka Insurance, Motor Claims System" />
    <meta name="author" content="IronOne Technologies LLC" />--%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <title>
        <%:Resources.info_gen_titleHeading %></title>
    <!--Styles -->
    <link href="../../../Content/css/bootstrap.css" rel="stylesheet" />
    <link href="../../../Content/css/bootstrap-overrides.css" rel="stylesheet" />
    <link href="../../../Content/css/slate.css" rel="stylesheet" />
    <link href="../../../Content/css/components/signin.css" rel="stylesheet" type="text/css" />
    <!--Note: External Style sheets have been removed and written here to improve response time!!-->
    <style type="text/css">
        #ajaxLoader
        {
            display: none;
            background: url('../Content/img/loading.gif') no-repeat;
            float: left;
            padding-left: 32px;
            padding-top: 2px;
            height: 40px;
            margin-top: 25px;
        }
        .login-actions
        {
            height: 60px !important;
        }
    </style>
    <!-- Jquery -->
    <script src="../../../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../../Scripts/MicrosoftAjax.js"></script>
    <script type="text/javascript" src="../../../Scripts/MicrosoftMvcAjax.js"></script>
    <script src="../../../Content/js/Slate/bootstrap.js" type="text/javascript"></script>
    <!--Note: External Script sheets have been removed and written here to improve response time!!-->
    <script type="text/javascript">
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

        function BeginLoginRequest() {
            $("input").attr("disabled", "disabled");
            $('.submitbutton input').hide();
        }

        function EndLoginRequest() {
            $("input").removeAttr("disabled");
            $('.submitbutton input').show();
        }

        // Clear messages  
        function clearMessages() {
            $('.error').html('');
            $('.alert-error').hide();
            $('.alert-success').hide();
            $('.alert-info').hide();
            $('.alert-block').hide();
        }

        function closePopup() {
            $('#panel').hide();
        }

        function SetMessages(success, errors) {

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
    </script>
</head>
<body onload="if(history.length>0)history.go(+1);" class="signinbody">
    <!--JavaScript Variable Resolver -->
    <% Html.RenderPartial("~/Views/HTML/Shared/JSVariableResolver.ascx"); %>
    
    <div class="account-container login">
        <div class="alert alert-error" style="display: none;">
            <a href="#" data-dismiss="alert" class="close">×</a>
            <h4 class="alert-heading">
            </h4>
            <div class="alert-data">
            </div>
        </div>
        <div class="logo">
        </div>
        <div class="content clearfix">
            <!--Form -->
            <% using (Ajax.BeginForm("LogOn", "LogOn", new { fmt = "JSON" }, new AjaxOptions { HttpMethod = "POST", LoadingElementId = "ajaxLoader", OnSuccess = "RedirectToHome", OnFailure = "handleError", OnBegin = "BeginLoginRequest" }, null))
               { %>
            <div id="validations">
                <%Html.ValidationSummary(); %>
            </div>
            <h1 class="text-center">
                <%:Resources.info_gen_signIn %></h1>
            <div id="ajaxContent" class="login-fields">
                <p class="tag">
                    <%:Resources.info_gen_signInHelp%>
                </p>
                <div class="field">
                    <label for="username">
                        <%:Resources.info_gen_userName %>:</label>
                    <%: Html.TextBoxFor(m => m.UserName, new { id = "username", type = "text", @class = "login username-field",  @placeholder = Resources.info_gen_userName })%>
                    <label class="error">
                    </label>
                </div>
                <div class="field">
                    <label for="password">
                        <%:Resources.info_gen_password %>:</label>
                    <%: Html.PasswordFor(m => m.Password, new { id = "password", type = "password", @class = "login password-field", @placeholder = Resources.info_gen_password })%>
                    <label class="error">
                    </label>
                </div>
            </div>
            <div class="login-actions">
                <%--<span class="login-checkbox">
                    <input id="Field" name="Field" type="checkbox" class="field login-checkbox" value="First Choice"
                        tabindex="4" />
                    <label class="choice" for="Field">
                        Keep me signed in</label>
                </span>--%>
                
                <input type="submit" class="button btn btn-secondary btn-large" value="<%:Resources.info_gen_signIn %>" />
                <div id="ajaxLoader" class="submitinfo">
                    <%:Resources.info_gen_loader_signIn%>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>
