<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<com.IronOne.SLIC2.Models.Visit.VisitDetailModel>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%  /// <summary>
    ///  <title></title>
    ///  <description>Partial View for</description>
    ///  <copyRight>Copyright (c) yyyy</copyRight>
    ///  <company>IronOne Technologies (Pvt)Ltd</company>
    ///  <createdOn>20yy-mm-dd</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    /// </summary> %>
<style type="text/css">
    body
    {
        font-size: 15px;
    }
    
    .control-group .control-label
    {
        font-weight: bold;
        text-align: left;
        font-size: 15px;
        vertical-align: top;
    }
    
    .widget-content h3
    {
        text-decoration: underline;
        font-weight: normal;
        padding-bottom: 15px;
    }
    
    .control-group .colon
    {
        width: 5px;
        display: block;
        float: left;
    }
    .widget-header h3
    {
        font-size: 20px;
    }
    .widget-content
    {
        padding-top: 9px !important;
        padding-bottom: 0px !important;
    }
</style>
<style type="text/css" media="print">
    body
    {
        font-size: 15px;
    }
    
    .control-group .control-label
    {
        font-weight: bold;
        text-align: left;
        font-size: 15px;
        vertical-align: top;
    }
    
    .widget-content h3
    {
        text-decoration: underline;
        font-weight: normal;
        padding-bottom: 15px;
    }
    
    .control-group .colon
    {
        width: 5px;
        display: block;
        float: left;
    }
    .widget-header h3
    {
        font-size: 20px;
    }
    .widget-content
    {
        padding-top: 9px !important;
        padding-bottom: 0px !important;
    }
</style>
<%if (Model != null)
  { %>
<div class="widget-content">
    <fieldset class="form-horizontal">
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_jobNo%></label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.JobNo %></div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_inspectionType%></label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.InspectionType%></div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_chassisNo%></label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.ChassisNo %></div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_engineNo%></label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.EngineNo %></div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_visitedDate%></label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.VisitedDate.ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateOnlyFormat) %></div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_visitedBy%></label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.CreatedByFullName %></div>
        </div>
    </fieldset>
</div>
<div class="widget-content VisitComments">
    <h3>
        Visit Comments</h3>
    <%Html.RenderPartial("~/Views/HTML/Shared/Job/PrintComments.ascx", Model.Comments); %>
</div>
<%} %>