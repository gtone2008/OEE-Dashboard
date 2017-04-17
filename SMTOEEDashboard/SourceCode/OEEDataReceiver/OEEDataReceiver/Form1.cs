using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows;
using mshtml;
using System.IO;
using System.Reflection;
using System.Threading;
using System.Configuration;
using System.Diagnostics;
using Microsoft.Win32;

namespace OEEDataReceiver
{
    //注意：运行该程序需要在注册表中修改IE的版本，至少需要IE9以上
    public partial class Form1 : Form
    {
        static int _counter = 0;
        static bool _enabled = true;
        static string _json = "{ \"OEEData\":[";
        static string[] _equipmentIds = ConfigurationManager.AppSettings["EQUIPMENTIDS"].Split(',');
        static string _path = ConfigurationManager.AppSettings["DestPATH"];
        static DateTime _dt = DateTime.Now;
        static DateTime _currentShiftStartTime = GetShiftStartTime(_dt);

        //修改IE版本
        public void setIEcomp()
        {
            String appname = Process.GetCurrentProcess().ProcessName + ".exe";
            RegistryKey RK8 = Registry.LocalMachine.OpenSubKey("HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main\\FeatureControl\\FEATURE_BROWSER_EMULATION", RegistryKeyPermissionCheck.ReadWriteSubTree);
            int value9 = 9999;
            int value8 = 8888;
            //Version ver = WebBrowser.Version;
            string ver=(new WebBrowser()).Version.ToString();
            int value = value9;
            try
            {
                string[] parts = ver.ToString().Split('.');
                int vn = 0;
                int.TryParse(parts[0], out vn);
                if (vn != 0)
                {
                    if (vn == 9)
                        value = value9;
                    else
                        value = value8;
                }
            }
            catch
            {
                value = value9;
            }
            //Setting the key in LocalMachine
            if (RK8 != null)
            {
                try
                {
                    RK8.SetValue(appname, value, RegistryValueKind.DWord);
                    RK8.Close();
                }
                catch (Exception ex)
                {
                    //MessageBox.Show(ex.Message);
                }
            }
        }

        public Form1()
        {
            //setIEcomp();
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
            string jsPath = ConfigurationManager.AppSettings["JSPATH"];
            element.text = File.ReadAllText(jsPath);
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
                    doc.InvokeScript("call", new object[] { _equipmentIds[_counter], _currentShiftStartTime.ToString("yyyy-MM-dd HH:mm:ss"), _dt.ToString("yyyy-MM-dd HH:mm:ss") }).ToString();
                    _enabled = false;
                    break;
                }
            }

            if (_counter == _equipmentIds.Length)
            {
                _json = _json.Substring(0, _json.Length - 1);
                _json += "]}";
                using (StreamWriter sw = File.CreateText(_path))
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
