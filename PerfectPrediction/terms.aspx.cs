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
    public partial class terms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            object tenantId = Request.QueryString["t"];
            int intTenantId = 0;

            if (tenantId == null)
            {
                intTenantId = 1;
            }
            else
            {
                int.TryParse(tenantId.ToString(), out intTenantId);
            }

            string sql = @"SELECT OrganizationName, OrganizationAddress from Tenants where ID = @id";

            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@id", intTenantId);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                try
                {
                    reader.Read();

                    lblName.Text = reader["OrganizationName"].ToString();
                    lblName2.Text = lblName.Text;

                    lblAddress.Text = reader["OrganizationAddress"].ToString();
                    lblAddress2.Text = lblAddress.Text;
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