using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;

namespace ComeYA
{
    public partial class _Default : Page
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
            cmd.CommandText = "SELECT [preparación], [titulo], [ratingProm] FROM [RECETA] JOIN RECETA_INGRED ON receta.idReceta=RECETA_INGRED.idReceta JOIN INGREDIENTE ON RECETA_INGRED.idIngred=INGREDIENTE.idIngred WHERE INGREDIENTE.nombIng='"+DropDownList1.Text+"'";
            cmd.Connection = con;
            sda.SelectCommand = cmd;
            sda.Fill(ds, "[RECETA] JOIN RECETA_INGRED ON receta.idReceta=RECETA_INGRED.idReceta JOIN INGREDIENTE ON RECETA_INGRED.idIngred=INGREDIENTE.idIngred");
            if (ds.Tables[0].Rows.Count > 0)
            {
                Repeater1.DataSource = null;
                Repeater1.DataSourceID = null;
                Repeater1.DataBind();
                SqlDataSource1.SelectParameters.Clear();
                /*SqlDataSource1.SelectParameters.Add("@ingred", TextBox1.Text);*/
                SqlDataSource1.SelectCommand = cmd.CommandText;
                Label1.Text = "";
                Repeater1.DataSource = SqlDataSource1;
                Repeater1.DataBind();
            }
            else
            {
                Repeater1.DataSource = null;
                Repeater1.DataSourceID = null;
                Repeater1.DataBind();
                Label1.Text = "No se encontro nada";
            }
        }
    }
}