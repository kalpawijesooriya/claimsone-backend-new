<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Access Logs
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content">
        <div class="container">
            <h2>
                View Details</h2>
            <table border="0" cellpadding="0" cellspacing="0" style="color: #000">
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        Date From
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtDateFrom") %>
                    </td>
                    <td>
                    </td>
                    <td class="" style="border-top: 1px solid #aaa;">
                        To
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtInspecType") %>
                    </td>
                </tr>
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        Time From
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtDateFrom") %>
                    </td>
                    <td>
                    </td>
                    <td class="" style="border-top: 1px solid #aaa;">
                        To
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtInspecType") %>
                    </td>
                </tr>
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        Vehicle No
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtVehNo") %>
                    </td>
                    <td>
                    </td>
                    <td class="" style="border-top: 1px solid #aaa;">
                        Job No
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtInspecType") %>
                    </td>
                </tr>
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        CSR Code
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtCSRcode") %>
                    </td>
                    <td>
                    </td>
                    <td class="" style="border-top: 1px solid #aaa;">
                        User Name
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtUserName") %>
                    </td>
                </tr>
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        Branch
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <select id="branch" name="comboBranch">
                            <option value="Select Branch" selected="selected">Select Branch</option>
                        </select>
                    </td>
                    <td>
                    </td>
                    <td class="" style="border-top: 1px solid #aaa;">
                        Region
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <select id="Select1" name="comboBranch">
                            <option value="Select Branch" selected="selected">Region 1</option>
                        </select>
                    </td>
                </tr>
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        Inspection Type
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtInspecType") %>
                    </td>
                </tr>
            </table>
            <br />
            <div>
                <input type="submit" value="Search" class="btn-primary btn-primary:hover btn-large .caret" />
            </div>
        </div>
    </div>
    <br />
    <h2>
        Access Log Report</h2>
    <table class="table-bordered table-striped table-highlight">
        <thead>
            <tr>
                <th>
                    #
                </th>
                <th>
                    First Name
                </th>
                <th>
                    Last Name
                </th>
                <th>
                    Username
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    1
                </td>
                <td>
                    2
                </td>
                <td>
                    3
                </td>
                <td>
                    4
                </td>
            </tr>
        </tbody>
    </table>
    <br />
    <div>
        <input type="submit" value="Print" class="btn-primary btn-primary:hover btn .caret" />
        <input type="submit" value="Export to Excel" class="btn-primary btn-primary:hover btn .caret" />
    </div>
</asp:Content>
