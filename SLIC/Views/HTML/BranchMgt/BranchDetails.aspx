<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Administration.BranchDataModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Controllers" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC</title>
    ///  <description>Branch creation and updating page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2011-12-18</createdOn> 
    ///  <author>Suren Manawatta</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
    %>
    <script src="../../../Scripts/Admin/createBranch.validate.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <% if (Model == null)
       {%>
    <%: Resources.info_gen_createBranch %>
    <% }
       else
       {%>
    <%: Resources.info_gen_updateBranch %>
    <%}%>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="span12">
        <div id="horizontal" class="widget widget-form">
            <div class="widget-header">
                <h3>
                    <i class="icon-pencil"></i>
                    <% if (Model == null)
                       { %>
                    <%: Resources.info_gen_createBranch %>
                    <% }
                       else
                       { %>
                    <%: Resources.info_gen_updateBranch %>
                    <% } %>
                </h3>
            </div>
            <!-- /widget-header -->
            <div class="widget-content">
                <% using (Html.BeginForm(null, null, FormMethod.Post, new { @class = "form-horizontal", @novalidate = "novalidate", @id = "contact-form" }))
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
                    <%:Html.ValidationSummary()%>
                </div>
                <% } %>
                <%  } %>
                <% if (Model != null)
                   { %>
                <!--Hidden Fields-->
                <%:Html.HiddenFor(x=>x.BranchId) %>
                <% } %>
                <fieldset>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Resources.info_gen_regionName %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.DropDownListFor(model => model.RegionId, (IEnumerable<SelectListItem>)(ViewData["Regions"]), new { id = "RegionId", @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_selectRegion })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Resources.info_gen_branchCode%></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.TextBoxFor(model => model.BranchCode, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_branchCode })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Resources.info_gen_branchName %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.TextBoxFor(model => model.BranchName, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_branchName })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Resources.info_gen_branchAddress %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.TextAreaFor(model => model.Address, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_branchAddress })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%:Resources.info_gen_claimProcessed%>
                        </label>
                        <div class="controls">
                            <%: Html.CheckBoxFor(model => model.IsClaimProcessed)%>
                        </div>
                    </div>
                    <div class="form-actions">
                        <%if ((Model == null) ? com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("CreateBranch_HTML")) : com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("UpdateBranch_HTML")))
                          { %>
                        <input type="submit" value='<%: ((Model == null) ? Resources.info_gen_createBranch : Resources.info_gen_updateBranch) %>'
                            class="btn btn-primary" title='<%: ((Model == null) ? Resources.info_gen_createBranch : Resources.info_gen_updateBranch) %>' />
                        <%} %>
                        <%: Html.ActionLink(Resources.info_gen_back, "ViewBranches", "Admin", null, new { @class = "btn btn-small btn-secondary" })%>
                    </div>
                </fieldset>
                <% } %>
            </div>
            <%--/widget content--%>
        </div>
        <!--widget form-->
    </div>
</asp:Content>
