using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using MySql.Data.MySqlClient;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Configuration;

namespace OEE_Action
{
    class OEEActionTrack
    {

        static DateTime dtTriggerStart;
        static readonly string CONNSTRING = ConfigurationManager.AppSettings["MySQLconn"].ToString();
        public static string[] _owers = ConfigurationManager.AppSettings["Ower"].Split(',');
        static string _ower = "";
        static string _info = "";

        public static void getDate()
        {
            var content = File.ReadAllText(@"\\Wuxengser04\OEEDASHBOARD\OEEData.txt", Encoding.Default);
            JObject jobOEE = JObject.Parse(content);
            var OEEDatas = from xx in jobOEE["OEEData"].Children() select xx;
            //StringBuilder sb = new StringBuilder();
            foreach (var name in OEEDatas)
            {
                double oee = (double)name["OEE"];
                string cell = name["Machine"].ToString();              
                if (IsTrigger(oee, ref cell))
                {
                    _info = "Availability:" + (Convert.ToDouble(name["Availability"])*100).ToString() + "% Performance:" + (Convert.ToDouble(name["Performance"])*100).ToString() + "% Quality:" + (Convert.ToDouble(name["Quality"])*100).ToString()+"%";
                    if (!TriggerDataExist(ref cell))
                    {
                        //插入报警数据
                        InsertWarningData(oee, ref cell);
                        //sb.AppendLine(cell + "  " + oee);
                    }
                    else
                    {
                        //如果触发报警，并且系统中已存在报警数据，更新持续时间，并判断，如果持续时间超过12小时，自动关闭.

                        //更新持续时间
                        if(checkEdit(cell))
                        UpdateWarning(oee, ref cell);
                        //判断是否关闭
                    }


                }
                else
                {
                    //判断是否存在此cell的报警数据
                    if (TriggerDataExist(ref cell))
                    {
                        //关闭该报警
                        CloseWarning(ref cell);
                    }

                }
            }
        }

        private static bool checkEdit(string cell)
        {
            string cmdText = "select ActualAction from actiontrack where bay='@cell' and warningstatus='open' and application='OEE DASHBOARD(%)';";
            cmdText = cmdText.Replace("@cell", cell);

            MySqlDataReader dt = MySqlHelper.ExecuteReader(CONNSTRING, cmdText);
            if (dt.Read())
            {
                if (Convert.ToString(dt[0]) == "Edit")
                    return true;
                else
                    return false;
            }
            else
            {
                return false;
            }

        }
     

        public static bool IsTrigger(double oee, ref string cell)
        {
            double trigger = 0.2;
            switch (cell)
            {
                case "BAY03_M1": cell = "Bay 03-1"; trigger = 0.25; _ower = _owers[0]; break;
                case "BAY03_M2": cell = "Bay 03-2"; trigger = 0.3; _ower = _owers[1]; break;
                case "BAY5A1": cell = "Bay 05-1"; trigger = 0.1; _ower = _owers[2]; break;
                case "BAY5B1": cell = "Bay 05-2"; trigger = 0.1; _ower = _owers[3]; break;
                case "BAY6_M1": cell = "Bay 06-1"; trigger = 0.05; _ower = _owers[4]; break;
                case "BAY6_M2": cell = "Bay 06-2"; trigger = 0.2; _ower = _owers[5]; break;
                case "BAY6A_M1": cell = "Bay 6A-1"; trigger = 0.05; _ower = _owers[6]; break;
                case "BAY8_M1": cell = "Bay 08-1"; trigger = 0.3; _ower = _owers[7]; break;
                case "BAY8A_M1": cell = "Bay 8A-1"; trigger = 0.3; _ower = _owers[8]; break;
                case "BAY8A_M2": cell = "Bay 8A-2"; trigger = 0.1; _ower = _owers[9]; break;
                case "BAY9_M1": cell = "Bay 09-1"; trigger = 0.2; _ower = _owers[10]; break;
                case "BAY9_M2": cell = "Bay 09-2"; trigger = 0.2; _ower = _owers[11]; break;
                default: break;
            }

            if (oee > trigger || oee == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }


        public static bool TriggerDataExist(ref string cell)
        {
            string cmdText = "select * from actiontrack where bay='@cell' and warningstatus='open' and application='OEE DASHBOARD(%)';";
            cmdText = cmdText.Replace("@cell", cell);

            MySqlDataReader dt = MySqlHelper.ExecuteReader(CONNSTRING, cmdText);
            if (dt.Read())
            {
                dtTriggerStart = Convert.ToDateTime(dt["WarningFrom"]);
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// 插入报警数据
        /// </summary>
        /// <param name="oee">OEE数据</param>
        /// <param name="cell">Bay</param>
        public static void InsertWarningData(double oee, ref string cell)
        {
            string cmdText = "insert into actiontrack (application,bay,warningdata,warningfrom,proposal,actualaction,warningstatus,elapsemins,WarningOwner,WarningInfo)";
            cmdText += " values ('OEE DASHBOARD(%)','@cell',@oee,current_timestamp,'OEE DASHBOARD','Edit','open',0,'@ower','@info');";

            cmdText = cmdText.Replace("@cell", cell);
            cmdText = cmdText.Replace("@oee", (oee*100).ToString());
            cmdText = cmdText.Replace("@ower", _ower);
            cmdText = cmdText.Replace("@info", _info);

            int rows = MySqlHelper.ExecuteNonQuery(CONNSTRING, cmdText);
        }

        /// <summary>
        /// 更新报警持续时间
        /// </summary>
        public static void CloseWarning(ref string cell)
        {
            DateTime dtTriggerEnd = DateTime.Now;
            TimeSpan ts = dtTriggerEnd - dtTriggerStart;

            int mins = Convert.ToInt32(ts.TotalMinutes);

            string cmdText = "set sql_safe_updates=0;";
            cmdText += " update actiontrack set warningstatus='close',elapsemins=@mins where bay='@cell' and warningstatus='open' and application='OEE DASHBOARD(%)'; ";
            cmdText += " set sql_safe_updates=1;";

            cmdText = cmdText.Replace("@mins", mins.ToString());
            cmdText = cmdText.Replace("@cell", cell);
            int rows = MySqlHelper.ExecuteNonQuery(CONNSTRING, cmdText);
        }

        public static void UpdateWarning(double oee, ref string cell)
        {
            DateTime dtTriggerEnd = DateTime.Now;
            TimeSpan ts = dtTriggerEnd - dtTriggerStart;

            int mins = Convert.ToInt32(ts.TotalMinutes);

            string cmdText = "set sql_safe_updates=0;";

            if (mins < 480)
            {
                cmdText += " update actiontrack set WarningOwner='@ower',WarningInfo='@info', warningdata=@datawarning,elapsemins=@mins where bay='@cell' and warningstatus='open' and application='OEE DASHBOARD(%)'; ";
            }
            else
            {
                cmdText += " update mesystem.actiontrack set warningdata=@datawarning,elapsemins=@mins,warningstatus='close' where bay='@cell' and warningstatus='open' and application='OEE DASHBOARD(%)'; ";
            }
            cmdText += " set sql_safe_updates=1;";

            cmdText = cmdText.Replace("@mins", mins.ToString());
            cmdText = cmdText.Replace("@cell", cell);
            cmdText = cmdText.Replace("@datawarning", (oee*100).ToString());
            cmdText = cmdText.Replace("@ower", _ower);
            cmdText = cmdText.Replace("@info", _info);
            int rows = MySqlHelper.ExecuteNonQuery(CONNSTRING, cmdText);
        }


    }
}
