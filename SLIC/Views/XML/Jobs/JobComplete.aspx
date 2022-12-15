<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><?xml version="1.0" encoding="utf-8"?>
<Response>

<%
        /// <summary>
        /// 
        ///  <title>SLIC</title>
        ///  <description>JobComplete page for XML users to view Job complete status</description>
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
             SLIC2.Controllers.GenException result = null;

             if (err != null)
             {
                 result = (SLIC2.Controllers.GenException)err.Errors.ElementAt(0).Exception;
	         
      %><code><%: result.Code%></code>
        <description><%: result.Message%></description><% 
             } 
  %></Status>
    <Data>
	    <Server></Server>
        <DateTime></DateTime>
    </Data>
</Response>
