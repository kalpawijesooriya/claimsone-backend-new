<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<com.IronOne.SLIC2.Models.EntityModel.vw_VisitStatus>>" %>

<?xml version="1.0" encoding="utf-8" ?>
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
   <% if (Model!=null && Model.Count() > 0)
      { %><Visits><% foreach (var item in Model) { %>
      <Visit>           
            <VisitId><%: item.VisitId %></VisitId>
            <JobNo><%: item.JobNo %></JobNo>
            <VehicleNo><%: item.VehicleNo %></VehicleNo>
            <VisitType><%: com.IronOne.IronUtils.EnumUtils.stringValueOf(typeof(com.IronOne.SLIC2.Models.Enums.VisitType), item.VisitType.ToString())%></VisitType>
            <VisitStatus><%if(item.VisitStatus!=null) {%><%: com.IronOne.IronUtils.EnumUtils.stringValueOf(typeof(com.IronOne.SLIC2.Models.Enums.VisitStatus),item.VisitStatus.ToString()) %><%}%></VisitStatus>
      </Visit>    
    <% } %>
        </Visits><%} %> 
        <Server><%=com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.ServerId%></Server>
        <MachineName><%= Server.MachineName %></MachineName>
        <DateTime><%=DateTime.Now %></DateTime>
        <UTCDateTime><%=DateTime.UtcNow %></UTCDateTime>
    </Data>
</response>
