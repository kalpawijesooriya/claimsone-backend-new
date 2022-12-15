<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<List<com.IronOne.SLIC2.Models.Visit.ImageCategoryModel>>" %>
<%
        /// <summary>
        /// 
        ///  <title>SLIC2</title>
        ///  <description>job detail view page</description>
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
<style type="text/css">
    .printJob-imageLibrary-category-title h3
    {
        text-decoration: underline;
        font-weight: normal;
        padding-bottom: 15px;
    }
</style>
<div class="printJob-imageLibrary widget-content">
    <% if (Model != null)
       { %>
    <% foreach (com.IronOne.SLIC2.Models.Visit.ImageCategoryModel category in Model)
       { %>
    <div class="printJob-imageLibrary-category">
        <div class="printJob-imageLibrary-category-title">
            <h3>
                <%: category.ImageType %></h3>
        </div>
        <div class="printJob-imageLibrary-category-images">
            <% foreach (com.IronOne.SLIC2.Models.Visit.ImageModel item in category.Images)
               { %>
            <div class="printJob-imageLibrary-image">
                <img src="/HandlerClasses/ImageHandler.ashx?path=<%:com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.ImageGalleryPath + item.ImagePath %>"
                    alt="<%: item.Title %>" />
            </div>
            <% } %>
        </div>
    </div>
    <% } %>
</div>
<% } %>