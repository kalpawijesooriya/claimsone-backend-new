<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<com.IronOne.SLIC2.Models.Visit.GroupedVisitsModel>>" %><?xml version="1.0" encoding="utf-8" ?>
<response> 
<%
                        /// <summary>
                        /// 
                        ///  <title>SLIC</title>
                        ///  <description>SearchJobs page for XML users to search jobs</description>
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
	         
         %>
                <code><%: result.Code%></code>
                <description><%: result.Message%></description>  <% 
                        }
                        else
                        { %>
              <code>0</code>
                <description>Success</description> 
             <%} %> 
            </Status>
            <Data>
            <% if (Model != null)
               { %>
              <JobList>
                <%foreach (com.IronOne.SLIC2.Models.Visit.GroupedVisitsModel item in Model)
                  { %>
                  <Job>
                    <JobNo><%:item.JobNo %></JobNo> 
                    <VehicleNo><%:item.VehNo %></VehicleNo> 
                     <Visits>
                    <%foreach (com.IronOne.SLIC2.Models.Visit.VisitModel visit in item.JobVisits)
                      {%>
                      <Visit>
                        <VisitId><%=visit.VisitId %></VisitId>
                        <VisitTypeId><%=visit.VisitType %></VisitTypeId>
                        <VisitType><%= com.IronOne.IronUtils.EnumUtils.stringValueOf(typeof(com.IronOne.SLIC2.Models.Enums.VisitType), visit.VisitType.ToString())%></VisitType>
                        <VisitDate><%=visit.VisitedDate %></VisitDate>
                      </Visit>
                     <% } %>
                     </Visits>  
                   </Job>
                     <% } %>
                </JobList>
                <% } %>
	           <Server><%=com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.ServerId%></Server>
               <DateTime><%=DateTime.Now %></DateTime>
               <UTCDateTime><%=DateTime.UtcNow %></UTCDateTime>
            </Data>
</response>
