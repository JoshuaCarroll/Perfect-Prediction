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
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
        {
            bool authenticated = false;

            string queryString = "Select ID from Tenants where Username = @username and Password = @Password";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@username", Login1.UserName);
                command.Parameters.AddWithValue("@password", Login1.Password); // TODO: Encrypt this
                connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                try
                {
                    if (reader.HasRows)
                    {
                        reader.Read();
                        string tenantID = reader["ID"].ToString();
                        Session["TenantID"] = tenantID;
                        authenticated = true;
                    }
                }
                finally
                {
                    // Always call Close when done reading.
                    reader.Close();
                }
            }
            e.Authenticated = authenticated;
        }
    }
}