<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<com.IronOne.SLIC2.Models.Visit.VisitModel>>" %>

<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>print preview job's visits page</description>
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
    <%--Styles--%>
    <link href="../../../Content/css/bootstrap.css" rel="stylesheet" />
    <link href="../../../Content/css/bootstrap-overrides.css" rel="stylesheet" />
    <title>Job Visit Details Report</title>
    <script type="text/javascript">
        function HideAndPrint() {
            document.printForm.PrintButton.style.visibility = 'hidden';
            document.printForm.PrintButton.disabled = 'true';
            window.print();
            return;
        }
    </script>
</head>
<body style="background: none">
    <form name="printForm">
    <div style="margin: 10px;">
        <h3>
            <%:Resources.info_gen_jobVisitDetailsReport%></h3>
        &nbsp;&nbsp;&nbsp;
        <%--Sasini Madhumali | 02/02/2016 | Check the user role and hide the Print Record button if user is a technical officer--%>
        <%if (!com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized("JobDetailsPrintRecord_HTML"))
          { %>
        <input style="display: inline;" class="btn btn-primary btn-small" type="button" name="PrintButton"
            onclick="HideAndPrint();" value="<%:Resources.info_gen_printReport%>" />
        <%} %>
    </div>
    <p>ssssssssss</p>
    <table class="table table-bordered table-condensed">
        <thead>
            <tr>
                <th>
                    <%:Resources.info_gen_visitNo%>
                </th>
                <th>
                    <%:Resources.info_gen_inspectionType%>
                </th>
                <th>
                    <%:Resources.info_gen_visitedDate%>
                </th>
                <th>
                    <%:Resources.info_gen_csrCode%>
                </th>
                <th>
                    <%:Resources.info_gen_visitedBy%>
                </th>
            </tr>
        </thead>
        <tbody>
            <% foreach (var item in Model)
               { %>
            <tr>
                <td>
                    <%: item.VisitNo %>
                </td>
                <td>
                    <%: item.InspectionType %>
                </td>
                <td>
                    <%: item.VisitedDate.ToString(ApplicationSettings.GetDateTimeFormat) %>
                </td>
                <td>
                    <%: item.Code %>
                </td>
                <td>
                    <%: item.CreatedByFullName %>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <div id="foo" class="span12">
        &nbsp; &copy;
        <%=DateTime.Now.Year %>
        <%:com.IronOne.SLIC2.Lang.Resources.info_gen_copyright%>
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
