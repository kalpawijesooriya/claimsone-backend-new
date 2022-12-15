<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Administration.RegionDataModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Controllers" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC</title>
    ///  <description>Region creation and updating page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2011-12-18</createdOn>
    ///  <author>Aruna Herath</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description> 
    ///  </modification>
    ///
    /// </summary>                                                                                 
    %>
    <script src="../../../Scripts/Admin/createRegion.validate.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <% if (Model == null)
       {%>
    <%: Resources.info_gen_createRegion %>
    <% }
       else
       {%>
    <%: Resources.info_gen_updateRegion %>
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
                    <%: Resources.info_gen_createRegion %>
                    <% }
                       else
                       { %>
                    <%: Resources.info_gen_updateRegion %>
                    <% } %>
                </h3>
            </div>
            <!-- /widget-header -->
            <div class="widget-content">
                <% using (Html.BeginForm(null, null, FormMethod.Post, new { @class = "form-horizontal", @novalidate = "novalidate", @id = "contact-form" }))
                   {%>
                <% if (Model != null)
                   { %>
                <!--Hidden Fields-->
                <%:Html.HiddenFor(x=>x.RegionId) %>
                <% } %>
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
                    <%: Html.ValidationMessageFor(model => model.RegionCode) %>
                    <%: Html.ValidationMessageFor(model => model.RegionName) %>
                </div>
                <%  } %>
                <% } %>
                <fieldset>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Resources.info_gen_regionCode %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.TextBoxFor(model => model.RegionCode, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_regionCode })%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="name">
                            <%: Resources.info_gen_regionName %></label>
                        <label class="redStar">
                            *</label>
                        <div class="controls">
                            <%: Html.TextBoxFor(model => model.RegionName, new { @class = "input-large ui-tooltip", @placement = "right", @title = Resources.info_help_regionName })%>
                        </div>
                    </div>
                    <div class="form-actions">
                        <%if ((Model == null) ? com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("CreateRegion_HTML")) : com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("UpdateRegion_HTML")))
                          { %>
                        <input type="submit" value='<%: ((Model == null) ? Resources.info_gen_createRegion : Resources.info_gen_updateRegion) %>'
                            class="btn btn-primary" title='<%: ((Model == null) ? Resources.info_gen_createRegion : Resources.info_gen_updateRegion) %>' />
                        <%} %>
                        <%: Html.ActionLink(Resources.info_gen_back, "ViewRegions", "Admin", null, new { @class = "btn btn-secondary" })%>
                    </div>
                </fieldset>
                <% } %>
            </div>
            <%--widget content--%>
        </div>
        <!--widget form-->
    </div>
</asp:Content>
