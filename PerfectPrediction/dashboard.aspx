<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="PerfectPrediction.dashboard" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Perfect Prediction Admin</title>
    <link rel="stylesheet" type="text/css" href="StyleSheetDashboard.css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:LinkButton ID="linkNewGame" runat="server" OnClick="linkNewGame_Click">New game</asp:LinkButton> | 
        <asp:LinkButton ID="linkSettings" runat="server" OnClick="linkSettings_Click">Settings</asp:LinkButton> | 
        <asp:LinkButton ID="linkLogout" runat="server" OnClick="linkLogout_Click">Logout</asp:LinkButton> | 
        <a href="https://github.com/JoshuaCarroll/Perfect-Prediction/issues" target="_blank">Report a problem or idea</a>
        <br />
        <asp:GridView ID="gridViewGames" runat="server" AutoGenerateColumns="False" CellPadding="4" DataSourceID="sqlDataSourceGames" ForeColor="#333333" GridLines="None" Width="1678px" OnSelectedIndexChanged="gridViewGames_SelectedIndexChanged" BorderColor="#003366" BorderStyle="Solid" DataKeyNames="ID" CssClass="gridViewGames">
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <Columns>
                <asp:CommandField SelectText="Edit" ShowSelectButton="True" />
                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                <asp:BoundField DataField="Away Team" HeaderText="Away Team" SortExpression="Away Team" />
                <asp:BoundField DataField="Home Team" HeaderText="Home Team" SortExpression="Home Team" />
                <asp:BoundField DataField="Game Time" HeaderText="Game Time" ReadOnly="True" SortExpression="Game Time" />
                <asp:BoundField DataField="Winner" HeaderText="Winner" ReadOnly="True" SortExpression="Winner" />
                <asp:BoundField DataField="QR Code" HeaderText="QR Code" HtmlEncode="False" ReadOnly="True" SortExpression="QR Code" />
                <asp:BoundField DataField="URL" HeaderText="URL" HtmlEncode="False" ReadOnly="True" SortExpression="URL" />
            </Columns>
            <EditRowStyle BackColor="#999999" />
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#E9E7E2" />
            <SortedAscendingHeaderStyle BackColor="#506C8C" />
            <SortedDescendingCellStyle BackColor="#FFFDF8" />
            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
        </asp:GridView>
        <asp:SqlDataSource ID="sqlDataSourceGames" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
            OldValuesParameterFormatString="original_{0}" 
            SelectCommand="SELECT Games.ID, TeamsAway.Name [Away Team], TeamsHome.Name [Home Team], FORMAT(GameTime, 'MM/dd/yyyy h:mm tt') [Game Time], CONCAT(Predictions.Name, '   ', Predictions.Email) [Winner], CONCAT('&lt;a target=&quot;_blank&quot; href=&quot;https://api.qrserver.com/v1/create-qr-code/?data=https://perfectprediction.aa5jc.com/?g=', Games.ID,'&quot;&gt;&lt;img class=&quot;qrcode&quot; src=&quot;https://api.qrserver.com/v1/create-qr-code/?data=https://perfectprediction.aa5jc.com/?g=', Games.ID, '&amp;size=200x200&quot;/&gt;&lt;/a&gt;') [QR Code], CONCAT('&lt;a target=&quot;_blank&quot; href=&quot;https://perfectprediction.aa5jc.com/?g=', Games.ID, '&quot;&gt;Link&lt;/a&gt;') [URL] FROM [Games] 
