<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><?xml version="1.0" encoding="utf-8"?>
<Response> 

<%
        /// <summary>
        /// 
        ///  <title>SLIC</title>
        ///  <description>AddJob page for XML users to Add a Job</description>
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
                 result = (com.IronOne.SLIC2.Controllers.GenException)err.Errors.ElementAt(0).Exception;
	         
         %>     <code><%: result.Code%></code>
                <description><%: result.Message%></description>  <% 
}else
             { %>
                <code>0</code>
                <description>Data upload Successful.</description>
                <visitId><%=ViewData["VisitId"] %></visitId><%} %>
            </Status>
            <Data> 
	           <Server><%=com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.ServerId%></Server>
               <DateTime><%=DateTime.Now %></DateTime>
               <UTCDateTime><%=DateTime.UtcNow %></UTCDateTime>
            </Data>
</Response>
