using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

namespace PerfectPrediction
{
    public partial class _default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            hfDatetime.Value = getCentralTime().ToString();

            object gameId = Request.QueryString["g"];
            object tenantId = Request.QueryString["t"];
            int intId = 0;

            string sqlGame = @"SELECT Games.ID [GameID], Games.HomeTeamID [HomeTeamID], Games.AwayTeamID [AwayTeamID], Games.GameTime [GameTime], Games.TenantID [TenantID],
	HomeTeam.Name [HomeTeamName], AwayTeam.Name [AwayTeamName], Tenants.SponsorUrl
FROM Games
INNER JOIN Teams [HomeTeam] on Games.HomeTeamID = HomeTeam.ID
INNER JOIN Teams [AwayTeam] on Games.AwayTeamID = AwayTeam.ID
INNER JOIN Tenants on Games.TenantID = Tenants.ID
Where Games.ID = @id";

            string sqlTenant = @"SELECT Top 1 Games.ID [GameID], Games.HomeTeamID [HomeTeamID], Games.AwayTeamID [AwayTeamID], Games.GameTime [GameTime], Games.TenantID [TenantID],
	HomeTeam.Name [HomeTeamName], AwayTeam.Name [AwayTeamName], Tenants.SponsorUrl
FROM Games
INNER JOIN Teams [HomeTeam] on Games.HomeTeamID = HomeTeam.ID
INNER JOIN Teams [AwayTeam] on Games.AwayTeamID = AwayTeam.ID
INNER JOIN Tenants on Games.TenantID = Tenants.ID
Where Games.TenantID = @id AND Games.GameTime > GETDATE() 
ORDER by Games.GameTime Asc";

            string sql = "";

            if (gameId == null)
            {
                if (tenantId == null)
                {
                    intId = 1;
                    sql = sqlGame;
                }
                else
                {
                    int.TryParse(tenantId.ToString(), out intId);
                    sql = sqlTenant;
                }
            }
            else
            {
                int.TryParse(gameId.ToString(), out intId);
                sql = sqlGame;
            }

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@id", intId);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                try
                {
                    reader.Read();

                    // To create a random seed for anticaching on Facebook
                    Random random = new Random();

                    metaImage.Content = "https://perfectprediction.aa5jc.com/GetImage.ashx?g=" + reader["GameID"] + "&s=" + random.Next(99999);
                    metaTitle.Content = String.Format("PERFECT PREDICTION: {0} vs {1}", reader["AwayTeamName"].ToString(), reader["HomeTeamName"].ToString());
                    metaUrl.Content = "https://perfectprediction.aa5jc.com/?g=" + reader["GameID"];

                    string AwayTeamID = reader["AwayTeamID"].ToString();
                    string HomeTeamID = reader["HomeTeamID"].ToString();

                    if (ImageUtility.loadTeamImage(AwayTeamID, imgAway))
                    {
                        lblAway.Visible = false;
                    }
                    if (ImageUtility.loadTeamImage(HomeTeamID, imgHome))
                    {
                        lblHome.Visible = false;
                    }

                    string sponsorUrl = reader["SponsorUrl"].ToString();
                    if (sponsorUrl != null && sponsorUrl != string.Empty)
                    {
                        linkSponsor.Target = "_blank";
                        if (!sponsorUrl.Contains("://"))
                        {
                            sponsorUrl = "http://" + sponsorUrl;
                        }
                        linkSponsor.NavigateUrl = sponsorUrl;
                    }

                    ImageUtility.loadSponsorImage(reader["TenantID"].ToString(), imgSponsor);

                    lblHome.Text = reader["HomeTeamName"].ToString();
                    lblHome2.Text = lblHome.Text;
                    lblAway.Text = reader["AwayTeamName"].ToString();
                    lblAway2.Text = lblAway.Text;

                    DateTime gameTime = DateTime.Parse(reader["GameTime"].ToString());
                    lblGameStartDate.Text = gameTime.ToString("MMMM dd, yyyy h:mm tt");

                    linkTerms.Target = "_blank";
                    linkTerms.NavigateUrl = "terms.aspx?t=" + reader["TenantID"].ToString();


                    DateTime currentCstTime = getCentralTime();

                    if (gameTime.AddMinutes(30) < currentCstTime)
                    {
                        btnSubmit.Enabled = false;
                        btnSubmit.Text = "ENTRIES ARE CLOSED";
                    }
                }
                finally
                {
                    // Always call Close when done reading.
                    reader.Close();
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            object gameId = Request.QueryString["g"];
            int intGameId = 0;

            if (gameId == null)
            {
                intGameId = 1;
            }
            else
            {
                int.TryParse(gameId.ToString(), out intGameId);
            }

            string queryString = @"exec AddPrediction @GameID, @Name, @Email, @HomeScore, @AwayScore";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);

                command.Parameters.AddWithValue("@GameID", intGameId);
                command.Parameters.AddWithValue("@Name", txtName.Text);
                command.Parameters.AddWithValue("@Email", txtEmail.Text);
                command.Parameters.AddWithValue("@HomeScore", txtHomeScore.Text);
                command.Parameters.AddWithValue("@AwayScore", txtAwayScore.Text);
                connection.Open();

                command.ExecuteNonQuery();
            }

            pnlForm.Visible = false;
            pnlThanks.Visible = true;
        }

        protected void CustomValidator2_ServerValidate(object source, ServerValidateEventArgs args)
        {
            object gameId = Request.QueryString["g"];
            int intGameId = 0;

            if (gameId == null)
            {
                intGameId = 1;
            }
            else
            {
                int.TryParse(gameId.ToString(), out intGameId);
            }

            string sql = @"SELECT GameTime FROM Games Where Games.ID = @id";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                try
                {
                    SqlCommand command = new SqlCommand(sql, connection);
                    command.Parameters.AddWithValue("@id", intGameId);
                    connection.Open();

                    DateTime gameTime = (DateTime)command.ExecuteScalar();
                    DateTime cstTime = getCentralTime();

                    args.IsValid = (gameTime.AddMinutes(30) < cstTime);
                }
                finally
                {
                    // Nothing to close.
                }
            }
        }

        protected DateTime getCentralTime()
        {
            DateTime timeUtc = DateTime.UtcNow;
            TimeZoneInfo cstZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time");
            DateTime cstTime = TimeZoneInfo.ConvertTimeFromUtc(timeUtc, cstZone);
            return cstTime;
        }
    }
}