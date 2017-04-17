<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default1.aspx.cs" Inherits="OEE_DASHBOARD.Default1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8">
    <title>OEE DASHBOARD</title>
    <!-- <meta http-equiv="refresh" content="1000000"> -->
    <script type="text/javascript" src="amf.js"></script>
    <script type="text/javascript" src="jquery.js"></script>
    <style>
        /*body {
            font-size: 20px;
        }*/
        ul{
            list-style-type:none;
        }

        #n {
            margin: 10px auto;
            width: 920px;
            border: 1px solid #CCC;
            font-size: 14px;
            line-height: 30px;
        }

            #n a {
                padding: 0 4px;
                color: #333;
            }

        .Bar, .Bars {
            /*position: relative;*/
            width: 200px; /* 宽度 */
            border: 1px solid #B1D632;
            /*padding: 1px;*/
        }

            .Bar div, .Bars div {
                display: block;
                position: relative;
                background: #00F; /* 进度条背景颜色 */
                /*color: #333333;*/
                height: 20px;  /*高度*/ 
                line-height: 20px; /* 必须和高度一致，文本才能垂直居中 */
            }

            .Bars div {
                background: #090;

            }

                .Bar div span, .Bars div span {
                    position: absolute;
                    width: 200px; /* 宽度 */
                    text-align: center;
                    font-weight: bold;
                }

        .cent {
            margin: auto, auto;
            width: 20%;
            overflow: hidden;
            float: left;
        }
    </style>

    <script language="javascript">

        //$.ajax({
        //    url: "http://huardcjemsdw01/amfphp/gateway.php",
        //    type: 'GET',
        //    dataType: 'JSONP',//here
        //    success: function (data) {
        //    }
        //});

        $(document).ready(function () {
            message();
            //setInterval("message()", 5000);
        });

        function call() {

            var amfClient = new amf.Client("amfphp", "http://huardcjemsdw01/amfphp/gateway.php");
            var p = amfClient.invoke("PortalCAMXGetMachineOEE", "getData", ["wuxcamx01", 6788, 0, "2016-12-29 14:00:00", "2016-12-29 15:50:18", 0]);

            p.then(
                    function (res) {
                        alert(res[0].OEE);
                        //for(var p in res[0]){  
                        //				 
                        //	alert(p.tostring() + ":" + res[0][p]);
                        //	
                        //};
                    },
                    function (err) {
                        alert("ping errror");

                    }
            );
        };

        function calla(myServer, equipID, modID, startTime, endTime, ipc, id, m1) {
            var amfClient = new amf.Client("amfphp", "http://huardcjemsdw01/amfphp/gateway.php");
            var p = amfClient.invoke("PortalCAMXGetMachineOEE", "getData", [myServer, equipID, modID, startTime, endTime, ipc]);

            p.then(
                    function (res) {
                        //alert(res[0].OEE);
                        document.getElementById(id).innerHTML = "<div class='cent'><p>" + m1 + "</p><ul><li>OEE:<div class='Bars'><div style='width:" + res[0].OEE * 100 + "%;'><span>" + res[0].OEE * 100 + "%</span></div></div></li>" + "<li>PPM:" + res[0].PPM + "</li>" + "<li>BoardsProduced:" + res[0].BoardsProduced + "</li>" +
                        "<li>Performance:" + res[0].Performance + "</li>" + "<li>BoardsPerPanel:" + res[0].BoardsPerPanel + "</li>" + "<li>Quality:" + res[0].Quality + "</li>" + "<li>Failures:" + res[0].Failures + "</li>" + "<li>Availability:" + res[0].Availability + "</li>" + "</ul><div>";
                    },
                    function (err) {
                        //alert("ping errror");
                        document.write("ping errror");

                    }
            );
        };

        function message() {
            var mydate = new Date();
            var day = mydate.getDate();//日
            var month = mydate.getMonth() + 1;//月
            var year = mydate.getFullYear();//年
            //var day1 = day + 1;
            //var dayA = mydate.toLocaleTimeString();//当前系统时间
            //alert(today.toLocaleTimeString());
            var h1 = mydate.getHours(), m1 = mydate.getMinutes(), s1 = mydate.getSeconds();
            if (mydate.getHours() < 10) {
                h1 = "0" + h1;
            }
            if (mydate.getMinutes() < 10) {
                m1 = "0" + m1;
            }
            if (mydate.getSeconds() < 10) {
                s1 = "0" + s1;
            }
            var t1 = h1 + ":" + m1 + ":" + s1;
            //alert(t1);
            var dd = new Date(year + "/" + month + "/" + day + " " + t1)
            var dd1 = new Date(year + "/" + month + "/" + day + " 07:15:00");
            var dd2 = new Date(year + "/" + month + "/" + day + " 19:15:00");
            if (dd1 <= dd < dd2)//"07:15:00"<=t1<"19:15:00"
            {
                var date1 = year + "-" + month + "-" + day + " 07:15:00";
                var date2 = year + "-" + month + "-" + day + " " + t1;
            }
            if (dd >= dd2)//t1 >= "19:15:00"
            {
                var date1 = year + "-" + month + "-" + day + " 19:15:00";
                var date2 = year + "-" + month + "-" + day + " " + t1;
            }
            //alert(date1);
            //alert(date2);
            //var date1 = year + "-" + month + "-" + day + " 07:15:00";
            //var date2 = year + "-" + month + "-" + day1 + " 07:15:00";
            //var date2 = year + "-" + month + "-" + day+" 19:15:00"; 


            //$("#p1").innerHTML(date1);

            calla("wuxcamx01", 6788, 0, date1, date2, 1, "d1", "Bay-03-1");
            calla("wuxcamx01", 8481, 0, date1, date2, 1, "d2", "Bay-03-2");
            calla("wuxcamx01", 7058, 0, date1, date2, 1, "d3", "Bay-05-1");
            calla("wuxcamx01", 7059, 0, date1, date2, 1, "d4", "Bay-05-2");
            calla("wuxcamx01", 6876, 0, date1, date2, 1, "d5", "Bay-06-1");
            calla("wuxcamx01", 11306, 0, date1, date2, 1, "d6", "Bay-06-2");
            calla("wuxcamx01", 7060, 0, date1, date2, 1, "d7", "Bay-06A");
            calla("wuxcamx01", 7061, 0, date1, date2, 1, "d8", "Bay-08-1");
            calla("wuxcamx01", 7063, 0, date1, date2, 1, "d9", "Bay-08A-1");
            calla("wuxcamx01", 7064, 0, date1, date2, 1, "d10", "Bay-08A-2");
            calla("wuxcamx01", 7065, 0, date1, date2, 1, "d11", "Bay-09-1");
            calla("wuxcamx01", 7848, 0, date1, date2, 1, "d12", "Bay-09-2");
            //calla("wuxcamx01",6788,0,"2016-12-29 14:00:00","2016-12-29 15:50:18",0,"d1");
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <%--<div class="cent" style="visibility:hidden">

            <div class="Bar">
                <div style="width: 50%;"><span>50%</span>    </div>
            </div>

            <div class="Bar">
                <div style="width: 80%;"><span>80%</span>     </div>
            </div>



            <div class="Bars">
                <div style="width: 13%;"><span>13%</span>     </div>
            </div>


        </div>--%>

        <div id="d1"></div>
        <div id="d2"></div>
        <div id="d3"></div>
        <div id="d4"></div>
        <div id="d5"></div>
        <div id="d6"></div>
        <div id="d7"></div>
        <div id="d8"></div>
        <div id="d9"></div>
        <div id="d10"></div>
        <div id="d11"></div>
        <div id="d12"></div>
    </form>
</body>
</html>
