<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="PerfectPrediction._default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link type="text/css" rel="stylesheet" href="StyleSheet.css" />
</head>
<body>
    <form id="form1" runat="server">
		<div id="contents">
			<div class="teams">
				<asp:Label ID="lblHome" runat="server"></asp:Label>
				<asp:Image ID="imgHome" runat="server" />&nbsp;vs.&nbsp;<asp:Image ID="imgAway" runat="server" />
                <asp:Label ID="lblAway" runat="server"></asp:Label>
                <br />
                <asp:Label ID="lblGameStartDate" runat="server" Text="1/1/1111 1:00 PM"></asp:Label>
            </div>
			<div class="line1">
				<span>P</span><span>E</span><span>R</span><span>F</span><span>E</span><span>C</span><span>T</span>
			</div>
			<div class="line2">PREDICTION</div>
			<div class="line3">PREDICT THE FINAL SCORE 
                <br />
                CORRECTLY & WIN!</div>
			<div class="sponsorLogo"><img src="https://walk-ons.com/assets/img/walkons-logo.svg" /></div>
			<div class="form">
				<asp:Label ID="Label1" runat="server" Text="Name"></asp:Label>
                : 
                <asp:TextBox ID="txtName" runat="server" AutoCompleteType="DisplayName"></asp:TextBox>
                <ajaxToolkit:TextBoxWatermarkExtender ID="txtName_TextBoxWatermarkExtender" runat="server" BehaviorID="txtName_TextBoxWatermarkExtender" TargetControlID="txtName" WatermarkText="name" />
                <br/>
				<asp:Label ID="Label2" runat="server" Text="Email"></asp:Label>
                :&nbsp;
                <asp:TextBox ID="txtEmail" runat="server" AutoCompleteType="Email"></asp:TextBox>
                <ajaxToolkit:TextBoxWatermarkExtender ID="txtEmail_TextBoxWatermarkExtender" runat="server" BehaviorID="txtEmail_TextBoxWatermarkExtender" TargetControlID="txtEmail" WatermarkText="email" />
                <br/>
				<div class="prediction">
					<asp:Label ID="lblHome2" runat="server" Text="Home"></asp:Label>
                    : 
                    <asp:TextBox ID="txtHomeScore" inputmode="numeric" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                    <br/>
					<asp:Label ID="lblAway2" runat="server" Text="Away"></asp:Label>
                    :&nbsp;
                    <asp:TextBox ID="txtAwayScore" inputmode="numeric" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
				</div>
				<input type="checkbox" id="chkTerms"/><label for="chkTerms">I agree to the <asp:HyperLink ID="linkTerms" runat="server">terms and conditions</asp:HyperLink><br/>
				<button>SUBMIT</button>
			</div>
		</div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    </form>
</body>
</html>
