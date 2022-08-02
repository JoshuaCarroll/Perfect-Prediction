<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="PerfectPrediction.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Login ID="Login1" runat="server" DestinationPageUrl="dashboard.aspx" OnAuthenticate="Login1_Authenticate" UserNameLabelText="Username:"></asp:Login>
        </div>
    </form>
</body>
</html>
