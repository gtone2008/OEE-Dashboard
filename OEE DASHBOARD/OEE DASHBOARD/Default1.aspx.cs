using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OEE_DASHBOARD;
namespace OEE_DASHBOARD
{
    public partial class Default1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try {
                Response.Write(Common.GetADUserEntity(Common.GetCurrentNTID()));
            } catch (Exception e1)
            {
                Response.Write(Common.GetCurrentNTID());
               
            }
        }
    }
}