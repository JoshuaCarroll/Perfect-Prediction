using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Diagnostics;
using System.IO;

namespace PerfectPrediction
{
    public partial class dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["TenantID"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        protected void gridViewGames_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gridViewGames.SelectedIndex != -1)
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
                        string AwayTeamID = reader["AwayTeamID"].ToString();
                        string HomeTeamID = reader["HomeTeamID"].ToString();
                        cbAwayTeam.SelectedValue = reader["AwayTeamID"].ToString();
                        cbHomeTeam.SelectedValue = reader["HomeTeamID"].ToString();

                        try
                        {
                            DateTime dtGame = DateTime.Parse(reader["GameTime"].ToString());
                            txtGameDate.Text = dtGame.ToShortDateString();

                            if (dtGame.Hour > 12)
                            {
                                ddlGameTimeHour.SelectedValue = (dtGame.Hour - 12).ToString();
                                ddlGameTimeAP.SelectedValue = "PM";
                            }
                            else
                            {
                                if (dtGame.Hour == 0)
                                {
                                    ddlGameTimeHour.SelectedValue = "12";
                                }
                                else
                                {
                                    ddlGameTimeHour.SelectedValue = dtGame.Hour.ToString();
                                }

                                ddlGameTimeAP.SelectedValue = "AM";
                            }

                            try
                            {
                                ddlGameTimeMinute.SelectedValue = dtGame.Minute.ToString();
                            }
                            catch
                            {
                                ddlGameTimeMinute.SelectedValue = "00";
                            }
                        }
                        catch
                        {
                            txtGameDate.Text = "";
                            ddlGameTimeHour.SelectedValue = "7";
                            ddlGameTimeMinute.SelectedValue = "00";
                            ddlGameTimeAP.SelectedValue = "PM";
                        }
                        txtAwayScore.Text = reader["AwayTeamScore"].ToString();
                        txtHomeScore.Text = reader["HomeTeamScore"].ToString();

                        ImageUtility.loadTeamImage(AwayTeamID, imgAwayTeam);
                        ImageUtility.loadTeamImage(HomeTeamID, imgHomeTeam);

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

                queryString = @"Select Count(ID) from Predictions where GameID = @id";

                using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
                {
                    SqlCommand command = new SqlCommand(queryString, connection);
                    command.Parameters.AddWithValue("@id", GameID);
                    connection.Open();

                    int entryCount = (int)command.ExecuteScalar();
                    lblEntries.Text = entryCount.ToString() + " Entries";
                }
            }
        }

        protected void btnGameCancel_Click(object sender, EventArgs e)
        {
            pnlEditGame.Visible = false;
            gridViewGames.Visible = true;
            gridViewGames.SelectedIndex = -1;
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

                DateTime dtGame = DateTime.Parse(txtGameDate.Text);
                int hour = int.Parse(ddlGameTimeHour.Text);
                if (ddlGameTimeAP.Text == "PM")
                {
                    hour = hour + 12;
                }
                TimeSpan tsGame = new TimeSpan(hour, int.Parse(ddlGameTimeMinute.Text), 0);
                dtGame = dtGame.Add(tsGame);

                command.Parameters.AddWithValue("@GameTime", dtGame);
                command.Parameters.AddWithValue("@HomeTeamScore", txtHomeScore.Text);
                command.Parameters.AddWithValue("@AwayTeamScore", txtAwayScore.Text);
                command.Parameters.AddWithValue("@GameID", hdnGameId.Value);
                command.Parameters.AddWithValue("@TenantID", Session["TenantID"].ToString());
                connection.Open();

                command.ExecuteNonQuery();
            }

            // See if they have provided new images we need to store
            ImageUtility.StoreNewImage(FileUploadAwayTeam, awayTeamID);
            ImageUtility.StoreNewImage(FileUploadHomeTeam, homeTeamID);

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

        protected void linkLogout_Click(object sender, EventArgs e)
        {
            Session["TenantID"] = null;
            Response.Redirect("login.aspx");
        }

        protected void linkNewGame_Click(object sender, EventArgs e)
        {
            cbAwayTeam.SelectedIndex = -1;
            cbHomeTeam.SelectedIndex = -1;
            txtGameDate.Text = "";
            ddlGameTimeHour.SelectedValue = "7";
            ddlGameTimeMinute.SelectedValue = "00";
            ddlGameTimeAP.SelectedValue = "PM";
            txtAwayScore.Text = "";
            txtHomeScore.Text = "";
            hdnGameId.Value = "0";

            gridViewGames.Visible = false;
            pnlEditGame.Visible = true;
        }

        protected void linkSettings_Click(object sender, EventArgs e)
        {
            if (Session["TenantID"] == null)
            {
                Response.Redirect("login.aspx");
            }
            string strTenantId = Session["TenantID"].ToString();

            gridViewGames.Visible = false;
            pnlSettings.Visible = true;

            // Load current values
            string queryString = @"SELECT Username, Password, Name, Email from Tenants where ID = @Id";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@id", strTenantId);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                try
                {
                    reader.Read();
                    txtUsername.Text = reader["Username"].ToString();
                    txtPassword.Text = reader["Password"].ToString();
                    txtName.Text = reader["Name"].ToString();
                    txtEmail.Text = reader["Email"].ToString();

                    ImageUtility.loadSponsorImage(strTenantId, imgSponsor);
                }
                finally
                {
                    // Always call Close when done reading.
                    reader.Close();
                }
            }
        }

        protected void btnCancelSettings_Click(object sender, EventArgs e)
        {
            gridViewGames.Visible = true;
            pnlSettings.Visible = false;
        }

        protected void btnSaveSettings_Click(object sender, EventArgs e)
        {
            if (Session["TenantID"] == null)
            {
                Response.Redirect("login.aspx");
            }
            string strTenantId = Session["TenantID"].ToString();

            string queryString = @"Update Tenants set Password = @password, Name = @name, Email = @email where ID = @id";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);

                command.Parameters.AddWithValue("@password", txtPassword.Text);
                command.Parameters.AddWithValue("@name", txtName.Text);
                command.Parameters.AddWithValue("@email", txtEmail.Text);
                command.Parameters.AddWithValue("@id", Session["TenantID"].ToString());
                connection.Open();

                command.ExecuteNonQuery();
            }

            // See if they have provided new images we need to store
            ImageUtility.StoreNewSponsorImage(FileUploadSponsor, strTenantId);

            Response.Redirect("dashboard.aspx");
        }
    }
}