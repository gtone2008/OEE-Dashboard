using System;
using System.Collections;
using System.Collections.Specialized;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Data.Common;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Newtonsoft.Json.Linq;

namespace OEE_Action
{
    class Program
    {
        static void Main(string[] args)
        {
            OEEActionTrack.getDate();

            //Console.ReadKey();
        }
       
    }
}
