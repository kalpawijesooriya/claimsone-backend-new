<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <%  /// <summary>
    ///  <title>SLIC2</title>
    ///  <description>Home page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-05</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    /// </summary> %>
    <%: Resources.info_gen_home%>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="span12 top-accordion-grid-with-search">
        <div class="widget widget-form">
            <div class="widget-header">
                <h3>
                    <i class="icon-search"></i>
                    <%:Resources.info_gen_quickInquiries%>
                </h3>
            </div>
            <div class="widget-content">
                <%Html.RenderPartial("~/Views/HTML/Shared/Job/SearchUserControl.ascx"); %>
            </div>
        </div>
    </div>    
</asp:Content>