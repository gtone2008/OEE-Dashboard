using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using mshtml;
using System.IO;
using System.Reflection;
using System.Threading;
using System.Configuration;

namespace OEEDataCollector
{
    //注意：运行该程序需要在注册表中修改IE的版本，至少需要IE9以上
    public partial class Form1 : Form
    {
        static int _counter = 0;
        static bool _enabled = true;
        static string _json = "{ \"OEEData\":[";
        static string[] _equipmentIds = ConfigurationManager.AppSettings["EQUIPMENTIDS"].Split(',');
        static string _destFile = ConfigurationManager.AppSettings["DESTFILE"];
        static string _sqlServer = ConfigurationManager.AppSettings["SQLSERVER"];
        static DateTime _dt = DateTime.Now;
        static DateTime _currentShiftStartTime = GetShiftStartTime(_dt);

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            string url = ConfigurationManager.AppSettings["URL"];
            this.webBrowser1.Url = new Uri(url);
        }

        private void webBrowser1_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
        {
            HtmlDocument doc = this.webBrowser1.Document;
            HtmlElement head = webBrowser1.Document.GetElementsByTagName("head")[0];

            HtmlElement script = doc.CreateElement("SCRIPT");
            IHTMLScriptElement element = (IHTMLScriptElement)script.DomElement;
            string jsFile = ConfigurationManager.AppSettings["JSFILE"];
            element.text = File.ReadAllText(jsFile);
            head.AppendChild(script);

            this.timer1.Enabled = true;
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            this.timer1.Enabled = false;
            HtmlDocument doc = this.webBrowser1.Document;
            string oeeData = doc.InvokeScript("GetOEEData").ToString();
            if (!string.IsNullOrEmpty(oeeData))
            {
                _enabled = true;
                _counter++;
                _json += oeeData + ",";
            }

            foreach (string equipmentId in _equipmentIds)
            {
                if (_enabled && _counter <= _equipmentIds.Length - 1)
                {
                    doc.InvokeScript("call",
                        new object[] { 
                                        _sqlServer, 
                                        _equipmentIds[_counter],
                                        _currentShiftStartTime.ToString("yyyy-MM-dd HH:mm:ss"), 
                                        _dt.ToString("yyyy-MM-dd HH:mm:ss") 
                                    }).ToString();

                    _enabled = false;
                    break;
                }
            }

            if (_counter == _equipmentIds.Length)
            {
                _json = _json.Substring(0, _json.Length - 1);
                _json += "]}";
                using (StreamWriter sw = File.CreateText(_destFile))
                {
                    sw.WriteLine(_json);
                }

                Application.Exit();
            }
            else
            {
                this.timer1.Enabled = true;
            }
        }

        private static DateTime GetShiftStartTime(DateTime t)
        {
            t -= new TimeSpan(7, 15, 0);
            return t.Date + new TimeSpan(t.Hour < 12 ? 7 : 19, 15, 0);
        }
    }
}
