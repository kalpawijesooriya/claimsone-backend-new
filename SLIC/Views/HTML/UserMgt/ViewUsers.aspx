<%@ Page Title="" Language="C#" MasterPageFile="~/Views/HTML/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Controllers" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Auth" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeaderContent" runat="server">
    <%
        /// <summary>
        /// 
        ///  <title>SLIC2</title>
        ///  <description>user view page</description>
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
    <link href="../../../Content/css/ui-lightness/jquery-ui-1.8.21.custom.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../Content/js/Slate/plugins/datatables/DT_bootstrap.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.css"
        rel="stylesheet" type="text/css" />
    <!--Scripts -->
    <script src="../../../Content/js/media/js/jquery.dataTables.min.js" type="text/javascript"></script>
    <script src="../../../Content/js/media/js/TableTools.js" type="text/javascript"></script>
    <script src="../../../Content/js/media/js/ZeroClipboard.js" type="text/javascript"></script>
    <script src="../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.js"
        type="text/javascript"></script>
    <script src="../../../Content/js/Slate/plugins/msgAlert/js/msgAlert.js" type="text/javascript"></script>
    <link href="../../../Content/js/Slate/plugins/msgAlert/css/msgAlert.css" rel="stylesheet"
        type="text/css" />
    <% bool lockedUsers = ViewData["lockedUsers"] != null ? (bool)ViewData["lockedUsers"] : false; %>
    <script type="text/javascript">
        $(document).ready(function() {
            var aSelected = [];
            GetRolesListToDropdown()            
                <% if (lockedUsers) { %>
            $('#AllUsersTableView tbody tr').live('click', function () {
                var id = $(this).find('td.identifier').text();
                var index = jQuery.inArray(id, aSelected);
                 
                if ( index === -1 ) {
                    aSelected.push( id );
                } else {
                    aSelected.splice( index, 1 );
                }
                 
                $(this).toggleClass('row_selected');
            });

            $('#unlockButton').live('click', function() {
                var actionUrl = '<%: Html.ActionLink(" ", "UnlockUsers", "Admin", null, null) %>';
                actionUrl = actionUrl.replace('<a href="', '');
                actionUrl = actionUrl.replace('"> </a>', '');
                actionUrl = actionUrl.replace('amp;', '');
                actionUrl = actionUrl.replace('amp;', '');

                var postData = { UserNames : aSelected };
                $.ajax({
                    type: "POST",
                    url: actionUrl,
                    data: postData,
                    dataType: "json",
                    traditional: true,
                    success : function (data) {
                        var status = data.status;
                        if (status)
                        {
                            $.msgGrowl({type: "success", text: data.message, title: "<%: Resources.info_gen_success %>", position: "bottom-right", onClose:function() { GetUserListAsync(); }})
                        }
                        else
                        {
                            $.msgGrowl({type: "error", text: data.message, title: "<%: Resources.info_gen_attention %>", position: "bottom-right", onClose:function() { GetUserListAsync(); }});
                        }
                    }
                });

                return false;
            });
    <% } %>
        function GetUserListAsync() {
            var actionUrl = '<%: Html.ActionLink(" ", "UserListAjaxHandler", "Admin", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            var userType = $('#rolesList option:selected').text();

            $('#AllUsersTableView').dataTable({
                "bJQueryUI": false,
                "bServerSide": true,
                "bProcessing": true,
                "bDestroy": true,
                "sPaginationType": "full_numbers",
                "oLanguage": {
                    "sEmptyTable": "<%: Resources.info_gen_norecordsavailable %>"
                },
                "sAjaxSource": actionUrl,
                "fnServerParams": function (aoData) {
                    aoData.push({ "name": "roleName", "value": userType });
                    <% if (lockedUsers) { %>
                        aoData.push({ "name": "isLockedUsers", "value": true });
                    <% } else { %>
                        aoData.push({ "name": "isLockedUsers", "value": false });
                    <% } %>
                },
                "fnInitComplete": function (oSettings) { //jQuery success 
                    if (oSettings.aoData.length > 0) {
                        var optionColNotAval = true; //not available
                        for (var i = 0; i < oSettings.aoData.length; i++) {
                            $(oSettings.aoData[i]).attr('id', oSettings.aoData[i]._aData[0]);
                            if (oSettings.aoData[i]._aData[7] != null && (oSettings.aoData[i]._aData[7].toString().indexOf("<a href=") !== -1)) {
                                optionColNotAval = false; //available
                                //break;
                            }
                        }
                        if (optionColNotAval) { //not available
                            var oTable = $('#AllUsersTableView').dataTable();
                            var bVis = oTable.fnSettings().aoColumns[7].bVisible;
                            oTable.fnSetColumnVis(7, bVis ? false : true);
                        }
                    }
                },
                <% if (lockedUsers) { %>
                "fnRowCallback": function( nRow, aData, iDisplayIndex ) {
                    if ( jQuery.inArray($(nRow).find('td.identifier').text(), aSelected) !== -1 ) {
                        $(nRow).addClass('row_selected');
                    }
                },
                <% } %>
                "aoColumns": [
                    { "sName": "csrcode",
                        "bSearchable": true,
                        "bSortable": true,
                        "sWidth": "100"
                    },
                    { "sName": "username",
                        "bSearchable": true,
                        "bSortable": true,
                        "sWidth": "120",
                        "sClass": "identifier"
                    },
                    { "sName": "firstname",
                        "bSearchable": true,
                        "bSortable": true
                    },
                    { "sName": "lastname",
                        "bSearchable": true,
                        "bSortable": true
                    },
                     { "sName": "userrole",
                         "bSearchable": true,
                         "bSortable": true
                     },
                    { "sName": "emailaddress",
                        "bSearchable": true,
                        "bSortable": true
                    },
                    { "sName": "branch",
                        "bSearchable": true,
                        "bSortable": true,
                        "sWidth": "150"
                    }
                    <% if (!lockedUsers) {%>
                    ,
                    { "sName": "options",
                        "bSearchable": false,
                        "bSortable": false,                       
                        "sClass": "btnColumn-small"
                    }<% } %>]
            });
        }

        function GetRolesListToDropdown() {
            $('#Loadingistriggered').hide();
            $("#rolesList").attr('disabled', 'disabled');

            var actionUrl = '<%: Html.ActionLink(" ", "GetRolesListJson", "Admin", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');

            $.ajax({
                type: "POST",
                url: actionUrl,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: 'true',
                cache: 'false',
                beforeSend: function () {
                    $("#Loadingistriggered").show();
                },
                success: function (data) {
                    data = data.Data;
                    $('#Loadingistriggered').hide();
                    if (data && data.length > 0) {
                        if (data instanceof Array) {
                            var options = '';
                            for (var p in data) {
                                var product = data[p];
                                options += "<option value='" + product.Value + "'>" + product.Value + "</option>";
                            }
                            $("#rolesList").removeAttr('disabled').html(options);

                            GetUserListAsync();
                            GetUserType();
                        } else {
                            $("#rolesList").attr('disabled', true).html('');
                            $('#Loadingistriggered').hide();
                        }

                    } else {
                        $("#rolesList").attr('disabled', true).html('');
                        $('#Loadingistriggered').hide();
                    }
                },
                error: function () {
                    $("#rolesList").attr('disabled', true).html('');
                    $('#Loadingistriggered').hide();
                }
            });
        };

        function GetUserType() {
            var userType = $('#rolesList option:selected').text();
            if (userType == "Engineer") {
                $('#branchRegionHeading').text("Region");
            } else {
                $('#branchRegionHeading').text("Branch");
            }
        }

        function ddListChange() {
            GetUserType();
            GetUserListAsync();
        }

        $('#rolesList').live('click', function(){
            ddListChange();
        });
        });
    </script>
