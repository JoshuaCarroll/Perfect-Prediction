<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default_social.aspx.cs" Inherits="PerfectPrediction.default_social" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PERFECT PREDICTION: Predict the score and win!</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"/>
    <style type="text/css">
      @import url("https://fonts.googleapis.com/css2?family=Open+Sans:wght@800&family=Press+Start+2P&display=swap");

        :root {
            --color1: #113160;
            --color2: #ffffff;
            --color3: #cc0106;
            --team-image-height: 400px;
            --team-spacer-size: 200px;
            --sponsor-logo-height: 180px;
            --sponsor-margin: 70px;
        }

        * {
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--color1);
            color: var(--color2);
            font-family: "Arial";
            text-align: center;
            margin-top: 40px;
        }

        .perfect, .line1 {
            font-size: 62px;
            font-family: "Press Start 2P";
            color: var(--color1);
            width: fit-content;
            margin-left: auto;
            margin-right: auto;
            display: inline-block;
        }

            .perfect, .line1 span {
                background-color: var(--color2);
                padding: 5px;
            }

                .perfect, .line1 span:nth-of-type(n + 1) {
                    margin-right: 5px;
                }

        .prediction, .line2 {
            font-size: 80px;
            font-family: "Open Sans";
            display: inline-block;
        }

        .description, .line3 {
            background-color: var(--color3);
            width: fit-content;
            margin-left: auto;
            margin-right: auto;
            padding: 5px;
            font-size: 30px;
        }

        .sponsoredBy {
            display: block;
            margin-top: var(--sponsor-margin);
        }

        .sponsorLogo {
            margin-left: auto;
            margin-right: auto;
        }

            .sponsorLogo img {
                height: var(--sponsor-logo-height);
                margin-bottom: var(--sponsor-margin);
            }

        .teams {
            margin: 0px;
            position: absolute;
            top: 250px;
            width: 100%;
        }

            .teams svg {
                height: var(--team-image-height);
                display: none;
            }

            .teams img {
                max-height: var(--team-image-height);
            }

            .divHome, .divAway {
                width: 30%;

            }
            .divAway {
                float: left;
            }
            .divHome {
                float: right;
            }

        .details {
            font-size: 40px;
            line-height: 28px
        }
            .details #entryWindow {
                font-size: 0.6em;
                opacity: 0.7;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="contents">
		    <div class="line1">
				<span>P</span><span>E</span><span>R</span><span>F</span><span>E</span><span>C</span><span>T</span>
			</div>
			<div class="line2">PREDICTION</div>
			<div class="line3">PREDICT THE FINAL SCORE CORRECTLY & WIN!</div>
			<div class="sponsorLogo">
                <span class="sponsoredBy">Sponsored by</span>
                <asp:Image ID="imgSponsor" runat="server" />
			</div>

			<div class="teams">
				<div class="divHome"><asp:Label ID="lblHome" runat="server"></asp:Label><asp:Image ID="imgHome" runat="server" /></div><div class="versus"><svg xmlns='http://www.w3.org/2000/svg' version='1.1' height='150px' width='35px'><text x='5' y='85' fill='white' opacity="0.5" font-size='20'>VS</text></svg></div><div class="divAway"><asp:Image ID="imgAway" runat="server" /><asp:Label ID="lblAway" runat="server"></asp:Label></div>
            </div>
            <div class="details">
                <asp:Label ID="lblGameStartDate" runat="server" Text="1/1/1111 1:00 PM"></asp:Label>
                <br />
                <span id="entryWindow">Entries accepted until 30 minutes after the game starts</span>
			</div>
	
        </div>
    </form>
</body>
</html>
