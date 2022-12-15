<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Job.JobContainer>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<html xmlns="http://www.w3.org/1999/xhtml">
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
<head id="Head1" runat="server">
    <title>
        <%if (Model != null && Model.SAForm != null && Model.SAForm.GeneralModel != null)
          { %>
        <%:Resources.info_gen_jobDetailsOf%>
        <%: Model.SAForm.GeneralModel.JobNo%>
        <%} %>
    </title>
    <%--Styles--%>
    <link href="../../../Content/css/bootstrap.css" rel="stylesheet" />
    <link href="../../../Content/css/bootstrap-overrides.css" rel="stylesheet" />
    <link href="../../../Content/css/Site.css" rel="stylesheet" type="text/css" />
    <link href="../../../Content/css/slate.css" rel="stylesheet" />
    <script src="../../../Scripts/jquery.min.js" type="text/javascript"></script>
    <script src="../../../Scripts/jquery.validate.min.js" type="text/javascript"></script>
    <script src="../../../Scripts/api.js" type="text/javascript"></script>
    <%-- 
   Requirement: Temp. Printing user is allowed to print the SA form multiple times. Others are allocated Only Once.
   Solution   : When the Temp printing user is logged in database record is not updated on print.
    --%>
    <%-- <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsTempPrinting(User.Identity.Name))
      { %>
    <script type="text/javascript">
        function HideAndPrint(visitId) {
            document.printForm.PrintButton.style.visibility = 'hidden';
            window.print();
            return;
        }     
    </script>
    <%}--%>
    <%--  else
      { %>--%>
    <script type="text/javascript">
        function HideAndPrint(visitId) {
            document.printForm.PrintButton.style.visibility = 'hidden';
            document.printForm.PrintButton.disabled = 'true';

            document.getElementById('PrintPreviewWatermark').style.display = 'none';        
            printVisit(visitId);
            return;
        }     
    </script>
    <%-- <%} %>--%>
</head>
<body>
    <style type="text/css" media="print">
        div.pageBreak
        {
            page-break-before: always;
            page-break-inside: avoid;
        }
    </style>
    <form name="printForm">
    <%if (Model != null)
      { %>
    <div id="rightcontent" class="span12" style="clear: both;">
        <div>
            <div class="widget">
                <%if (Model.SAForm != null && Model.SAForm.GeneralModel != null)
                  { %>
                <div class="widget-header">
                    <h3>
                        <i class="icon-map-marker"></i>
                        <%:Resources.info_gen_jobDetailsOf%>
                        <%: Model.SAForm.GeneralModel.JobNo%>
                        - <span class="printStatus">(
                            <%=(Model.SAForm.GeneralModel.IsOriginal) ? Resources.info_gen_original : Resources.info_gen_duplicate%>)
                        </span>
                    </h3>
                    &nbsp;&nbsp;&nbsp;
                    <%  bool allowedPrinting = false;

                        com.IronOne.SLIC2.Models.Administration.UserDataModel user = (Session["LoggedUserDetail"] != null) ? Session["LoggedUserDetail"] as com.IronOne.SLIC2.Models.Administration.UserDataModel : null;
                        allowedPrinting = (user != null) ? user.RoleId == new Guid("5cb24ac1-013f-4d39-98f3-0ecf810f58d4") || (user.RoleId != new Guid("5cb24ac1-013f-4d39-98f3-0ecf810f58d4") && !Model.SAForm.GeneralModel.IsPrinted) /*Temp Printing */ : false;

                        if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("PrintVisit_JSON")) && allowedPrinting)
                        { %>
                    <input style="float: left; display: inline;" class="btn btn-primary btn-small" type="button"
                        name="PrintButton" onclick="HideAndPrint(<%= Model.SAForm.GeneralModel.VisitId %>);"
                        value="<%:Resources.info_gen_printReport%>" />
                    <%} %>
                </div>
                <div id="PrintPreviewWatermark" style="background-color: White;border:1px solid #CCC;border-radius:5px;">
                    <div style="width: 100%; padding: 15px; display: block; clear: both" name="PrintText">                       
                        Print Preview Copy |  
                        Print Preview Copy | 
                        Print Preview Copy |  
                        Print Preview Copy | 
                        Print Preview Copy |  
                        Print Preview Copy </div>
                </div>
                <%Html.RenderPartial("~/Views/HTML/Shared/Job/PrintJobDetails.ascx", Model.SAForm); %>
                <% if (Model.SAForm.GeneralModel.ImageCategories != null)
                   { %>
                <%Html.RenderPartial("~/Views/HTML/Shared/Job/PrintImageGallery.ascx", Model.SAForm.GeneralModel.ImageCategories); %>
                <%}%>
                <% }%>
            </div>
            <div id="foo" class="span12">
                &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &copy;
                <%=DateTime.Now.Year%>
                <%:Resources.info_gen_copyright%>
                <span style="float: right; margin-right: 30px;">
                    <%     
          if (ViewData["PrintUser"] != null)
          {
              com.IronOne.SLIC2.Models.Administration.UserDataModel printUser = printUser = (com.IronOne.SLIC2.Models.Administration.UserDataModel)ViewData["PrintUser"];%>
                    <i>Printed by
                        <%=printUser.FirstName%>
                        <%=printUser.LastName%>
                        |
                        <%=printUser.EPFNo%>
                        |
                        <%=printUser.BranchName%>
                    </i>
                    <%   }%>
                </span>
            </div>
        </div>
    </div>
    <div style="clear: both;">
        <% if (Model.Visits != null)
           { %>
        <%foreach (var visit in Model.Visits)
          {%>
        <div class="pageBreak" style="clear: both;">
            <div class="span12">
                <div class="widget">
                    <div class="widget-header">
                        <h3>
                            <i class="icon-map-marker"></i>
                            <%:Resources.info_gen_jobNo%>
                            <%: visit.JobNo%>'s
                            <%: visit.InspectionType%>
                            <%:Resources.info_gen_visitDetails%>
                            (<%: String.Format("{0:d}", visit.VisitedDate)%>)
                        </h3>
                    </div>
                    <div style="clear: both;">
                        <%Html.RenderPartial("~/Views/HTML/Shared/Job/PrintVisitDetails.ascx", visit); %>
                    </div>
                  <%--  <div style="clear: both;">
                        <% if (visit.ImageCategories != null)
                           { %>
                        <%Html.RenderPartial("~/Views/HTML/Shared/Job/PrintImageGallery.ascx", visit.ImageCategories); %>
                        <% } %></div>--%>

                    <div id="foo" class="span12" style="clear: both;">
                        &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &copy;
                        <%=DateTime.Now.Year%>
                        <%:Resources.info_gen_copyright%>
                        <span style="float: right; margin-right: 30px;">
                            <%     
              if (ViewData["PrintUser"] != null)
              {
                  com.IronOne.SLIC2.Models.Administration.UserDataModel printUser = printUser = (com.IronOne.SLIC2.Models.Administration.UserDataModel)ViewData["PrintUser"];%>
                            <i>Printed by
                                <%=printUser.FirstName%>
                                <%=printUser.LastName%>
                                |
                                <%=printUser.EPFNo%>
                                |
                                <%=printUser.BranchName%>
                            </i>
                            <%   }%>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <%  }
           }
        %></div>
    <% }
      else
      { %>
    <div id="rightcontent" class="span12">
        <%:Resources.err_605%>
    </div>
    <%} %>
    </form>
</body>
</html>
