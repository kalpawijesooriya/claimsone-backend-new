<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><?xml version="1.0" encoding="utf-8" ?>
<Response>


<%
        /// <summary>
        /// 
        ///  <title>SLIC</title>
        ///  <description>ImageUpload page for XML users to upload Images</description>
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
   <%
       ModelState err = ViewContext.ViewData.ModelState["err"];
       com.IronOne.SLIC2.Controllers.GenException result = null;

       if (err != null)
       {
           result = (com.IronOne.SLIC2.Controllers.GenException)err.Errors.ElementAt(0).Exception;  %>
         <code><%: result.Code%></code>
         <description><%: result.Message%></description>  
             <%
       }
       else
       { %>
         <code>0</code>
         <description>Success</description>
         <%if (ViewData["ImageId"] != null)
           { %>        
         <imageId><%:ViewData["ImageId"]%></imageId>
       <%}
       } %> 
   </Status>
    <Data>
        <%--<UserList>
        <%List<SLIC2.Models.Entity.User> users = (List<SLIC2.Models.Entity.User>)ViewData["users"];  
          foreach (var user in users){%>
          <User>
		    <Id><%:user.CustomUserId %></Id>
            <FirstName><%:user.FirstName %></FirstName>
            <LastName><%:user.LastName %></LastName>
            </User>
        <%} %>
         </UserList>
        <CommentList>
	<%foreach (var item in Model)
           { %>
           <Comment>
            <Description><%: item.Description %></Description>
            <AddedBy><%: item.AddedBy %></AddedBy>
            </Comment>
       <% } %>  
        </CommentList>--%>          
    </Data>
</Response>
