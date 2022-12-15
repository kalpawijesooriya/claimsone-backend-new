<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Role Assignments
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="content">
        <div class="container">
            <h2>
                View Details</h2>
            <table border="0" cellpadding="0" cellspacing="0" style="color: #000">
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        Username
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
                        First Name
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtFirstName") %>
                    </td>
                </tr>
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        Last Name
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtLastName") %>
                    </td>
                </tr>
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        Email
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtEmail") %>
                    </td>
                </tr>
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        Password
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtPassword") %>
                    </td>
                </tr>
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border-top: 1px solid #aaa;">
                        Confirm Password
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <%: Html.TextBox("txtCPassword") %>
                    </td>
                </tr>
                <tr class="" style="border: 1px solid #aaa;">
                    <td class="" style="border: 1px solid #aaa;">
                        User Role
                    </td>
                    <td class="">
                        :
                    </td>
                    <td>
                        <select id="select1" name="comboRole">
                            <option value="User Role" selected="selected">Technical Officer</option>
                        </select>
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
                        <%: Html.TextBox("txtCSRCode") %>
                    </td>
                </tr>
            </table>
            <br />
            <div>
                <input type="submit" value="Create" class="btn-primary btn-primary:hover btn .caret" />
                <input type="submit" value="All Users" class="btn-primary btn-primary:hover btn .caret" />
            </div>
        </div>
    </div>
</asp:Content>
