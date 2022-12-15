<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Delete Incomplete Jobs
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('form input[type=submit]').click(function () {
                return confirm("Are you sure you want to delete this job? On confirmation the job will not be available in the system.");
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%  /// <summary>
                    ///  <title></title>
                    ///  <description></description>
                    ///  <copyRight>Copyright (c) yyyy</copyRight>
                    ///  <company>IronOne Technologies (Pvt)Ltd</company>
                    ///  <createdOn>yyyy-mm-dd</createdOn>
                    ///  <author></author>
                    ///  <modification>
                    ///     <modifiedBy></modifiedBy>
                    ///      <modifiedDate></modifiedDate>
                    ///     <description></description>
                    ///  </modification>
                    /// </summary> %>
    <div class="span12">
        <div class="widget widget-form">
            <div class="widget-header">
                <h3>
                    <i class="icon-search"></i>Delete Incomplete Jobs
                </h3>
            </div>
            <div class="widget-content">
                <% using (Html.BeginForm("TempDeleteJob", "Job", null, FormMethod.Post, htmlAttributes: new { @class = "form-horizontal" }))
                   { %>
                <% ModelState err = ViewContext.ViewData.ModelState["err"];
                   if (err != null)
                   {
                       com.IronOne.SLIC2.Controllers.GenException result = (com.IronOne.SLIC2.Controllers.GenException)err.Errors.ElementAt(0).Exception;

                       if (result != null)
                       { %>
                <div class="alert alert-error">
                    <a class="close" data-dismiss="alert" href="#">&times;</a>
                    <h4 class="alert-heading">
                        <%: Resources.info_gen_error %></h4>
                    <%: result.Message %>
                </div>
                <%  } %>
                <% } %>
                <%if (ViewData["SuccessMsg"] != null)
                  { %>
                <div class="alert alert-success">
                    <a class="close" data-dismiss="alert" href="#">&times;</a>
                    <h4 class="alert-heading">
                        <%: Resources.info_gen_success %></h4>
                    <%= ViewData["SuccessMsg"]%>
                </div>
                <%} %>
                <fieldset class="control-group-width-half">
                    <div class="control-group">
                        <label class="control-label">
                            <%:Resources.info_gen_jobNo%></label>
                        <div class="controls">
                            <input type="text" value="" name="JobNumber" id="JobNumber">
                        </div>
                    </div>
                </fieldset>
                <fieldset class="form-horizontal form-actions-full">
                    <div class="form-actions">
                        <input type="submit" value="Delete" class="btn btn-primary">
                    </div>
                </fieldset>
                <%} %>
            </div>
        </div>
    </div>
</asp:Content>
