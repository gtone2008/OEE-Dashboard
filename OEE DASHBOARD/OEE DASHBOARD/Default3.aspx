<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default3.aspx.cs" Inherits="OEE_DASHBOARD.Default3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8"/>
    <title>OEE DASHBOARD</title>
    <!-- <meta http-equiv="refresh" content="1000000"> -->
    <script type="text/javascript" src="amf.js"></script>
    <script type="text/javascript" src="jquery.js"></script>
    <style>
        /*body {
            font-size: 20px;
        }*/
        ul {
            list-style-type: none;
        }

        table {
            margin: auto;
            float: left;           
            width: 100%;
            /*border: 1px groove ;*/
        }

            table td {
                align-content: center;
                align-items: center;
                border: 1px groove;
            }




        .Bar, .Bars {
            position: relative;
            width: 200px; /* 宽度 */
            border: 1px solid #B1D632;
            /*padding: 1px;*/
        }

            .Bar div, .Bars div {
                display: block;
                /*position: relative;*/
                /*background: #090;*/ /* 进度条背景颜色 */
                height: 20px; /* 高度 */
                line-height: 20px; /* 必须和高度一致，文本才能垂直居中 */
            }


                .Bar div span, .Bars div span {
                    position: absolute;
                    width: 200px; /* 宽度 */
                    text-align: center;
                    font-weight: bold;
                    
                }

        .cent {
            margin: auto 0.2% 2% 2%;
            background-color: gainsboro;
            width: 30%;
            overflow: hidden;
            float: left;
        }
    </style>

    <script type="text/javascript">

        //$.ajax({
        //    url: "http://huardcjemsdw01/amfphp/gateway.php",
        //    type: 'GET',
        //    dataType: 'JSONP',//here
        //    success: function (data) {
        //    }
        //});


        $(document).ready(function () {
            //setInterval("message()", 10000);
            message();
        });

        function call() {

            var amfClient = new amf.Client("amfphp", "http://huardcjemsdw01/amfphp/gateway.php");
            var p = amfClient.invoke("PortalCAMXGetMachineOEE", "getData", ["wuxcamx01", 6788, 0, "2016-12-29 14:00:00", "2016-12-29 15:50:18", 1]);

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
                        document.getElementById(id).innerHTML = "<div class='cent'><table><th colspan='3'>" + m1 + "</th><tr><td rowspan='3'><div style='text-align:center'>UTILIZATION</div><div class='Bars'><div class='BarRange' style='width:" + (res[0].OEE * 100).toFixed(2) + "%;'><span class='BarValue'>" + (res[0].OEE * 100).toFixed(2) + "%</span></div></div</td><td>Availability</br>" + (res[0].Availability * 100).toFixed(2) + "%</td><td>PPM</br>" + res[0].PPM + "</td></tr><tr><td>Performance</br>" + (res[0].Performance * 100).toFixed(2) + "%</td><td>Boards</br>" + res[0].BoardsProduced + "</td></tr><tr><td>Quality</br>" + (res[0].Quality * 100).toFixed(2) + "%</td><td>Failures</br>" + res[0].Failures + "</td></tr></table></div>"; //if (Number((res[0].OEE * 100).toFixed(2)) < 30) { $(".Bars div").css("background-color", "red"); };
                        //alert($(".Bars").width());
                        var bars = document.getElementsByClassName("Bars");
                        var barNodes = document.getElementsByClassName("BarRange");
                        var barValues = document.getElementsByClassName("BarValue");
                        //document.getElementById("id").style.backgroundColo = "gree"
                        var len = barValues.length;
                        //alert(parseFloat(barValues[len - 1].innerHTML));

                        if (parseFloat(barValues[len - 1].innerHTML) > 62) {
                            barNodes[len - 1].style.backgroundColor = "#92d050";
                            bars[len - 1].style.border = "1px solid #92d050";
                            //alert(parseFloat(barValues[len - 1].innerHTML));
                            //barValues[len - 1].style.color = "#92d050"
                        }
                        else if (55 < parseFloat(barValues[len - 1].innerHTML) <= 62) {
                            barNodes[len - 1].style.backgroundColor = "#ffff00";
                            bars[len - 1].style.border = "1px solid #ffff00";

                            //barValues[len - 1].style.backgroundColor = "black"
                        }
                        //else if (parseFloat(barValues[len - 1].innerHTML) <= 55) {
                        else{
                            barNodes[len - 1].style.backgroundColor = "#c0504d";
                            bars[len - 1].style.border = "1px solid #c0504d";

                            //barValues[len - 1].style.backgroundColor = "black"
                        }
                    },
                    function (err) {
                        //alert("ping errror");
                        //document.write("ping errror");
                        document.write("</br>Please use chrom install plug-in: https://chrome.google.com/webstore/detail/allow-control-allow-origi/nlfbmbojpeacfghkpbjhddihlkkiljbi");

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
            //alert($("table th").width());
            //if ($(".Bars div").width() < "50%") {
            //    $(".cent").css("background-color", "red");
            //}
            //calla("wuxcamx01",6788,0,"2016-12-29 14:00:00","2016-12-29 15:50:18",0,"d1");

            

        };
    </script>
</head>
<body>
    <form id="form1">
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
        <table style="display: none">
            <tr>
                <td>
                    <h3></h3>

                </td>
            </tr>
        </table>
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
  <%--      <script>
           
        </script>--%>
    </form>

</body>
</html>
