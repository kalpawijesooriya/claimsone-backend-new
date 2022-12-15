<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<com.IronOne.SLIC2.Models.Job.CommentModel>>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%  /// <summary>
    ///  <title></title>
    ///  <description>Partial View for</description>
    ///  <copyRight>Copyright (c) yyyy</copyRight>
    ///  <company>IronOne Technologies (Pvt)Ltd</company>
    ///  <createdOn>yyyy-mm-dd</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    /// </summary> %>
<br />
<%if (Model != null && Model.Count() > 0)
  { %>
<table class="table" bordercolor="#CCCCCC" border="1">
    <tr>
        <th>
            <%:Resources.info_gen_dateAndTime%>
        </th>
        <th>
            <%:Resources.info_gen_commentedBy%>
        </th>
        <th>
            <%:Resources.info_gen_comment%>
        </th>
    </tr>
    <% 
      foreach (var item in Model)
      { %>
    <tr>
        <td style="width: 20%">
            <%if (item.CommentedDate != null)
              { %>
            <%:item.CommentedDate.ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateTimeFormat)%>
            <%} %>
        </td>
        <td style="width: 20%">
            <%: item.CommentedByFullName%>
        </td>
        <td style="width: 60%">
            <%: item.Comment%>
        </td>
    </tr>
    <% }%></table>
<%}
  else
  { %>
<div>
    <%: Resources.info_gen_norecordsavailable %>
</div>
<%} %>