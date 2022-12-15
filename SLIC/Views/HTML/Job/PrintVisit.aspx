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
    <title>
        <%:Resources.info_gen_jobNo%>
        <%if (Model != null)
          { %>
        <%: Model.JobNo %>'s
        <%: Model.InspectionType %>
        <%} %>
        Visit Details</title>
    <script src="../../../Scripts/jquery.min.js" type="text/javascript"></script>
    <script src="../../../Scripts/jquery.validate.min.js" type="text/javascript"></script>
    <script src="../../../Scripts/api.js" type="text/javascript"></script>
    <script type="text/javascript">
        function HideAndPrint(visitId) {
            document.printForm.PrintButton.style.visibility = 'hidden';
            document.printForm.PrintButton.disabled = 'true';
            window.print();
            //printVisit(visitId);// Only SA Form record is updated whether it is printed or not.
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
                    <%if (Model != null)
                      { %>
                    <h3>
                        <i class="icon-map-marker"></i>
                        <%:Resources.info_gen_jobNo%>
                        <%: Model.JobNo%>'s
                        <%: Model.InspectionType%>
                        Visit Details (<%: String.Format("{0:d}", Model.VisitedDate)%>)
                        <%// Only SA Form has to be mentioned 'Original' OR 'Duplicate' copy on print- Requirement %>
                        <%--   - <span class="printStatus">
                           (<%=(Model.IsPrinted) ? Resources.info_gen_duplicate : Resources.info_gen_original %>)
                          </span>--%>
                    </h3>
                    &nbsp;&nbsp;&nbsp;
                    <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("PrintVisit_JSON")))
                      { %>
                    <input style="display: inline;" class="btn btn-primary btn-small" type="button" name="PrintButton"
                        onclick="HideAndPrint(<%= Model.VisitId %>);" value="<%:Resources.info_gen_printReport%>" />
                    <%}
                      } %>
                </div>
                <%if (Model != null)
                  {%>
                <%Html.RenderPartial("~/Views/HTML/Shared/Job/PrintVisitDetails.ascx", Model); %>
                <div style="clear: both;">
                    <% if (Model.ImageCategories != null)
                       { %>
                    <% if (ViewData["ShowImages"] != "False")
                       { %>
                    <%Html.RenderPartial("~/Views/HTML/Shared/Job/PrintImageGallery.ascx", Model.ImageCategories); %>
                    <% } %>
                    <% } %>
                </div>
                <%  }
                  else
                  {%>
                <div>
                    Visit not found or deleted.</div>
                <%} %>
            </div>
        </div>
    </div>
    <div id="foo" class="span12">
        &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &copy;
        <%=DateTime.Now.Year %>
        <%:Resources.info_gen_copyright%>
        <span style="float: right">
            <%     
                if (ViewData["PrintUser"] != null)
                {
                    com.IronOne.SLIC2.Models.Administration.UserDataModel printUser = (com.IronOne.SLIC2.Models.Administration.UserDataModel)ViewData["PrintUser"];%>
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
    </form>
</body>
</html>
