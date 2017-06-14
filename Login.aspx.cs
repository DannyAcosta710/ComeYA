using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ComeYA
{
    public partial class Contact : Page
    {
        SqlCommand cmd = new SqlCommand();
        SqlConnection con = new SqlConnection();
        SqlDataAdapter sda = new SqlDataAdapter();
        DataSet ds = new DataSet();
        string connStr = ConfigurationManager.ConnectionStrings["usuarioConnectionString"].ConnectionString;


        protected void Page_Load(object sender, EventArgs e)
        {
            con.ConnectionString = connStr;
            con.Open();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            cmd.CommandText = "select * from usuario where nombUs='"+TextBox1.Text+"' AND passw='"+TextBox2.Text+ "' COLLATE SQL_Latin1_General_CP1_CS_AS AND Passw='"+TextBox2.Text+"'";
            cmd.Connection = con;
            sda.SelectCommand = cmd;
           sda.Fill(ds, "usuario");
            if(ds.Tables [0].Rows.Count > 0)
            {
                Label1.Text = "El usuario existe";
            } else
            {
                Label1.Text = "El usuario no existe o la contraseña esta mal";
            }
        }

        protected void TextBox2_TextChanged(object sender, EventArgs e)
        {

        }
    }
}