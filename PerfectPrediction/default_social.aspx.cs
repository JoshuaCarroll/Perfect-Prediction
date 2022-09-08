using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PerfectPrediction
{
    public partial class default_social : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
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

            string sql = @"SELECT Games.HomeTeamID [HomeTeamID], Games.AwayTeamID [AwayTeamID], Games.GameTime [GameTime], Games.TenantID [TenantID],
	HomeTeam.Name [HomeTeamName], AwayTeam.Name [AwayTeamName], Tenants.SponsorUrl
FROM Games
INNER JOIN Teams [HomeTeam] on Games.HomeTeamID = HomeTeam.ID
INNER JOIN Teams [AwayTeam] on Games.AwayTeamID = AwayTeam.ID
INNER JOIN Tenants on Games.TenantID = Tenants.ID
Where Games.ID = @id";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@id", intGameId);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                try
                {
                    reader.Read();
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

                    ImageUtility.loadSponsorImage(reader["TenantID"].ToString(), imgSponsor);

                    lblHome.Text = reader["HomeTeamName"].ToString();
                    lblAway.Text = reader["AwayTeamName"].ToString();

                    lblGameStartDate.Text = DateTime.Parse(reader["GameTime"].ToString()).ToString("MMMM dd, yyyy h:mm tt");
                }
                finally
                {
                    // Always call Close when done reading.
                    reader.Close();
                }
            }
        }
    }
}