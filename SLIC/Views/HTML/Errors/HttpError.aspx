<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>Change Password page</description>
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
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <%: Model.heading %>
    -
    <%: Model.body %>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row">
            <div class="span12">
                <div class="error-container">
                    <h1>
                        <%: Resources.info_gen_oops%></h1>
                    <h2>
                        <%: Model.heading %></h2>
                    <div class="error-details">
                        <%: Model.body %>
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
