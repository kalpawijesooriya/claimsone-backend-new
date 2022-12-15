<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Visit.VisitDetailModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>visit details print preview page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2013-01-02</createdOn>
    ///  <author>Suren Manawatta</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
    %>
    <%--Styles--%>
    <link href="../../../Content/css/bootstrap.css" rel="stylesheet" />
    <link href="../../../Content/css/bootstrap-overrides.css" rel="stylesheet" />
    <link href="../../../Content/css/Site.css" rel="stylesheet" type="text/css" />
    <link href="../../../Content/css/slate.css" rel="stylesheet" />
    <title>Job No
        <%: Model.JobNo %>'s
        <%: Model.InspectionType %>
        Visit Details</title>
    <script src="../../../Scripts/jquery.min.js" type="text/javascript"></script>
    <script src="../../../Scripts/jquery.validate.min.js" type="text/javascript"></script>
    <script src="../../../Scripts/api.js" type="text/javascript"></script>
    <script type="text/javascript">
        function HideAndPrint(visitId) {
            document.printForm.PrintButton.style.visibility = 'hidden';
            printVisit(visitId);
            return;
        }
    </script>
</head>
<body style="background: none">
    <form name="printForm">
    <div id="rightcontent" class="span12">
        <div class="span12">
            <div class="widget">
                <div class="widget-header">
                    <h3>
                        <i class="icon-map-marker"></i>Job No
                        <%: Model.JobNo %>'s
                        <%: Model.InspectionType %>
                        Visit Details (<%: String.Format("{0:d}",Model.VisitedDate) %>)
                    </h3>
                    &nbsp;&nbsp;&nbsp;
                    <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("PrintVisit_HTML")))
                      { %>
                    <input style="display: inline;" class="btn btn-primary btn-small" type="button" name="PrintButton"
                        onclick="HideAndPrint(<%= Model.VisitId %>);" value="Print Report" />
                    <%} %>
                </div>
                <div class="widget-content">
                    <fieldset class="form-horizontal">
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Job No</label>ssssssssss
                            <div class="controls">
                                <%: Model.JobNo %></div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Visit Type</label>
                            <div class="controls">
                                <%: Model.VisitType %></div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Inspection Type</label>
                            <div class="controls">
                                <%: Model.InspectionType %></div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Chassis No</label>
                            <div class="controls">
                                <%: Model.ChassisNo %></div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Engine No</label>
                            <div class="controls">
                                <%: Model.EngineNo %></div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Visited Date</label>
                            <div class="controls">
                                <%: String.Format("{0:g}", Model.VisitedDate) %></div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Visited By</label>
                            <div class="controls">
                                <%: Model.CreatedByFullName %></div>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
    </div>
    <div id="foo" class="span12">
        &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &copy;
        <%=DateTime.Now.Year %>
        <%:Resources.info_gen_copyright%>
    </div>
    </form>
</body>
</html>