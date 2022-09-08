<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="PerfectPrediction._default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta property="og:image" content="" runat="server" id="metaImage" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://perfectprediction.aa5jc.com/"  runat="server" id="metaUrl" />
    <meta property="og:title" content="Perfect Prediction" runat="server" id="metaTitle" />
    <meta property="og:description" content="Predict the final score correctly and win!" />

    <title>PERFECT PREDICTION: Predict the score and win!</title>
    <link type="text/css" rel="stylesheet" href="StyleSheet.css" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"/>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hfDatetime" runat="server" />
        <div id="contents">
		    <div class="line1">
				<span>P</span><span>E</span><span>R</span><span>F</span><span>E</span><span>C</span><span>T</span>
			</div>
			<div class="line2">PREDICTION</div>
			<div class="line3">PREDICT THE FINAL SCORE CORRECTLY & WIN!</div>
			<div class="sponsorLogo">
                <asp:HyperLink ID="linkSponsor" runat="server"><asp:Image ID="imgSponsor" runat="server" /></asp:HyperLink></div>

			<div class="teams">
				<asp:Label ID="lblHome" runat="server"></asp:Label><asp:Image ID="imgHome" runat="server" /><svg xmlns='http://www.w3.org/2000/svg' version='1.1' height='150px' width='35px'><text x='5' y='85' fill='white' opacity="0.5" font-size='20'>VS</text></svg><asp:Image ID="imgAway" runat="server" /><asp:Label ID="lblAway" runat="server"></asp:Label>
            </div>
            <div class="details">
                <asp:Label ID="lblGameStartDate" runat="server" Text="1/1/1111 1:00 PM"></asp:Label>
                <br />
                <span id="entryWindow">Entries accepted until 30 minutes after the game starts</span>
			</div>
	
            <asp:Panel ID="pnlForm" runat="server">
			    <div class="form">
				    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ForeColor="Red" />
				    <asp:Label ID="Label1" runat="server" Text="Name" CssClass="label"></asp:Label><asp:TextBox ID="txtName" runat="server" AutoCompleteType="DisplayName"></asp:TextBox><ajaxToolkit:TextBoxWatermarkExtender ID="txtName_TextBoxWatermarkExtender" runat="server" BehaviorID="txtName_TextBoxWatermarkExtender" TargetControlID="txtName" WatermarkCssClass="watermark" WatermarkText="first last" /><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtName" ErrorMessage="Name is required" ForeColor="Red" Display="Dynamic">*</asp:RequiredFieldValidator><asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="You can only submit predictions up until 30 minutes after the game time." ForeColor="Red" OnServerValidate="CustomValidator2_ServerValidate" Display="Dynamic">*</asp:CustomValidator>
                    <br/>
				    <asp:Label ID="Label2" runat="server" Text="Email" CssClass="label"></asp:Label><asp:TextBox ID="txtEmail" runat="server" AutoCompleteType="Email"></asp:TextBox>
                    <ajaxToolkit:TextBoxWatermarkExtender ID="txtEmail_TextBoxWatermarkExtender" runat="server" BehaviorID="txtEmail_TextBoxWatermarkExtender" TargetControlID="txtEmail" WatermarkCssClass="watermark" WatermarkText="me@email.com" />
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is not valid" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic">*</asp:RegularExpressionValidator><asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic">*</asp:RequiredFieldValidator>
                    <br/>
				    <div class="prediction">
					    <asp:Label ID="lblHome2" runat="server" Text="Home" CssClass="label"></asp:Label><asp:TextBox ID="txtHomeScore" inputmode="numeric" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                        <ajaxToolkit:TextBoxWatermarkExtender ID="txtHomeScore_TextBoxWatermarkExtender" runat="server" BehaviorID="txtHomeScore_TextBoxWatermarkExtender" TargetControlID="txtHomeScore" WatermarkCssClass="watermark" WatermarkText="#" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtHomeScore" ErrorMessage="Home score is required" ForeColor="Red" Display="Dynamic">*</asp:RequiredFieldValidator>
                        <br/>
                        <asp:Label ID="lblAway2" runat="server" CssClass="label" Text="Away"></asp:Label><asp:TextBox ID="txtAwayScore" runat="server" AutoCompleteType="Disabled" inputmode="numeric"></asp:TextBox>
                        <ajaxToolkit:TextBoxWatermarkExtender ID="txtAwayScore_TextBoxWatermarkExtender" runat="server" BehaviorID="txtAwayScore_TextBoxWatermarkExtender" TargetControlID="txtAwayScore" WatermarkCssClass="watermark" WatermarkText="#" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtAwayScore" ErrorMessage="Away score is required" ForeColor="Red" Display="Dynamic">*</asp:RequiredFieldValidator>
				    </div>
                    <div class="disclaimer">Submitting means you agree with the <asp:HyperLink ID="linkTerms" runat="server">terms and conditions</asp:HyperLink>.</div>
                    <asp:Button ID="btnSubmit" runat="server" Text="SUBMIT" OnClick="btnSubmit_Click" />
			    </div>
		    
                <asp:ScriptManager ID="ScriptManager1" runat="server">
                </asp:ScriptManager>
            </asp:Panel>
            <asp:Panel ID="pnlThanks" runat="server" Visible="False">
                GOOD LUCK!!<br />
                <br />
                Your submission has been recorded.</asp:Panel>
        </div>
    </form>
</body>
</html>
