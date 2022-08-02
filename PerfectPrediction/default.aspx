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
				<img src="https://www.mrapats.org/uploaded/themes/default_16/images/athletics-mra-logo-2x.png" />
			</div>
			<div class="line1">
				<span>P</span><span>E</span><span>R</span><span>F</span><span>E</span><span>C</span><span>T</span>
			</div>
			<div class="line2">PREDICTION</div>
			<div class="line3">PREDICT CORRECTLY & WIN!</div>
			<div class="sponsorLogo"><img src="https://walk-ons.com/assets/img/walkons-logo.svg" /></div>
			<div class="form">
				Name: 
                <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
                <ajaxToolkit:TextBoxWatermarkExtender ID="txtName_TextBoxWatermarkExtender" runat="server" BehaviorID="txtName_TextBoxWatermarkExtender" TargetControlID="txtName" />
                <br/>
				Email:&nbsp;
                <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                <ajaxToolkit:TextBoxWatermarkExtender ID="txtEmail_TextBoxWatermarkExtender" runat="server" BehaviorID="txtEmail_TextBoxWatermarkExtender" TargetControlID="txtEmail" />
                <br/>
				<div class="prediction">
					Home: 
                    <asp:TextBox ID="txtHomeScore" runat="server"></asp:TextBox>
                    <br/>
					Away:&nbsp;
                    <asp:TextBox ID="txtAwayScore" runat="server"></asp:TextBox>
				</div>
				<input type="checkbox" id="chkTerms"/><label for="chkTerms">I agree to the rules and conditions</label><br/>
				<button>SUBMIT</button>
			</div>
		</div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    </form>
</body>
</html>
