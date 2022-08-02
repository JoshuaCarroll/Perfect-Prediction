<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="PerfectPrediction.dashboard" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        label, .label { 
            width: 200px; 
            text-align: right;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:GridView ID="gridViewGames" runat="server" AutoGenerateColumns="False" CellPadding="4" DataSourceID="sqlDataSourceGames" ForeColor="#333333" GridLines="None" Width="1310px" OnSelectedIndexChanged="gridViewGames_SelectedIndexChanged" BorderColor="#003366" BorderStyle="Solid" DataKeyNames="ID" OnRowCommand="gridViewGames_RowCommand">
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <Columns>
                <asp:CommandField SelectText="Edit" ShowSelectButton="True"></asp:CommandField>
                <asp:BoundField DataField="ID" HeaderText="ID" ReadOnly="True" SortExpression="ID" Visible="False" InsertVisible="False" />
                <asp:BoundField DataField="AwayTeam" HeaderText="Away" SortExpression="AwayTeam" >
                    <HeaderStyle HorizontalAlign="Left" />
                </asp:BoundField>
                <asp:BoundField DataField="HomeTeam" HeaderText="Home" SortExpression="HomeTeam" >
                    <HeaderStyle HorizontalAlign="Left" />
                </asp:BoundField>
                <asp:BoundField DataField="GameTime" HeaderText="Date/Time" SortExpression="GameTime" >
                    <HeaderStyle HorizontalAlign="Left" />
                </asp:BoundField>
                <asp:BoundField DataField="Name" HeaderText="Winner" SortExpression="Name">
                    <HeaderStyle HorizontalAlign="Left" />
                </asp:BoundField>
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
        <asp:SqlDataSource ID="sqlDataSourceGames" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" DeleteCommand="DELETE FROM [Games] WHERE [Id] = @original_Id AND [HomeTeamID] = @original_HomeTeamID AND [AwayTeamID] = @original_AwayTeamID AND [GameTime] = @original_GameTime AND [TenantID] = @original_TenantID AND (([WinningPredictionID] = @original_WinningPredictionID) OR ([WinningPredictionID] IS NULL AND @original_WinningPredictionID IS NULL))" InsertCommand="INSERT INTO [Games] ([Id], [HomeTeamID], [AwayTeamID], [GameTime], [TenantID], [WinningPredictionID]) VALUES (@Id, @HomeTeamID, @AwayTeamID, @GameTime, @TenantID, @WinningPredictionID)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT Games.ID, TeamsAway.Name [AwayTeam], TeamsHome.Name [HomeTeam], GameTime, Predictions.Name FROM [Games] 
INNER JOIN Teams [TeamsAway] on TeamsAway.Id = Games.AwayTeamID 
INNER JOIN Teams [TeamsHome] on TeamsHome.Id = Games.HomeTeamID
LEFT JOIN Predictions on Predictions.Id = Games.WinningPredictionID 
WHERE (Games.TenantID = @TenantID) 
ORDER BY [GameTime]" UpdateCommand="UPDATE [Games] SET [HomeTeamID] = @HomeTeamID, [AwayTeamID] = @AwayTeamID, [GameTime] = @GameTime, [TenantID] = @TenantID, [WinningPredictionID] = @WinningPredictionID WHERE [Id] = @original_Id AND [HomeTeamID] = @original_HomeTeamID AND [AwayTeamID] = @original_AwayTeamID AND [GameTime] = @original_GameTime AND [TenantID] = @original_TenantID AND (([WinningPredictionID] = @original_WinningPredictionID) OR ([WinningPredictionID] IS NULL AND @original_WinningPredictionID IS NULL))">
            <DeleteParameters>
                <asp:Parameter Name="original_Id" Type="Int32" />
                <asp:Parameter Name="original_HomeTeamID" Type="Int32" />
                <asp:Parameter Name="original_AwayTeamID" Type="Int32" />
                <asp:Parameter Name="original_GameTime" Type="DateTime" />
                <asp:Parameter Name="original_TenantID" Type="Int32" />
                <asp:Parameter Name="original_WinningPredictionID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="Id" Type="Int32" />
                <asp:Parameter Name="HomeTeamID" Type="Int32" />
                <asp:Parameter Name="AwayTeamID" Type="Int32" />
                <asp:Parameter Name="GameTime" Type="DateTime" />
                <asp:Parameter Name="TenantID" Type="Int32" />
                <asp:Parameter Name="WinningPredictionID" Type="Int32" />
            </InsertParameters>
            <SelectParameters>
                <asp:SessionParameter DefaultValue="1" Name="TenantID" SessionField="TenantID" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="HomeTeamID" Type="Int32" />
                <asp:Parameter Name="AwayTeamID" Type="Int32" />
                <asp:Parameter Name="GameTime" Type="DateTime" />
                <asp:Parameter Name="TenantID" Type="Int32" />
                <asp:Parameter Name="WinningPredictionID" Type="Int32" />
                <asp:Parameter Name="original_Id" Type="Int32" />
                <asp:Parameter Name="original_HomeTeamID" Type="Int32" />
                <asp:Parameter Name="original_AwayTeamID" Type="Int32" />
                <asp:Parameter Name="original_GameTime" Type="DateTime" />
                <asp:Parameter Name="original_TenantID" Type="Int32" />
                <asp:Parameter Name="original_WinningPredictionID" Type="Int32" />
            </UpdateParameters>
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
            <asp:Label CssClass="label" ID="Label1" runat="server" Text="Game date/time"></asp:Label>
            <asp:TextBox ID="txtGametime" runat="server"></asp:TextBox>
            <br />
            <asp:Label CssClass="label" ID="Label2" runat="server" Text="Home team"></asp:Label>
            <ajaxToolkit:ComboBox ID="cbHomeTeam" runat="server" DataSourceID="sqlDataSourceTeams" DataTextField="Name" DataValueField="Id" MaxLength="0" OnItemInserting="comboboxTeam_ItemInserting" style="display: inline;">
            </ajaxToolkit:ComboBox>
            <br />
            <asp:Label CssClass="label" ID="Label3" runat="server" Text="Away team"></asp:Label>
            <ajaxToolkit:ComboBox ID="cbAwayTeam" runat="server" DataSourceID="sqlDataSourceTeams" DataTextField="Name" DataValueField="Id" MaxLength="0" style="display: inline;" OnItemInserting="comboboxTeam_ItemInserting">
            </ajaxToolkit:ComboBox>
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
        </asp:Panel>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    </form>
</body>
</html>
