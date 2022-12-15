<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<SLIC.Models.Reports.InqueryModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%@ Import Namespace="com.IronOne.SLIC2.HandlerClasses" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../../App_Themes/SLIC/Content/js/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../../../App_Themes/SLIC/Content/js/jquery-ui-1.8.18.custom.min.js"
        type="text/javascript"></script>
    <script src="../../../App_Themes/SLIC/Content/js/jquery-ui-1.8.21.custom.min.js"
        type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $(".idatepicker-basic").datepicker({ changeYear: true, changeMonth: true, yearRange: "-150:+0", dateFormat: '<%= ApplicationSettings.GetJqueryDateOnlyFormat %>' });
        });
    </script>
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>Inquiry report page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-20</createdOn>
    ///  <author>Suren Manawatta</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
    %>
    ReportInquery
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="span12">
        <div class="widget">
            <div class="widget-header">
                <h3>
                    <i class="icon-search"></i>
                    <%: Resources.info_gen_advancedSearch %>
                </h3>
            </div>
            <div class="widget-content">
                <table width="100%">
                    <tr>
                        <td>
                            <label class="control-label">
                                <%: Resources.info_gen_dateFrom %>
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.DateFrom, new { @class = "idatepicker-basic" })%>
                        </td>
                        <td>
                            <label class="control-label">
                                <%: Resources.info_gen_dateTo %>
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.DateTo, new { @class = "idatepicker-basic" })%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label">
                                <%: Resources.info_gen_vehicleNo %>
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.VehicleNo, new { @class = "input-large" })%>
                        </td>
                        <td>
                            <label class="control-label">
                                <%: Resources.info_gen_jobNo %>
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.JobNo, new { @class = "input-large" })%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label">
                                <%: Resources.info_gen_csrCode %>
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.CSRCode, new { @class = "input-large" })%>
                        </td>
                        <td>
                            <label class="control-label">
                                <%: Resources.info_gen_csrName%>
                            </label>
                        </td>
                        <td>
                            <%: Html.TextBoxFor(model => model.CSRName, new { @class = "input-large" })%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label">
                                <%: Resources.info_gen_branch%>
                            </label>
                        </td>
                        <td>
                            <%: Html.DropDownListFor(model => model.Branch, (IEnumerable<SelectListItem>)(ViewData["Branches"]))%>
                        </td>
                        <td>
                            <label class="control-label">
                                <%: Resources.info_gen_branch%>
                            </label>
                        </td>
                        <td>
                            <%: Html.DropDownListFor(model => model.Region, (IEnumerable<SelectListItem>)(ViewData["Regions"]))%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                            <input type="submit" class="btn btn-primary btn-small" value="<%: Resources.info_gen_search%>" />
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="span12">
        <div class="widget-header">
            <h3>
                <i class="icon-th-list"></i>
                <%: Resources.info_gen_inquiryReportResult%>
            </h3>
        </div>
        <div class="widget-content">
            <div class="widget widget-table">
                <table class="table table-bordered table-striped table-highlight">
                    <thead>
                        <tr>
                            <th style="width: 12.5%">
                                <%: Resources.info_gen_vehicleNo%>
                            </th>
                            <th style="width: 12.5%">
                                <%: Resources.info_gen_jobNo%>
                            </th>
                            <th style="width: 12.5%">
                                <%: Resources.info_gen_dateOfAccident%>
                            </th>
                            <th style="width: 12.5%">
                                <%: Resources.info_gen_csrCode%>
                            </th>
                            <th style="width: 12.5%">
                                <%: Resources.info_gen_acr%>
                            </th>
                            <th style="width: 12.5%">
                                <%: Resources.info_gen_saFormPrint + " " + Resources.info_gen_yesno%>
                            </th>
                            <th style="width: 12.5%">
                                <%: Resources.info_gen_claimFormImage + " " + Resources.info_gen_yesno%>
                            </th>
                            <th style="width: 12.5%">
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                KT-2987
                            </td>
                            <td>
                                Job 01
                            </td>
                            <td>
                                20/10/12
                            </td>
                            <td>
                                0001
                            </td>
                            <td>
                                xxxx
                            </td>
                            <td>
                                Y
                            </td>
                            <td>
                                N
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                Job 01
                            </td>
                            <td>
                                22/10/12
                            </td>
                            <td>
                                0001
                            </td>
                            <td>
                                xxxx
                            </td>
                            <td>
                                Y
                            </td>
                            <td>
                                N
                            </td>
                            <td>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
