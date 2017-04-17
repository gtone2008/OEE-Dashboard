using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
namespace OEE_DASHBOARD
{
    public partial class line : System.Web.UI.Page
    {
        string sql1 = "insert into line_config(line, type, rgbval1, rgbval2) values('{0}','{1}','{2}','{3}')";
        string sql2 = "select line, type, rgbval1, rgbval2 from line_config group by line";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Debug.Print("test" + DateTime.Now.ToString("yyyy-mm-dd hh:mm:ss:fff"));
                dvband();
            }

        }

        protected void Submmit1_Click(object sender, EventArgs e)
        {
            //System.Collections.Specialized.NameValueCollection nc = new System.Collections.Specialized.NameValueCollection(Request.Form);
            //Response.Write(nc.GetValues("sline")[0].ToString());
            //Response.Write(Request["sline"]);

            sql1 = string.Format(sql1, Request["sline"], Request["stype"], Request["rgbvalue1"], Request["rgbvalue2"]);
            if (MysqlHelper.MysqlHelper.ExecuteNonQuery(sql1) > 0)
            {
                Response.Write("<script>alert('成功！')</script>");
                Response.Redirect("line.aspx");//防止重复提交
                dvband();

            }
        }

        private void dvband()
        {
            gv1.DataSource = MysqlHelper.MysqlHelper.ExecuteDataTable(sql2);
            gv1.DataBind();
        }


    }
}