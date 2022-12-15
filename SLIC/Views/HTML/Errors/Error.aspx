<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>Error page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-20</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
    %>
    <%: Resources.info_gen_error%>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row">
            <div class="span12">
                <div class="error-container">
                    <h1>
                        <%: Resources.info_gen_oops%></h1>
                    <h2>
                        <%: Resources.info_error500_heading%></h2>
                    <div class="error-details">
                        <%: Resources.info_gen_errorOccurred %>
                        &nbsp;
                        <%: Resources.info_gen_tryAgainLater%>
                    </div>
                    <!-- /error-details -->
                    <div class="error-actions">
                        <%: Html.ActionLink(Resources.info_genbacktodashboard, "Index", "Default", null, new { @class = "icon-chevron-left btn btn-primary" })%>
                        <%: Html.ActionLink(Resources.info_gen_contactsupport, "Support", "Default", null, new { @class = "icon-envelope btn" })%>
                    </div>
                    <!-- /error-actions -->
                </div>
                <!-- /error-container -->
            </div>
            <!-- /span12 -->
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>