</asp:Content>
<asp:Content ID="TitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    <% bool lockedUsers = ViewData["lockedUsers"] != null ? (bool)ViewData["lockedUsers"] : false; %>
    <% if (lockedUsers)
       { %>
    <%: Resources.info_menu_unlockUsers%>
    <% }
       else
       { %>
    <%: Resources.info_menu_userManagement%>
    <% } %>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <% bool lockedUsers = ViewData["lockedUsers"] != null ? (bool)ViewData["lockedUsers"] : false; %>
    <div class="span12">
        <div class="widget widget-table">
            <div class="widget-header">
                <h3>
                    <i class="icon-tasks"></i>
                    <% if (lockedUsers)
                       { %>
                    <%: Resources.info_menu_unlockUsers%>
                    <% }
                       else
                       { %>
                    <%: Resources.info_menu_userManagement%>
                    <% } %>
                </h3>
                <div class="top-button-right">
                    <% bool authorized = RoleAuthorizationService.IsAuthorized("CreateUser_HTML"); %>
                    <% if (!lockedUsers && authorized)
                       { %>
                    <%: Html.ActionLink(Resources.info_gen_createUser, "CreateUser", "Admin", null, new { @class = "btn btn-primary btn-small", @title = Resources.info_gen_createUser }) %>
                    <% } %>
                </div>
            </div>
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
                <%if (lockedUsers)
                  { %>
                <div class="alert alert-info">
                    <a class="close" href="#" data-dismiss="alert">&times;</a>
                    <h4 class="alert-heading">
                        <%: Resources.info_gen_info%></h4>
                    <%: Resources.info_gen_unlockUserInfo%>
                </div>
                <%} %>
                <div class="btn-group dataTables_wrapper">
                    <!-- User Type dropdown list  -->
                    <%: Resources.info_gen_userType %>: &nbsp;
                    <% if (!RoleAuthorizationService.IsEngineer(User.Identity.Name))
                       { %>
                    <select id="rolesList">
                    </select>
                    <img src="../../../Content/img/loading.gif" alt="Loading..." width="24" height="24"
                        id="Loadingistriggered" />
                    <% }
                       else
                       { %>
                    <select id="ddlListDis" disabled="disabled">
                        <option>
                            <%: Resources.info_role_technicalOfficer %></option>
                    </select>
                    <% } %>
                </div>
                <table id="AllUsersTableView" class="table table-striped table-bordered table-highlight"
                    <% if (lockedUsers) { %> style='cursor: pointer;' <% } %>>
                    <thead>
                        <tr>
                            <th>
                                <%:Resources.info_gen_csrCode %>
                            </th>
                            <th>
                                <%:Resources.info_gen_userName %>
                            </th>
                            <th>
                                <%:Resources.info_gen_firstName%>
                            </th>
                            <th>
                                <%:Resources.info_gen_lastName%>
                            </th>
                            <th>
                                <%:Resources.info_gen_email%>
                            </th>
                            <th>
                                <%:Resources.info_gen_userRole%>
                            </th>
                            <th id="branchRegionHeading">
                            </th>
                            <% if (!lockedUsers)
                               {%>
                            <th>
                                <%:Resources.info_gen_options%>
                            </th>
                            <% } %>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                <div class="form-actions Grid-bottom-buttons">
                    <% if (lockedUsers)
                       {%>
                    <%: Html.ActionLink(Resources.info_gen_unlockUsers, "UnlockUsers", "Admin", null, new { @id = "unlockButton", @class = "btn btn-primary btn-small", @title = Resources.info_gen_unlockUsers }) %>
                    <% }
                       else
                       { %>
                    <% if (authorized)
                       { %>
                    <%: Html.ActionLink(Resources.info_gen_createUser, "CreateUser", "Admin", null, new { @class = "btn btn-primary btn-small", @title = Resources.info_gen_createUser }) %>
                    <% } %>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
