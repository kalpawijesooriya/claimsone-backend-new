<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Administration.RegionDataModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Controllers" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>region view page</description>
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
    <!-- Styles -->
    <link href="../../../Content/js/Slate/plugins/datatables/DT_bootstrap.css" rel="stylesheet"
        type="text/css" />
    <!-- JavaScript -->
    <script src="../../../Content/js/Slate/plugins/datatables/jquery.dataTables.js" type="text/javascript"></script>
    <script src="../../../Content/js/Slate/plugins/datatables/DT_bootstrap.js" type="text/javascript"></script>
    <script src="../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.js"
        type="text/javascript"></script>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            var actionUrl = '<%: Html.ActionLink(" ", "RegionListAjaxHandler", "Admin", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            var oTable = $('#regions').dataTable({
                "bJQueryUI": false,
                "bServerSide": true,
                "bProcessing": true,
                "sPaginationType": "full_numbers",
                "oLanguage": {
                    "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
                },
                "sAjaxSource": actionUrl,
                "aoColumns": [
                { "sName": "regionname",
                    "bSearchable": true,
                    "bSortable": true
                },
                { "sName": "regioncode",
                    "bSearchable": true,
                    "bSortable": true,
                    "sWidth": "200"
                },
                { "sName": "options",
                    "bSearchable": false,
                    "bSortable": false,
                    "sClass": "btnColumn-small"
                }]
            }
            );
        });
    </script>
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <%: Resources.info_gen_regionManagement%>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="span12">
        <div class="widget widget-table">
            <div class="widget-header">
                <h3>
                    <i class="icon-th-list"></i>
                    <%: Resources.info_gen_regionManagement%>
                </h3>
                <div class="top-button-right">
                    <%: Html.ActionLink(Resources.info_gen_createRegion, "CreateRegion", "Admin", null, new { @class = "btn btn-primary btn-small", @title = Resources.info_gen_createRegion })%>
                </div>
            </div>
            <!-- /widget-header -->
            <div class="widget-content grid-table-background">
                <% ModelState err = ViewContext.ViewData.ModelState["err"];

                   if (err != null)
                   {
                       GenException result = (GenException)err.Errors.ElementAt(0).Exception;

                       if (result.Code == 120)
                       { %>
                <div class="alert alert-success">
                    <a class="close" data-dismiss="alert" href="#">&times;</a>
                    <h4 class="alert-heading">
                        <%: Resources.info_gen_success %></h4>
                    <%: result.Message %>
                </div>
                <% }
                       else
                       { %>
                <div class="alert alert-error">
                    <a class="close" data-dismiss="alert" href="#">&times;</a>
                    <h4 class="alert-heading">
                        <%: Resources.info_gen_error %></h4>
                    <%: result.Message %>
                </div>
                <% } %>
                <%  } %>
                <table class="table table-striped table-bordered table-highlight" id="regions">
                    <thead>
                        <tr>
                            <th>
                                <%: Resources.info_gen_regionName %>
                            </th>
                            <th>
                                <%: Resources.info_gen_regionCode %>
                            </th>
                            <th>
                                <%: Resources.info_gen_options %>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                <div class="form-actions Grid-bottom-buttons">
                    <%: Html.ActionLink(Resources.info_gen_createRegion, "CreateRegion", "Admin", null, new { @class = "btn btn-primary", @title = Resources.info_gen_createRegion })%>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
