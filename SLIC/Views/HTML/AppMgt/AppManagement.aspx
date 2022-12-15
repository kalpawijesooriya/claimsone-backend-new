<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Administration.AppDataModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Controllers" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC</title>
    ///  <description>App settings updating page</description>
    ///  <copyRight>Copyright (c) 2016</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2016-12-08</createdOn> 
    ///  <author>Suren Manawatta</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
    %>
    <script type="text/javascript">
        $(document).ready(function () {

            // Validate
            // http://bassistance.de/jquery-plugins/jquery-plugin-validation/
            // http://docs.jquery.com/Plugins/Validation/
            // http://docs.jquery.com/Plugins/Validation/validate#toptions

            ValidateCreateUserForm();
            $('.form').eq(0).find('input').eq(0).focus();
        });
        // end document.ready
        $.validator.addMethod("checkdecimal", function (value, element) {
            var num = $("#MaximumAllowedDraftsCount").val();
            if ($.isNumeric(num)) {
                return this.optional(element) || num % 1 == 0
            }
            else
                return true;
        }, "Decimal values are not allowed");

        $.validator.addMethod("checkzero", function (value, element) {
            var num = $("#MaximumAllowedDraftsCount").val();
            return this.optional(element) || num != 0
        }, "Value cannot be zero");


        function ValidateCreateUserForm() {
            $('#contact-form').validate({
                rules: {
                    // Suren Manawatta
                    // 2016-12-08            

                    // User Form Validations STARTS
                    CurrentWebVersion: {
                        minlength: 5,
                        maxlength: 11,
                        required: true
                    },
                    MinimumSupportedAppVersion: {
                        minlength: 5,
                        maxlength: 11,
                        required: true
                    },
                    LatestAppVersionInTheStore: {
                        minlength: 5,
                        maxlength: 11,
                        required: true
                    },
                    StoreAppUrl: {
                        required: true
                    },
                    MaximumAllowedDraftsCount: {
                        required: true,
                        minlength: 1,
                        maxlength: 3,
                        number:true,
                        checkdecimal: true,
                        checkzero:true
                        
                    }
                },
                messages: {
                    CurrentWebVersion: {
                        rangelength: "Please enter only 4 characters"
                    },
                    MaximumAllowedDraftsCount: {
                        required:"Please enter a valid number",
                        number: "Please enter only digits"
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
    </script>
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    App Management
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="span12">
        <div id="horizontal" class="widget widget-form">
            <div class="widget-header">
                <h3>
                    <i class="icon-pencil"></i>
                    <%: Resources.info_menu_appmanagement%>
                </h3>
            </div>
            <!-- /widget-header -->
            <div class="widget-content">
                <% using (Html.BeginForm(null, null, FormMethod.Post, new { @class = "form-horizontal", @novalidate = "novalidate", @id = "contact-form" }))
                   {%>
                <%:Html.AntiForgeryToken() %>
                <% ModelState err = ViewContext.ViewData.ModelState["err"];
                   if (err != null)
                   {
                       GenException result = (GenException)err.Errors.ElementAt(0).Exception;

                       if (result.Code == 120)
                       { %>
                <div class="alert alert-success">
                    <a class="close" data-dismiss="alert" href="#">&times;</a>
                    <h4 class="alert-heading">
                        <%: Resources.info_gen_success %></h4>
                    <%: result.Message %>
                </div>
                <% }
                   else
                   { %>
                <div class="alert alert-error">
                    <a class="close" data-dismiss="alert" href="#">&times;</a>
                    <h4 class="alert-heading">
                        <%: Resources.info_gen_error %></h4>
                    <%--<%: result.Message %>--%>
                    <%: MvcHtmlString.Create(HttpUtility.HtmlDecode(result.Message))%>
                </div>
                <% } %>
                <%  } %>
                <% if (Model != null)
                   { %>
                <!--Hidden Fields-->
                <% } %>
                <fieldset>
                    <div class="control-group">                
                        <label class="control-label" for="name">
                            <%: Html.LabelFor(model => model.CurrentWebVersion) %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.TextBoxFor(model => model.CurrentWebVersion, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_app_management })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Html.LabelFor(model => model.MinimumSupportedAppVersion)%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.TextBoxFor(model => model.MinimumSupportedAppVersion, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_app_management })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Html.LabelFor(model => model.LatestAppVersioninGooglePlay)%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.TextBoxFor(model => model.LatestAppVersioninGooglePlay, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_app_management })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Html.LabelFor(model => model.ForceLatestVersionToUsers)%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.CheckBoxFor(model => model.ForceLatestVersionToUsers, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_app_management_force1 + " " + Resources.info_help_app_management_force2 })%>
                            <br />
                            <b>Caution:</b>
                            <%:Resources.info_help_app_management_force1%><br />
                            <%:Resources.info_help_app_management_force2%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Html.LabelFor(model => model.GooglePlayAppURL)%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.TextBoxFor(model => model.GooglePlayAppURL, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_app_management_store })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Html.LabelFor(model => model.MaximumAllowedDraftsCount)%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.TextBoxFor(model => model.MaximumAllowedDraftsCount, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_maximumAllowedDraftsCount })%>
                        </div>
                    </div>
                    <div class="form-actions">
                        <input type="submit" value='Save' class="btn btn-primary" title='Save' />
                    </div>
                </fieldset>
                <% } %>
            </div>
            <%--/widget content--%>
        </div>
        <!--widget form-->
    </div>
</asp:Content>
