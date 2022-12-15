<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%  /// <summary>
    ///  <title></title>
    ///  <description>Partial View for Menu with the top search panel</description>
    ///  <copyRight>Copyright (c) 2013</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2013-01-10</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>f
    /// </summary> %>
<% 
    com.IronOne.SLIC2.Models.Administration.UserDataModel user = (Session["LoggedUserDetail"] != null) ? Session["LoggedUserDetail"] as com.IronOne.SLIC2.Models.Administration.UserDataModel : null;
    string actions = (user != null) ? user.RolePermissions : string.Empty;                       
%>
<ul class="nav">
    <%if (!actions.Contains("AdvancedSearchExternal_HTML"))
      { %>
    <%if (actions.Contains("Index_HTML"))
      { %>
    <li class="nav-icon">
        <%: Html.ActionLink(" ", "Index", "Default", null, new { @class = "icon-home" })%>
    </li>
    <%} %>
    <li class="dropdown"><a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
        <%:Resources.info_menu_jobs%><b class="caret"></b></a>
        <ul class="dropdown-menu">
            <%if (actions.Contains("AdvancedSearch_HTML"))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_menu_jobSearch, "AdvancedSearch", "Job")%>
            </li>
            <%} %>
            <%if (actions.Contains("TempDeleteJob_HTML"))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_menu_tempdeleteJob, "TempDeleteJob", "Job")%>
            </li>
            <%} %>
        </ul>
    </li>
    <%} %>
    <%else
        { %>
    <li class="nav-icon">
      <%--  <%: Html.ActionLink(" ", "SearchResultsExternal", "Job", null, new { @class = "icon-home" })%>--%>
    </li>
    <%} %>
    <%if (actions.Contains("Maintenance_HTML"))
      { %>
    <li class="dropdown"><a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
        <%:Resources.info_gen_administration%><b class="caret"></b></a>
        <ul class="dropdown-menu">
            <%if (actions.Contains("ViewRegions_HTML"))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_gen_regionManagement, "ViewRegions", "Admin")%>
            </li>
            <%} %>
            <%if (actions.Contains("ViewBranches_HTML"))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_gen_branchManagement, "ViewBranches", "Admin")%></li>
            <%} %>
            <%if (actions.Contains("ViewUsers_HTML"))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_menu_userManagement, "ViewUsers", "Admin")%></li>
            <%} %>
            <%if (actions.Contains("AppManagement_HTML"))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_menu_appmanagement, "AppManagement", "Admin")%></li>
            <%} %>
            <%if (actions.Contains("AuditLog_HTML"))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_gen_accessLogs, "AuditLog", "Report")%></li>
            <%} %>
            <%if (actions.Contains("LockedUsers_HTML") && actions.Contains("UnlockUsers_HTML"))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_menu_unlockUsers, "LockedUsers", "Admin")%></li>
            <%} %>
            <%if (actions.Contains("ViewReports_HTML"))
              { %>
            <li class="dropdown-submenu"><a href="#">
                <%:Resources.info_gen_reports%>
            </a>
                <ul class="dropdown-menu">
                    <li>
                        <%: Html.ActionLink(Resources.info_menu_OnsiteEstimation, "OnSiteEstimation", "Report")%>
                    </li>
                    <%--<li>
                        <%: Html.ActionLink(Resources.info_menu_RegionOnsite, "OnSiteEstimationRegion", "Report")%>
                    </li>--%>
                    <%--Joined to the same report--%>
                    <li></li>
                    <li>
                        <%: Html.ActionLink(Resources.info_menu_MissingImagesReport, "MissingImages", "Report")%>
                    </li>
                    <li>
                        <%: Html.ActionLink(Resources.info_menu_regLevPerformance, "RegionalLevelPerformance", "Report")%>
                    </li>
                    <li>
                        <%: Html.ActionLink(Resources.info_gen_outstandingReport, "RegionalLevelOutstandingReports", "Report")%>
                    </li>
                    <li>
                        <%: Html.ActionLink(Resources.info_gen_photoAvailabilityReport, "RegionalLevelPhotoAvailabilityReports", "Report")%>
                    </li>
                    <li>
                        <%: Html.ActionLink(Resources.info_gen_VisitedTimeDifferenceReport, "VisitedTimeDifferenceReport", "Report")%>
                    </li>
                     <li>
                        <%: Html.ActionLink(Resources.info_gen_investiagtionMonitoringReport, "InvestigationMonitoringReport", "Report")%>
                    </li>
                      <li>
                        <%: Html.ActionLink("ARI PhotoAvailability Report", "ARIPhotoAvailabilityReport", "Report")%>
                    </li>
                    <li>
                        <%: Html.ActionLink("Outsatanding SA Test", "OutstandingSATest", "Report")%>
                    </li>
                </ul>
            </li>
            <%} %>
        </ul>
    </li>
    <%} %>
    <%if (actions.Contains("MyProfile_HTML"))
      { %>
    <li class="dropdown"><a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown">
        <%:Resources.info_menu_profile%>
        <b class="caret"></b></a>
        <ul class="dropdown-menu">
            <%if (actions.Contains("ChangePassword_HTML"))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_gen_changePassword, "ChangePassword", "LogOn")%></li>
            <%} %>
            <%if (actions.Contains("UpdateProfile_HTML"))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_gen_updateProfile, "UpdateProfile", "Admin")%></li>
            <%} %>
            <%if (actions.Contains("TOPerformance_HTML") && user.RoleName.Equals(Resources.info_role_technicalOfficer))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_gen_TOsPerformance, "TOPerformance", "Report")%>
            </li>
            <%} %>
            <%if (user.RoleName.Equals(Resources.info_role_technicalOfficer))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_menu_MissingImagesReport, "MissingImages", "Report")%>
            </li>
            <%} %>
            <%if (actions.Contains("OutstandingSAReports_HTML") && user.RoleName.Equals(Resources.info_role_technicalOfficer))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_gen_outstandingReport, "OutstandingSAReports", "Report")%></li>
            <%} %>
            <%if (user.RoleName.Equals(Resources.info_role_technicalOfficer))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_menu_OnsiteEstimation, "OnSiteEstimation", "Report")%>
            </li>
            <%} %>
            <%if (actions.Contains("PhotoAvailabilityReports_HTML") && user.RoleName.Equals(Resources.info_role_technicalOfficer))
              { %>
            <li>
                <%: Html.ActionLink(Resources.info_gen_photoAvailabilityReport, "PhotoAvailabilityReports", "Report")%></li>
            <%} %>
        </ul>
    </li>
    <%} %>
</ul>
