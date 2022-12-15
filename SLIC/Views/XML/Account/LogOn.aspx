<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<response>
<% /// <summary>
                /// 
                ///  <title>SLIC</title>
                ///  <description>LogOn page for XML user to log on to the system</description>
                ///  <copyRight>Copyright (c) 2011</copyRight>
                ///  <company>IronOne Technologies (Pvt)Ltd</company>
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
    <Status><%
                ModelState err = ViewContext.ViewData.ModelState["err"];
                com.IronOne.SLIC2.Controllers.GenException result = null;

                if (err != null)
                {
                    result = (com.IronOne.SLIC2.Controllers.GenException)err.Errors.ElementAt(0).Exception;%>
                    <code><%:result.Code%></code>
                    <description><%:result.Message%></description><% 
                }
                else
                {%>             
                     <code>0</code>
                     <description>Success</description>
                     <CurrentWebVersion><%:ApplicationSettings.WebAppVersion%></CurrentWebVersion>
                     <MinimumSupportedAppVersion><%:ApplicationSettings.MinTabVersion%></MinimumSupportedAppVersion>
                     <LatestAppVersioninGooglePlay><%:ApplicationSettings.LatestAppVerInGooglePlay%></LatestAppVersioninGooglePlay>
                     <ForceLatestVersionToUsers><%:ApplicationSettings.ForceLatestVerToUsers%></ForceLatestVersionToUsers>
                     <GooglePlayAppURL><%:ApplicationSettings.GooglePlay_AppURL%></GooglePlayAppURL>             
              <%}%>        
    </Status>
    <Data>
        <Server><%=com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.ServerId%></Server>
        <DateTime><%=DateTime.Now %></DateTime>
        <UTCDateTime><%=DateTime.UtcNow %></UTCDateTime>
    </Data>
</response>
