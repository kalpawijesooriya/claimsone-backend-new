<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<com.IronOne.SLIC2.Models.Enums.JobType>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Enums" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%  /// <summary>
                ///  <title></title>
                ///  <description>Partial View for</description>
                ///  <copyRight>Copyright (c) yyyy</copyRight>
                ///  <company>IronOne Technologies (Pvt)Ltd</company>
                ///  <createdOn>20yy-mm-dd</createdOn>
                ///  <author></author>
                ///  <modification>
                ///     <modifiedBy></modifiedBy>
                ///      <modifiedDate></modifiedDate>
                ///     <description></description>
                ///  </modification>
                /// </summary> %>
<!-- Second, add the Timer and Easing plugins -->
<script src="../../../../Content/js/galleryView/jquery.timers-1.2.js" type="text/javascript"></script>
<script src="../../../../Content/js/galleryView/jquery.easing.1.3.js" type="text/javascript"></script>
<!-- Third, add the GalleryView Javascript and CSS files -->
<script src="../../../../Content/js/galleryView/jquery.galleryview-3.0-dev.js" type="text/javascript"></script>
<script src="../../../../Scripts/Job/gallery.js" type="text/javascript"></script>
<link href="../../../../Content/css/galleryView/jquery.galleryview-3.0-dev.css" rel="stylesheet"
    type="text/css" />
<div id="leftImagePanel">
    <div id="imageTypes" class="tabbable tabs-left">
        <ul class="nav nav-tabs">
            <% foreach (var item in Enum.GetValues(typeof(ImageType)))
               {
                   ImageType en = ((ImageType)item);
                   JobType[] types = ((JobTypesAttribute)(typeof(ImageType).GetMember(en.ToString())[0].GetCustomAttributes(typeof(JobTypesAttribute), false)[0])).GetValue();
                   if (Model != null && types.Contains(Model))
                   {
            %>
            <li><a id="<%=(int)en%>" href="#" data-toggle="tab">
                <%=com.IronOne.IronUtils.EnumUtils.stringValueOf(en)%></a> </li>
            <% }
           } %>            
        </ul>
    </div>
</div>
<div id="rightImagePanel">
    <div id="ajaxLoader" style="position: relative; left: 300px; top: 60px;">
        <%:Resources.info_gen_loadingGallery%>
    </div>
    <div id="gallery">
    </div>
    <div class='gv_navZoomOut'>
    </div>
</div>