INNER JOIN Teams [TeamsAway] on TeamsAway.Id = Games.AwayTeamID 
INNER JOIN Teams [TeamsHome] on TeamsHome.Id = Games.HomeTeamID
LEFT JOIN Predictions on Predictions.Id = Games.WinningPredictionID 
WHERE (Games.TenantID = @TenantID) 
ORDER BY [GameTime]" >
            <SelectParameters>
                <asp:SessionParameter DefaultValue="1" Name="TenantID" SessionField="TenantID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqlDataSourceTeams" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" DeleteCommand="DELETE FROM [Teams] WHERE [Id] = @original_Id" InsertCommand="INSERT INTO [Teams] ([Name]) VALUES (@Name)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT [Id], [Name] FROM [Teams] WHERE ([TenantID] = @TenantID) ORDER BY [Name]" UpdateCommand="UPDATE [Teams] SET [Name] = @Name WHERE [Id] = @original_Id">
            <DeleteParameters>
                <asp:Parameter Name="original_Id" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="Name" Type="String" />
            </InsertParameters>
            <SelectParameters>
                <asp:SessionParameter DefaultValue="0" Name="TenantID" SessionField="TenantID" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="original_Id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:Panel ID="pnlEditGame" runat="server" Visible="False">
            <h2>Edit Game</h2>
            <br />
            <asp:Label CssClass="label" ID="Label1" runat="server" Text="Game date"></asp:Label>
            <asp:TextBox ID="txtGameDate" runat="server"></asp:TextBox>
            <ajaxToolkit:CalendarExtender ID="txtGameDate_CalendarExtender" runat="server" BehaviorID="txtGametime_CalendarExtender" PopupButtonID="btnCalendarSelect" TargetControlID="txtGameDate" />
            &nbsp;<asp:Button ID="btnCalendarSelect" runat="server" Text="Select" />
            <br />
            <asp:Label ID="lblGameTime" runat="server" Text="Game time" CssClass="label"></asp:Label>
            <asp:DropDownList ID="ddlGameTimeHour" runat="server">
                <asp:ListItem Value="1">1</asp:ListItem>
                <asp:ListItem Value="2">2</asp:ListItem>
                <asp:ListItem Value="3">3</asp:ListItem>
                <asp:ListItem Value="4">4</asp:ListItem>
                <asp:ListItem Value="5">5</asp:ListItem>
                <asp:ListItem Value="6">6</asp:ListItem>
                <asp:ListItem Selected="True" Value="7">7</asp:ListItem>
                <asp:ListItem Value="8">8</asp:ListItem>
                <asp:ListItem Value="9">9</asp:ListItem>
                <asp:ListItem Value="10">10</asp:ListItem>
                <asp:ListItem>11</asp:ListItem>
                <asp:ListItem>12</asp:ListItem>
            </asp:DropDownList>
            :<asp:DropDownList ID="ddlGameTimeMinute" runat="server">
                <asp:ListItem Selected="True">00</asp:ListItem>
                <asp:ListItem>15</asp:ListItem>
                <asp:ListItem>30</asp:ListItem>
                <asp:ListItem>45</asp:ListItem>
            </asp:DropDownList>
            &nbsp;<asp:DropDownList ID="ddlGameTimeAP" runat="server">
                <asp:ListItem>AM</asp:ListItem>
                <asp:ListItem Selected="True">PM</asp:ListItem>
            </asp:DropDownList>
            <br />
            <asp:Label CssClass="label" ID="Label2" runat="server" Text="Home team"></asp:Label>
            <ajaxToolkit:ComboBox ID="cbHomeTeam" runat="server" DataSourceID="sqlDataSourceTeams" DataTextField="Name" DataValueField="Id" MaxLength="0" OnItemInserting="comboboxTeam_ItemInserting" style="display: inline;">
            </ajaxToolkit:ComboBox>
            <asp:Image ID="imgHomeTeam" runat="server" CssClass="teamImage" />
            <asp:FileUpload ID="FileUploadHomeTeam" runat="server" />
            <br />
            <asp:Label CssClass="label" ID="Label3" runat="server" Text="Away team"></asp:Label>
            <ajaxToolkit:ComboBox ID="cbAwayTeam" runat="server" DataSourceID="sqlDataSourceTeams" DataTextField="Name" DataValueField="Id" MaxLength="0" style="display: inline;" OnItemInserting="comboboxTeam_ItemInserting">
            </ajaxToolkit:ComboBox>
            <asp:Image ID="imgAwayTeam" runat="server" CssClass="teamImage" />
            <asp:FileUpload ID="FileUploadAwayTeam" runat="server" />
            <br />
            <asp:Label CssClass="label" ID="Label4" runat="server" Text="Home score"></asp:Label>
            <asp:TextBox ID="txtHomeScore" runat="server"></asp:TextBox>
            <br />
            <asp:Label CssClass="label" ID="Label5" runat="server" Text="Away score"></asp:Label>
            <asp:TextBox ID="txtAwayScore" runat="server"></asp:TextBox>
            <br />
            <asp:Label CssClass="label" ID="lblWinner" runat="server" Text="Winner"></asp:Label>
            <asp:TextBox ID="txtWinner" runat="server" Enabled="False"></asp:TextBox>
            <br />
            <br />
            <asp:Button ID="btnGameSave" runat="server" Text="Save" OnClick="btnGameSave_Click" />
            <asp:Button ID="btnGameCancel" runat="server" OnClick="btnGameCancel_Click" Text="Cancel" />
            <asp:HiddenField ID="hdnGameId" runat="server" />
            <br />
            <h3><asp:Label ID="lblEntries" runat="server" Text="Entries"></asp:Label></h3><asp:GridView ID="gridviewEntries" runat="server" AllowSorting="True" CellPadding="4" DataSourceID="SqlDataSourceEntries" ForeColor="#333333" GridLines="None" Width="1414px" AutoGenerateColumns="False">
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                <asp:BoundField DataField="HomeScore" HeaderText="HomeScore" SortExpression="HomeScore" />
                <asp:BoundField DataField="AwayScore" HeaderText="AwayScore" SortExpression="AwayScore" />
            </Columns>
            <EditRowStyle BackColor="#999999" />
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#E9E7E2" />
            <SortedAscendingHeaderStyle BackColor="#506C8C" />
            <SortedDescendingCellStyle BackColor="#FFFDF8" />
            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSourceEntries" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Name], [Email], [HomeScore], [AwayScore] FROM [Predictions] WHERE ([GameID] = @GameID) ORDER BY [Id]">
                <SelectParameters>
                    <asp:ControlParameter ControlID="gridViewGames" Name="GameID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </asp:Panel>
        <asp:Panel ID="pnlSettings" runat="server" Visible="False">
            <h2>Settings</h2>
            
            
            <asp:Label ID="Label7" runat="server" Text="Username" CssClass="label"></asp:Label>
            <asp:TextBox ID="txtUsername" runat="server" Enabled="False"></asp:TextBox><br />
            <asp:Label ID="Label8" runat="server" Text="Password" CssClass="label"></asp:Label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
            
            
            <br />
            <asp:Label ID="Label9" runat="server" Text="Name" CssClass="label"></asp:Label>
            <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="lblEmail" runat="server" Text="Email" CssClass="label"></asp:Label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"></asp:TextBox>
            <br />
            <asp:Label ID="Label10" runat="server" Text="Sponsor Logo" CssClass="label"></asp:Label>
            <asp:Image ID="imgSponsor" runat="server" />
            <asp:FileUpload ID="FileUploadSponsor" runat="server" />
            <br />
            <asp:Label ID="Label11" runat="server" CssClass="label" Text="Sponsor URL"></asp:Label>
            <asp:TextBox ID="txtSponsorUrl" runat="server"></asp:TextBox>
            <br />
            <br />
            <asp:Button ID="btnSaveSettings" runat="server" OnClick="btnSaveSettings_Click" Text="Save" />
            <asp:Button ID="btnCancelSettings" runat="server" OnClick="btnCancelSettings_Click" Text="Cancel" />
            <br />
            
            
        </asp:Panel>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    </form>
</body>
</html>
