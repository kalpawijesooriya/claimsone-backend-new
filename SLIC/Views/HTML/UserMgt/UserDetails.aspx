<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Administration.UserDataModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Controllers" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%  
    /// <summary>
    /// 
    ///  <title>SLIC</title>
    ///  <description>User creation and updating page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2011-12-18</createdOn>
    ///  <author>Kumudu Wickramanayake</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
    %>
    <script src="../../../Scripts/Admin/createUser.js" type="text/javascript"></script>
    <script src="../../../Scripts/Admin/createUser.validate.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <% bool isEdit = !(Model == null || Model.Id == 0 || (ViewData["ProfileEdit"] != null && (bool)ViewData["ProfileEdit"])) ? true : false; %>
    <% if (!isEdit)
       { %>
    <%: Resources.info_gen_createUser%>
    <% }
       else
       { %>
    <%: Resources.info_gen_updateUser%>
    <% } %>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <%
        bool isEdit = (!(Model == null || Model.Id == 0) || (ViewData["ProfileEdit"] != null && (bool)ViewData["ProfileEdit"])) ? true : false;
        //com.IronOne.SLIC2.Models.Administration.UserDataModel user = (Session["LoggedUserDetail"] != null) ? Session["LoggedUserDetail"] as com.IronOne.SLIC2.Models.Administration.UserDataModel : null;

        bool isManager = (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsManagement(User.Identity.Name) && User.Identity.Name.ToLower() != Model.Username.ToLower());
    %>
    <div class="span12">
        <div id="validation" class="widget highlight widget-form">
            <div class="widget-header">
                <h3>
                    <i class="icon-pencil"></i>
                    <% if (!isEdit)
                       { %>
                    <script type="text/javascript">
                        // Set Branch Only as Default Data Access Level
                        $(document).ready(function () {
                            $('#DataAccessLevel').val(2);
                        }); 
                    </script>
                    <%: Resources.info_gen_createUser%>
                    <% }
                       else
                       { %>
                    <%: Resources.info_gen_updateUser%>
                    <% } %>
                </h3>
            </div>
            <!-- /widget-header -->
            <div class="widget-content">
                <% using (Html.BeginForm(null, null, FormMethod.Post, new { @class = "form-horizontal", @novalidate = "novalidate", @id = "contact-form" }))
                   {%>
                <% /* DO NOT REMOVE the ANTIFORGERYTOKEN KEY.
                       * This is done to avoid Cross Site Request Forgery.                     
                       This token will be validated on the action.                       
                       */
                %>
                <%:Html.AntiForgeryToken() %>
                <%:Html.Hidden("IsEdit",isEdit) %>
                <%if (isEdit)
                  { %>
                <%// Do not remove this hidden fields. Need for validations for different cases /Create /Update /ProfileEdit %>
                <%:Html.HiddenFor(model=>model.Id) %>
                <%:Html.HiddenFor(model => model.Username) %>
                <%:Html.HiddenFor(model => model.CurrentRoleName)%>
                <%} %>
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
                    <%:Html.ValidationSummary() %>
                </div>
                <%  } %>
                <% } %>
                <fieldset>
                    <div class="control-group">
                        <label class="control-label" for="Username">
                            <%:Resources.info_gen_userName %></label>
                        <% if (!isEdit)
                           { %>
                        <label class="redStar">
                            *</label>
                        <% } %>
                        <div class="controls">
                            <!-- TODO: remove if else-->
                            <%if (!isEdit)
                              { %>
                            <%: Html.TextBoxFor(model => model.Username, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_userName })%>
                            <% }
                              else
                              { %>
                            <%:Html.TextBoxFor(model => model.Username, new { @disabled = true })%>
                            <% } %>
                            &nbsp;
                            <img src="../../../../Content/img/loading.gif" alt="Loading..." width="20" height="20"
                                id="usernameTrigger" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="RoleName">
                            <%:Resources.info_gen_userRole%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <% if ((ViewData["ProfileEdit"] != null && (bool)ViewData["ProfileEdit"]))
                               { %>
                            <%:Html.HiddenFor(model => model.RoleName)%>
                            <%// Do not remove this hidden fields. Need for validations for /ProfileEdit %>
                            <%: Html.DropDownListFor(model => model.RoleName, (IEnumerable<SelectListItem>)(ViewData["Roles"]), new { id = "RoleName", disabled = true })%>
                            <% }
                               else
                               { %>
                            <%: Html.DropDownListFor(model => model.RoleName, (IEnumerable<SelectListItem>)(ViewData["Roles"]), new { id = "RoleName" }) %>
                            <% } %>
                        </div>
                    </div>
                    <div id="tdCSRCode" class="control-group">
                        <label class="control-label" for="CSRCode">
                            <%:Resources.info_gen_csrCode %>
                        </label>
                        <label class="redStar">
                            *</label>
                        <label class="redStar" id="CSRCode-redStar">
                        </label>
                        <div class="controls">
                            <% if ((ViewData["ProfileEdit"] != null && (bool)ViewData["ProfileEdit"]) || com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsManagement(User.Identity.Name))
                               { %>
                            <%:Html.HiddenFor(model=>model.CSRCode) %>
                            <%// Do not remove this hidden fields. Need for validations for /ProfileEdit %>
                            <%: Html.TextBoxFor(model => model.CSRCode, new { @class = "input-large ui-tooltip", disabled = true }) %>
                            <% }
                               else
                               { %>
                            <%: Html.TextBoxFor(model => model.CSRCode, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_csrCode }) %>
                            <% } %>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="EPFNo">
                            <%:Resources.info_gen_epfNo%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <% if ((ViewData["ProfileEdit"] != null && (bool)ViewData["ProfileEdit"]) || com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsManagement(User.Identity.Name))
                               { %>
                            <%:Html.HiddenFor(model => model.EPFNo)%>
                            <%// Do not remove this hidden fields. Need for validations for /ProfileEdit %>
                            <%: Html.TextBoxFor(model => model.EPFNo, new { @class = "input-large ui-tooltip", disabled = true })%>
                            <% }
                               else
                               { %>
                            <%: Html.TextBoxFor(model => model.EPFNo, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_epfNo ,@type = "number" })%>
                            <% } %>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="FirstName">
                            <%:Resources.info_gen_firstName%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <% if (!isManager)
                               { %>
                            <%:Html.TextBoxFor(model => model.FirstName, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_firstName })%>
                            <% }
                               else
                               { %>
                            <%:Html.HiddenFor(model => model.FirstName)%>
                            <%// Do not remove this hidden fields. Need for validations for /ProfileEdit %>
                            <%: Html.TextBoxFor(model => model.FirstName, new { @class = "input-large ui-tooltip", @placement = "right", disabled = true })%>
                            <% } %>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="LastName">
                            <%:Resources.info_gen_lastName%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <% if (!isManager)
                               { %>
                            <%:Html.TextBoxFor(model => model.LastName, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_lastName })%>
                            <% }
                               else
                               { %>
                            <%:Html.HiddenFor(model => model.LastName)%>
                            <%// Do not remove this hidden fields. Need for validations for /ProfileEdit %>
                            <%: Html.TextBoxFor(model => model.LastName, new { @class = "input-large ui-tooltip", @placement = "right",  disabled = true })%>
                            <% } %>
                            <%-- <%:Html.TextBoxFor(model => model.LastName, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_lastName })%>--%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="Email">
                            <%:Resources.info_gen_email%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <% if (!isManager)
                               { %>
                            <%:Html.TextBoxFor(model => model.Email, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_email })%>
                            <% }
                               else
                               { %>
                            <%:Html.HiddenFor(model => model.Email)%>
                            <%// Do not remove this hidden fields. Need for validations for /ProfileEdit %>
                            <%: Html.TextBoxFor(model => model.Email, new { @class = "input-large ui-tooltip", @placement = "right", disabled = true })%>
                            <% } %>
                            <%-- <%:Html.TextBoxFor(model => model.Email, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_email })%>--%>
                        </div>
                    </div>
                    <div id="tdContactNo" class="control-group">
                        <label class="control-label" for="ContactNo">
                            <%:Resources.info_gen_ContactNo %>
                        </label>
                        <label class="redStar">
                            *</label>
                        <label class="redStar" id="ContactNo-redStar">
                        </label>
                        <div class="controls">
                            <% if ((ViewData["ProfileEdit"] != null && (bool)ViewData["ProfileEdit"]) || com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsManagement(User.Identity.Name))
                               { %>
                            <%:Html.HiddenFor(model=>model.ContactNo) %>
                            <%// Do not remove this hidden fields. Need for validations for /ProfileEdit %>
                            <%: Html.TextBoxFor(model => model.ContactNo, new { @class = "input-large ui-tooltip", disabled = true } )%>
                            <% }
                               else
                               { %>
                            <%: Html.TextBoxFor(model => model.ContactNo, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_ContactNo })%>
                            <% } %>
                        </div>
                    </div>
                    <%if (!isEdit)
                      { %>
                    <div class="control-group">
                        <label class="control-label" for="Password">
                            <%:Resources.info_gen_password %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%:Html.PasswordFor(model => model.Password, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_password })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="ConfirmPassword">
                            <%:Resources.info_gen_confirmNewPassword %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%:Html.PasswordFor(model => model.ConfirmPassword, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_confirmPassword})%>
                        </div>
                    </div>
                    <% } %>
                    <div class="control-group">
                        <label class="control-label" for="RegionId">
                            <%:Resources.info_gen_region%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <% if ((ViewData["ProfileEdit"] != null && (bool)ViewData["ProfileEdit"]) || com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsManagement(User.Identity.Name))
                               { %>
                            <%:Html.HiddenFor(model => model.RegionId)%>
                            <%// Do not remove this hidden fields. Need for validations for /ProfileEdit %>
                            <%: Html.TextBoxFor(model => model.RegionName, new { id = "RegionId", disabled = true })%>
                            <% }
                               else
                               { %>
                            <%:Html.DropDownListFor(model => model.RegionId, (IEnumerable<SelectListItem>)(ViewData["Regions"]), new { id = "RegionId", @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_userRegion })%>
                            <% } %>
                        </div>
                    </div>
                    <div id="tdBranch" class="control-group">
                        <label class="control-label" for="BranchId">
                            <%:Resources.info_gen_branch%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <% if ((ViewData["ProfileEdit"] != null && (bool)ViewData["ProfileEdit"]) || com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsManagement(User.Identity.Name))
                               { %>
                            <%:Html.HiddenFor(model => model.BranchId)%>
                            <%// Do not remove this hidden fields. Need for validations for /ProfileEdit %>
                            <%: Html.TextBoxFor(model => model.BranchName, new { id = "BranchId", disabled = true })%>
                            <% }
                               else
                               { %>
                            <%:Html.DropDownListFor(model => model.BranchId, (IEnumerable<SelectListItem>)(ViewData["Branches"]), new { id = "BranchId", @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_userBranch })%>
                            <% } %>
                        </div>
                        <div id="tdBranchLoader">
                            <img src="../../../../Content/img/loading.gif" alt="Loading..." width="20" height="20"
                                id="branchTrigger" />
                        </div>
                    </div>
                    <% if ((ViewData["ProfileEdit"] != null && (bool)ViewData["ProfileEdit"]) || com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsManagement(User.Identity.Name))
                       { %>
                    <%:Html.HiddenFor(model => model.DataAccessLevel)%>
                    <%}
                       else
                       { %>
                    <div class="control-group">
                        <label class="control-label" for="DataAccessLevel">
                            Data access level</label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.DropDownListFor(model => model.DataAccessLevel, (IEnumerable<SelectListItem>)ViewData["AccessLevels"],new {  @class = "input-large ui-tooltip", @placement = "right", @title = "Please select access level" })%>
                        </div>
                    </div>
                    <%}%>
                    <div class="form-actions">
                        <input type="submit" value='<%: ((!isEdit) ? Resources.info_gen_createUser : Resources.info_gen_updateUser) %>'
                            class="btn btn-primary" title='<%: ((!isEdit) ? Resources.info_gen_createUser : Resources.info_gen_updateUser) %>' />
                        <% if ((ViewData["ProfileEdit"] != null && (bool)ViewData["ProfileEdit"]))
                           { %>
                        <%: Html.ActionLink(Resources.info_gen_back, "Index", "Default", null, new { @class = "btn btn-secondary" })%>
                        <% }
                           else
                           { %>
                        <%: Html.ActionLink(Resources.info_gen_back, "ViewUsers", "Admin", null, new { @class = "btn btn-secondary" })%>
                        <%} %>
                    </div>
                </fieldset>
                <%} %>
            </div>
            <!-- /widget-content -->
        </div>
    </div>
</asp:Content>
