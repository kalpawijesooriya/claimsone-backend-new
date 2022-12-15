<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><?xml version="1.0" encoding="utf-8"?>  
<Response> 

<%
        /// <summary>
        /// 
        ///  <title>SLIC</title>
        ///  <description>NotAuthorized page for XML users when not Authorized</description>
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

			<Status>
			<code>102</code>
				<description>You are not authorized for this action.</description>
			</Status>
			<Data>
				<Server></Server>
				<DateTime></DateTime>
			</Data>
</Response>