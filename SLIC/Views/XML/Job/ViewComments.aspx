<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<com.IronOne.SLIC2.Models.Visit.VisitModel>>" %><?xml version="1.0" encoding="utf-8" ?>
<response>
<%      /// <summary>
        /// 
        ///  <title>SLIC</title>
        ///  <description>View Comments page for XML users to view Comments</description>
        ///  <copyRight>Copyright (c) 2013</copyRight>
        ///  <company>IronOne Technologies (Pvt)Ltd</company>
        ///  <createdOn>2013-04-04</createdOn>
        ///  <author></author>
        ///  <modification>
        ///     <modifiedBy></modifiedBy>
        ///      <modifiedDate></modifiedDate>
        ///     <description></description>
        ///  </modification>
        ///
        /// </summary> %>
    <Status> 
    <% ModelState err = ViewContext.ViewData.ModelState["err"];
       com.IronOne.SLIC2.Controllers.GenException result = null;
       if (err != null)
       {
           result = (com.IronOne.SLIC2.Controllers.GenException)err.Errors.ElementAt(0).Exception;  %>
         <code><%: result.Code%></code>
         <description><%: result.Message%></description>  
      <%}
       else
       { %><code>0</code>
         <description>Success</description><%} %> 
   </Status>
   <Data>
   <% if (Model != null)
      { %>
      <Visits>
          <% foreach (com.IronOne.SLIC2.Models.Visit.VisitModel visit in Model)
                {%>
             <Visit>
             <VisitId><%=visit.VisitId%></VisitId>
             <VisitTypeId><%=visit.VisitType%></VisitTypeId>
             <VisitType><%= com.IronOne.IronUtils.EnumUtils.stringValueOf(typeof(com.IronOne.SLIC2.Models.Enums.VisitType), visit.VisitType.ToString())%></VisitType>
             <VisitDate><%=visit.VisitedDate.ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateTimeFormat)%></VisitDate>
             <Comments>
              <%foreach (com.IronOne.SLIC2.Models.Job.CommentModel comment in visit.Comments)
                {%>                
                 <CommentItem>
                    <Comment><%=comment.Comment%></Comment>
                    <CommentedBy><%=comment.CommentedByFullName%></CommentedBy>
                    <CommentedDate><%=comment.CommentedDate.ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateTimeFormat)%></CommentedDate>
                 </CommentItem>               
               <%} %>          
              </Comments>
             </Visit>
            <% }
            %>
            </Visits>                 
       <%} %> 
        <Server><%=com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.ServerId%></Server>
        <MachineName><%= Server.MachineName %></MachineName>
        <DateTime><%=DateTime.Now %></DateTime>
        <UTCDateTime><%=DateTime.UtcNow %></UTCDateTime>
    </Data>
</response>