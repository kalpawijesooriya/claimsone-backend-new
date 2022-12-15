<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<com.IronOne.SLIC2.Models.Visit.VisitDetailModel>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>visit data view page</description>
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
<script src="../../../../Content/js/media/js/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="../../../../Content/js/media/js/TableTools.min.js" type="text/javascript"></script>
<script src="../../../../Content/js/media/js/ZeroClipboard.js" type="text/javascript"></script>
<script src="../../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.js"
    type="text/javascript"></script>
<script type="text/javascript">
    function GetVisitDetailsAsync(visitId) {

        var actionUrl = '<%: Html.ActionLink(" ", "GetVisitDetailsAjaxHandler", "Job", null, null) %>';
        actionUrl = actionUrl.replace('<a href="', '');
        actionUrl = actionUrl.replace('"> </a>', '');
        actionUrl = actionUrl.replace('amp;', '');
        actionUrl = actionUrl.replace('amp;', '');

        $.ajax({
            type: "POST",
            url: actionUrl + "?fmt=JSON",
            contentType: "application/x-www-form-urlencoded",
            data: { 'visitId': visitId },
            dataType: "json",

            success: function (data) {
                try {
                    AssignVisitDataToPopup(data);
                } catch (e) {
                }
            },
            error: function () {
            },
            complete: function () {
            }
        });
    }

    function AssignVisitDataToPopup(data) {
        try {
            var rslt = data.result;
            for (var property in rslt) {
                var value = rslt[property];
                //Set values to text boxes
                $('#VisitInfo form').find("[name='" + property + "']").val(value);     
                //Set values to date types 
                if (value != null && value.toString() != null && value.toString().indexOf("/Date(") != -1) {
                    var dateTimeFormat = '<%: ApplicationSettings.GetDateOnlyFormat %>';
                    var matches = value.match(/([0-9]+)/);
                    var d = parseInt(matches[0]);
                    var convDate = new Date(d).format(dateTimeFormat);
                    $('#VisitInfo form').find("[name='" + property + "']").val(convDate);
                }
            }
        } catch (e) {
        }
    }
</script>
<link href="../../../../Content/js/media/css/TableTools.css" rel="stylesheet" type="text/css" />
<link href="../../../../Content/js/media/css/TableTools_JUI.css" rel="stylesheet"
    type="text/css" />
<link href="../../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.css"
    rel="stylesheet" type="text/css" />
<div class="widget">
    <div class="widget-content">
        <div class="tab-content">
            <div class="tab-pane active" id="VisitInfo">
                <div id="Div2" class="widget widget-form">
                    <form class="form-horizontal" id="VisitDetailsPopup">
                    <fieldset>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_chassisNo%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.ChassisNo) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_engineNo%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.EngineNo)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_inspectionType%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.InspectionType)%>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_visitedDate%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.VisitedDate)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_visitedBy%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.CreatedByFullName)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>                        
                    </fieldset>
                    </form>
                </div>
            </div>
            <div class="tab-pane" id="VisitComments">
                <div id="AddCommentForm" class="top-accordion-grid-with-search">
                    <div id="validation" class="widget highlight widget-form widget-accordion">
                        <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsEngineer(Page.User.Identity.Name))
                          { %>
                        <div class="accordion" id="sample-accordion">
                            <div class="accordion-group">
                                <div class="accordion-heading">
                                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#sample-accordion"
                                        href="#collapseVisitComments"><span class="leftPadder-medium"></span>
                                        <%:Resources.info_gen_addNewComment%></a> <i class="icon-plus toggle-icon"></i>
                                </div>
                                <div id="collapseVisitComments" class="accordion-body in collapse">
                                    <div class="accordion-inner">
                                        <form action="#" class="form-horizontal" id="contact-form" novalidate="novalidate">
                                        <div id="successHeaderi" class="alert alert-success" style="display: none;">
                                            <a class="close" data-dismiss="alert" href="#">&times;</a>
                                            <h4 class="alert-heading">
                                                <%: Resources.info_gen_success %></h4>
                                            <div id="smsgi">
                                            </div>
                                        </div>
                                        <div id="errorHeaderi" class="alert alert-error" style="display: none;">
                                            <a class="close" data-dismiss="alert" href="#">&times;</a>
                                            <h4 class="alert-heading">
                                                <%: Resources.info_gen_error %></h4>
                                            <div id="errormsg">
                                            </div>
                                        </div>
                                        <fieldset>
                                            <div class="control-group">
                                                <label class="control-label" for="name">
                                                    <%:Resources.info_gen_newComment%></label>
                                                <label class="redStar">
                                                    *</label>
                                                <div class="controls">
                                                    <textarea class="input-large ui-tooltip" id="visitComment" name="visitComment" placement="right"
                                                        rows="5" cols="1" title="Type a comment."></textarea>
                                                </div>
                                            </div>
                                            <div class="form-actions">
                                                <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("CreateComment_JSON")))
                                                  { %>
                                                <input type="button" id="visitCommentPostButton" class="btn btn-primary" value="<%:Resources.info_gen_addComment%>"
                                                    onclick="CreateVisitComment();" />
                                                <%} %>
                                                <input type="reset" class="btn btn-secondary" value="<%:Resources.info_gen_reset%>" />
                                            </div>
                                        </fieldset>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%} %>
                        <table id="VisitCommentsTable" class="table table-striped table-bordered table-highlight">
                            <thead>
                                <tr>
                                    <th>
                                        <%:Resources.info_gen_dateAndTime%>
                                    </th>
                                    <th>
                                        <%:Resources.info_gen_commentedBy%>
                                    </th>
                                    <th>
                                        <%:Resources.info_gen_comment%>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="tab-pane" id="visitGallery">
                <div id="Div7" class="widget widget-form">
                    <% Html.RenderPartial("~/Views/HTML/Shared/Job/ImageGallery.ascx", com.IronOne.SLIC2.Models.Enums.JobType.Visit); %>
                </div>
            </div>
        </div>
    </div>
</div>