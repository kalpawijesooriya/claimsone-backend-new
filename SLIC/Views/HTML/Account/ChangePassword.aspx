<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.ChangePasswordModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Controllers" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC</title>
    ///  <description>Change Password page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2011-08-05</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
    %>
    <script src="../../../Scripts/Auth/changePassword.validate.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <%: Resources.info_gen_changePassword %>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="span12">
        <div id="validation" class="widget highlight widget-form">
            <div class="widget-header">
                <h3>
                    <i class="icon-edit"></i>
                    <%: Resources.info_gen_changePassword %>
                </h3>
            </div>
            <div class="widget-content">
                <% using (Html.BeginForm("ChangePassword", "LogOn", FormMethod.Post, new { @class = "form-horizontal", @novalidate = "novalidate", @id = "contact-form" }))
                   {%>
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
                    <%: result.Message %>
                    <%: Html.ValidationMessageFor(model => model.OldPassword) %>
                    <%: Html.ValidationMessageFor(model => model.NewPassword) %>
                    <%: Html.ValidationMessageFor(model => model.ConfirmPassword) %>
                </div>
                <% } %>
                <% } %>
                <%: Html.ValidationSummary(true) %>
                <fieldset>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Resources.info_gen_currentPassword %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.PasswordFor(model => model.OldPassword, new { id = "OldPassword", @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_oldPassword })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Resources.info_gen_newPassword %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%--, OnKeyPress = "return AlphanumericValidation(event);"--%>
                            <%: Html.PasswordFor(model => model.NewPassword, new { id = "NewPassword", @class = "input-large ui-tooltip", @title = Resources.info_help_newPassword })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Resources.info_gen_confirmNewPassword %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.PasswordFor(model => model.ConfirmPassword, new { id = "ConfirmPassword", @class = "input-large ui-tooltip", @title = Resources.info_help_confirmNewPassword })%>
                        </div>
                    </div>
                    <div class="form-actions">
                        <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("ChangePassword_HTML")))
                          { %>
                        <input type="submit" class="btn btn-primary" value="<%: Resources.info_gen_changePassword %>" />
                        <%} %>
                        <%: Html.ActionLink(Resources.info_gen_back, "Index", "Default", null, new { @class = "btn btn-secondary" })%>
                    </div>
                </fieldset>
                <% } %>
            </div>
        </div>
    </div>
</asp:Content>
