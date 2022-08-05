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

            string sql = @"SELECT Games.HomeTeamID [HomeTeamID], Games.AwayTeamID [AwayTeamID],  Games.GameTime [GameTime], Games.TenantID [TenantID],
	HomeTeam.Name [HomeTeamName], AwayTeam.Name [AwayTeamName]
FROM Games
INNER JOIN Teams [HomeTeam] on Games.HomeTeamID = HomeTeam.ID
INNER JOIN Teams [AwayTeam] on Games.AwayTeamID = AwayTeam.ID
Where Games.ID = 1";

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

                    lblHome.Text = reader["HomeTeamName"].ToString();
                    lblHome2.Text = lblHome.Text;
                    lblAway.Text = reader["AwayTeamName"].ToString();
                    lblAway2.Text = lblAway.Text;

                    lblGameStartDate.Text = reader["GameTime"].ToString();

                    linkTerms.Target = "_blank";
                    linkTerms.NavigateUrl = "terms.aspx?t=" + reader["TenantID"].ToString();
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