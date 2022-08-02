using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Diagnostics;

namespace PerfectPrediction
{
    public partial class dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["TenantID"] == null)
            {
                Response.Redirect("default.aspx");
            }
        }

        protected void gridViewGames_SelectedIndexChanged(object sender, EventArgs e)
        {
            gridViewGames.Visible = false;
            pnlEditGame.Visible = true;

            int GameID = int.Parse(gridViewGames.SelectedDataKey.Value.ToString());

            hdnGameId.Value = GameID.ToString();

            string queryString = @"SELECT Games.ID, HomeTeamID, HomeTeam.Name, AwayTeamID, AwayTeam.Name, GameTime, HomeTeamScore, AwayTeamScore, Predictions.Name [Winner], Predictions.Email [WinnerEmail]
FROM Games 
INNER JOIN Teams [AwayTeam] on AwayTeamID = AwayTeam.ID 
INNER JOIN Teams [HomeTeam] on HomeTeamID = HomeTeam.ID
LEFT JOIN Predictions on Games.WinningPredictionID = Predictions.ID
WHERE Games.ID = @id";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@id", GameID);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                try
                {
                    reader.Read();
                    cbAwayTeam.SelectedValue = reader["AwayTeamID"].ToString();
                    cbHomeTeam.SelectedValue = reader["HomeTeamID"].ToString();
                    txtGametime.Text = reader["GameTime"].ToString();
                    txtAwayScore.Text = reader["AwayTeamScore"].ToString();
                    txtHomeScore.Text = reader["HomeTeamScore"].ToString();

                    if ((reader["Winner"] != null) && (reader["Winner"].ToString() != ""))
                    {
                        txtWinner.Text = String.Format("{0} ({1})", reader["Winner"].ToString(), reader["WinnerEmail"].ToString());
                    }
                    else
                    {
                        txtWinner.Text = "";

                        if (txtAwayScore.Text == "" || txtHomeScore.Text == "")
                        {
                            lblWinner.Visible = false;
                            txtWinner.Visible = false;
                        }
                    }
                }
                finally
                {
                    // Always call Close when done reading.
                    reader.Close();
                }
            }
        }

        protected void gridViewGames_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "New")
            {
                cbAwayTeam.SelectedIndex = -1;
                cbHomeTeam.SelectedIndex = -1;
                txtGametime.Text = "";
                txtAwayScore.Text = "";
                txtHomeScore.Text = "";
                hdnGameId.Value = "0";

                gridViewGames.Visible = false;
                pnlEditGame.Visible = true;
            }
        }

        protected void btnGameCancel_Click(object sender, EventArgs e)
        {
            pnlEditGame.Visible = false;
            gridViewGames.Visible = true;
        }

        protected void btnGameSave_Click(object sender, EventArgs e)
        {
            int homeTeamID;
            if (!int.TryParse(cbHomeTeam.SelectedValue, out homeTeamID))
            {
                // This was a new addition. Save it.
                homeTeamID = insertTeam(cbHomeTeam.SelectedItem.Text);
            }

            int awayTeamID;
            if (!int.TryParse(cbAwayTeam.SelectedValue, out awayTeamID))
            {
                // This was a new addition. Save it.
                awayTeamID = insertTeam(cbAwayTeam.SelectedItem.Text);
            }

            string queryString = @"exec SaveGame @HomeTeamID, @AwayTeamID, @GameTime, @HomeTeamScore, @AwayTeamScore, @GameID, @TenantID";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);

                command.Parameters.AddWithValue("@HomeTeamID", homeTeamID);
                command.Parameters.AddWithValue("@AwayTeamID", awayTeamID);
                command.Parameters.AddWithValue("@GameTime", txtGametime.Text);
                command.Parameters.AddWithValue("@HomeTeamScore", txtHomeScore.Text);
                command.Parameters.AddWithValue("@AwayTeamScore", txtAwayScore.Text);
                command.Parameters.AddWithValue("@GameID", hdnGameId.Value);
                command.Parameters.AddWithValue("@TenantID", Session["TenantID"].ToString());
                connection.Open();

                command.ExecuteNonQuery();
            }

            Response.Redirect("dashboard.aspx");
        }

        protected void comboboxTeam_ItemInserting(object sender, AjaxControlToolkit.ComboBoxItemInsertEventArgs e)
        {
            AjaxControlToolkit.ComboBox cbSender = (AjaxControlToolkit.ComboBox)sender;
            string teamName = e.Item.Text;
            int newRecordID = insertTeam(teamName);

            cbSender.Items.Add(new ListItem(teamName, newRecordID.ToString()));
            cbSender.SelectedValue = newRecordID.ToString();
        }

        protected int insertTeam(string teamName)
        {
            int newRecordID;
            string queryString = @"exec AddTeam @TeamName, @TenantID";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@TeamName", teamName);
                command.Parameters.AddWithValue("@TenantID", Session["TenantID"].ToString());
                connection.Open();
                newRecordID = int.Parse(command.ExecuteScalar().ToString());
            }

            return newRecordID;
        }
    }
}