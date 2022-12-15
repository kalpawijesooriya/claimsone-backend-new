<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Visit.VisitDetailModel>" %><?xml version="1.0" encoding="utf-8" ?>
<response>
<%      /// <summary>
        /// 
        ///  <title>SLIC</title>
        ///  <description>ViewJob page for XML users to view job</description>
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
      { %><Visit>
            <FieldList>
                <JobNo><%: Model.JobNo %></JobNo>
                <ChassisNo><%: Model.ChassisNo %></ChassisNo>
                <EngineNo><%: Model.EngineNo %></EngineNo>     
                <VisitId><%: Model.VisitId %></VisitId>
                <VisitNo><%: Model.VisitNo %></VisitNo>
                <VisitType><%: Model.VisitType %></VisitType>
                <InspectionType><%: Model.InspectionType %></InspectionType>
                <VisitDate><%: String.Format("{0:g}", Model.VisitedDate) %></VisitDate>
                <VisitBy><%: Model.CreatedBy %></VisitBy>
                <VisitByName><%: Model.CreatedByFullName %></VisitByName>
                <CreatedDate><%: String.Format("{0:g}", Model.CreatedDate) %></CreatedDate>               
                <Code><%: Model.Code %></Code>
               <%--<Images><%=(Model.ImageIds.Length > 0)? string.Empty : String.Join(",", Model.ImageIds) %></Images>--%>
                <ImageCount><%: Model.ImageCount %></ImageCount>
                <TotalImageCount><%: Model.ReceivedImageCount %></TotalImageCount>
                <!-- TODO: Add a property for 'Total Image Count'--> 
            </FieldList>
          <%if (Model.Comments != null)
            { %>
           <Comments>     
           <%foreach (var comment in Model.Comments)
             {%>
                 <CommentItem>
                    <Comment><%=comment.Comment%></Comment>
                    <CommentedBy><%=comment.CommentedByFullName%></CommentedBy>
                    <CommentedDate><%=comment.CommentedDate%></CommentedDate>
                </CommentItem>  
            <% } %>                             
            </Comments>    
            <%} %>  
             <%if (Model.ImageCategories != null && Model.ImageCategories.Count > 0)
               { %>
           <Images>     
           <%foreach (var category in Model.ImageCategories)
             {%>
                 <ImageType>
                    <ImageTypeId><%=category.ImageTypeId%></ImageTypeId>
                    <ImageIds><%=String.Join(",", category.Images.Select(x=>x.ImageId))%></ImageIds>                  
                </ImageType>  
            <% } %>                             
            </Images>    
            <%} %>
        </Visit><%} %> 
        <Server><%=com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.ServerId%></Server>
        <MachineName><%= Server.MachineName %></MachineName>
        <DateTime><%=DateTime.Now %></DateTime>
        <UTCDateTime><%=DateTime.UtcNow %></UTCDateTime>
    </Data>
</response>
