<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<com.IronOne.SLIC2.Models.Job.Search>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>quick search page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-20</createdOn>
    ///  <author>Suren Manawatta</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
%>
<% using (Html.BeginForm("Search", "Job", FormMethod.Post, new { @class = "form-horizontal" }))
   {%>
<%: Html.ValidationSummary(true)%>
<fieldset class="control-group-width-half">
    <div class="control-group">
        <label class="control-label">
            <%:Resources.info_gen_jobNo%></label>
        <div class="controls">
            <%: Html.TextBoxFor(model => model.JobNo)%>
            <%: Html.ValidationMessageFor(model => model.JobNo)%>
        </div>
    </div>
</fieldset>
<fieldset class="control-group-width-half">
    <div class="control-group">
        <label class="control-label">
            <%:Resources.info_gen_vehicleNo%></label>
        <div class="controls">
            <%: Html.TextBoxFor(model => model.VehicleNo)%>
            <%: Html.ValidationMessageFor(model => model.VehicleNo)%>
        </div>
    </div>
</fieldset>
<fieldset class="form-horizontal form-actions-full">
    <div class="form-actions">
        <input type="submit" class="btn btn-primary" value="<%:Resources.info_gen_search%>" />
    </div>
</fieldset>
<% } %>