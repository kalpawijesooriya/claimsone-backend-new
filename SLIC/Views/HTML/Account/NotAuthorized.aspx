<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <%
        /// <summary>
        /// 
        ///  <title>SLIC</title>
        ///  <description>Not Authorized page for View error for Unauthorized users </description>
        ///  <copyRight>Copyright (c) 2011</copyRight>
        ///  <company>IronOne Technologies (Pvt) Ltd</company>
        ///  <createdOn>2011-08-05</createdOn>
        ///  <author></author>
        ///  <modification>
        ///     <modifiedBy></modifiedBy>
        ///      <modifiedDate></modifiedDate>
        ///     <description></description>
        ///  </modification>
        ///
        /// </summary>                                                                                 
    %>
    <%: Resources.info_gen_notauthorized%>
</asp:Content>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%  /// <summary>
    ///  <title>Template View</title>
    ///  <description>Please use this as the base page of any other view</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-04</createdOn>
    ///  <author>Suren Manawatta</author> 
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    /// </summary> %>
    <link href="../../../Content/css/components/error.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row">
            <div class="span12">
                <div class="error-container">
                    <h1>
                        <%: Resources.info_gen_oops%></h1>
                    <h2>
                        <%: Resources.info_gen_unauthorized%></h2>
                    <div class="error-details">
                        <%: Resources.info_gen_notauthorized%>
                    </div>                    
                    <div class="error-actions">                        
                    </div>                    
                </div>
                <!-- /error-container -->
            </div>
            <!-- /span12 -->
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</asp:Content>
