<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>

 <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>javascript var resolver</description>
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

<script type="text/javascript" language="javascript">
    var JOB_SEARCH_ACTION = ' <%: Url.Action("Search","Job") %>';
    var DEFAULT_INDEX_ACTION = ' <%: Url.Action("Index","Default") %>';
    var JOB_COMMENTSLISTAJAXHANDLER_ACTION = '<%: Html.ActionLink(" ", "CommentsListAjaxHandler", "Job", null, null) %>';
    var JOB_CREATECOMMENT_ACTION = '<%: Html.ActionLink(" ", "CreateComment", "Job", null, null) %>';
    var JOB_COMMENTSLISTAJXHANDLER2 = '<%: Html.ActionLink(" ", "CommentsListAjaxHandler2", "Job", null, null) %>';
    var JOB_GETVISITDETAILSASYNCHANDLER_ACTION = '<%: Html.ActionLink(" ", "GetVisitDetailsAjaxHandler", "Job", null, null) %>';
    var CULTURE_EN_RESOURCE = ' <%: Resources.Culture %>';
    var ERROR_HTTPAJAXHEADING_EN_RESOURCE = ' <%: Resources.info_error_httpAjaxHeading %>';
    var ERROR_HTTPAJAXBODY_EN_RESOURCE = ' <%: Resources.info_error_httpAjaxBody %>';
    var INFO_GEN_ALL_EN_RESOURCE = ' <%: Resources.info_gen_all %>';
    /* Functions*/

    function getHttpErrorHeading(errorCode) {
        try {
            var tag = "info_error" + errorCode + "_heading";
            return ' <%:Resources.ResourceManager.GetString("info_error400_heading")%>' ;
        } catch (e) {
            alert(e);
        }       
    }

    function getHttpErrorBody(errorCode) {
        return ' <%: Resources.info_error_httpAjaxHeading %>';
    }
</script>
<div>
</div>

