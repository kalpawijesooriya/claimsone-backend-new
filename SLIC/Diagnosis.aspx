<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Diagnosis.aspx.cs" Inherits="com.IronOne.SLIC2.Diagnosis" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Diagnostics</title>
    <style type="text/css">
        .style1
        {
            width: 400px;
            background-color: honeydew;
        }        
        .style2
        {
            width: 400px;
            background-color: #336633;
            color: White;
        }
    </style>
</head>
<body style="font-family: 'Segoe UI'">
    <form id="formDiagnostics" runat="server">
    <div>
        <table style="width: 100%;">
            <tr>
                <td class="style2">
                    <h4 style="padding: 5px;">
                        ClaimsOne Diagnostic Page</h4>
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <b>Email Diagnostics</b>
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <asp:Panel ID="Panel1" runat="server">
                    <td class="style1">
                        To :
                        <asp:TextBox ID="txtEmail" runat="server" ValidationGroup="v1"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Required Field"
                            ClientIDMode="Inherit" ControlToValidate="txtEmail" Display="Dynamic" Font-Bold="True"
                            SetFocusOnError="True" ValidationGroup="v1"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Email Validation Failed"
                            ControlToValidate="txtEmail" Display="Dynamic" Font-Bold="True" ValidationGroup="v1"
                            SetFocusOnError="True" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                        <br />
                        <asp:Button ID="btnEmailCheck" runat="server" Text="Check" OnClick="btnEmailCheck_Click"
                            ValidationGroup="v1" />
                    </td>
                    <td>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </asp:Panel>
            </tr>
            <tr>
                <td class="style1">
                    <asp:Label ID="lblEmailResult" runat="server" Text=""></asp:Label>
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="style1">
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <b>Database Connection Diagnostics</b>
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <asp:Button ID="btnConnectionCheck" runat="server" Text="Check" OnClick="btnConnectionCheck_Click" />
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <asp:Label ID="lblConnectionResult" runat="server" Text=""></asp:Label>
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="style1">
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <b>Other Diagnostics</b>
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="style1">
                </td>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
