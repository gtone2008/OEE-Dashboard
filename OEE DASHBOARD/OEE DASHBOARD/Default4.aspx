<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default4.aspx.cs" Inherits="OEE_DASHBOARD.Default4" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8"/>
    <title>OEE DASHBOARD</title>
    <!-- <meta http-equiv="refresh" content="1000000"> -->
    <script type="text/javascript" src="amf.js"></script>
    <script type="text/javascript" src="jquery.js"></script>
    <script type="text/javascript" src="echarts-all.js"></script>
    <style>
        body {
            font-family:Arial;
            width:100%;
            height:100%;
        }
        ul {
            list-style-type: none;
        }

        table {
            margin: auto;
            float: left;           
            width: 100%;
            border: 1px groove ;
        }

            table td {
                align-content: center;
                align-items: center;
                /*border: 1px groove;*/
            }




  .Bars,.Bars1,.Bars2 {
            position: relative;
            width: 200px; /* 宽度 */
            /*border: 1px solid #92d050;*/
        }

           .Bars div {
                display: block;
                position: relative;
                /*background: #ffc300; /* 进度条背景颜色 */
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
            /*background-color: gainsboro;*/
            width: 30%;
            overflow: hidden;
            float: left;
            height:25%;
        }
        .chart{
            height:230px;
            width:230px;
            align-items:center;
            align-content:center;
            /*font-size:10px;*/
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
            message();
            //setInterval("message()", 60000);
            
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

        function calla(myServer, equipID, modID, startTime, endTime, ipc, id, m1,idchart) {
            var amfClient = new amf.Client("amfphp", "http://huardcjemsdw01/amfphp/gateway.php");
            var p = amfClient.invoke("PortalCAMXGetMachineOEE", "getData", [myServer, equipID, modID, startTime, endTime, ipc]);

            p.then(
                    function (res) {
                        //alert(res[0].OEE);
                        document.getElementById(id).innerHTML = "<div class='cent'><table><th colspan='2'>" + m1 + "</th><tr><td rowspan='3'><div class='chart' id='" + idchart + "'></div</td><td>Availability:<div class='Bars'><div class='BarRange' style='width:" + (res[0].Availability * 100).toFixed(0) + "%;'><span class='BarValue'>" + (res[0].Availability * 100).toFixed(0) + "%</span></div></div</td></tr><tr><td>Performance:<div class='Bars1'><div class='BarRange1' style='width:" + (res[0].Performance * 100).toFixed(0) + "%;'><span class='BarValue1'>" + (res[0].Performance * 100).toFixed(0) + "%</span></div></td></tr><tr><td>Quality:<div class='Bars2'><div class='BarRange2' style='width:" + (res[0].Quality * 100).toFixed(0) + "%;'><span class='BarValue2'>" + (res[0].Quality * 100).toFixed(0) + "%</span></div></td></tr></table></div>";

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
                        if (55 < parseFloat(barValues[len - 1].innerHTML) <= 62) {
                            barNodes[len - 1].style.backgroundColor = "#ffff00";
                            bars[len - 1].style.border = "1px solid #ffff00";

                            //barValues[len - 1].style.backgroundColor = "black"
                        }
                        if (parseFloat(barValues[len - 1].innerHTML) <= 55) {
                            barNodes[len - 1].style.backgroundColor = "#c0504d";
                            bars[len - 1].style.border = "1px solid #c0504d";

                            //barValues[len - 1].style.backgroundColor = "black"
                        }

                        
                       

                        var myChart = echarts.init(document.getElementById(idchart));
                        var option = {
                            tooltip: {
                                show: true,
                                position: ['50%', '50%'],
                                formatter: "{a} <br/>{b} : {c}%"

                            },
                            toolbox: {
                                show: false,
                                feature: {
                                    mark: { show: false },
                                    restore: { show: false },
                                    saveAsImage: { show: false }
                                }
                            },
                            series: [
                                {
                                    name: m1,
                                    type: 'gauge',
                                    min: 0,
                                    max: 100,
                                    splitNumber: 10,       // 分割段数，默认为5
                                    axisLine: {            // 坐标轴线
                                        lineStyle: {       // 属性lineStyle控制线条样式
                                            color: [[0.2, '#ff4500'], [0.8, '#48b'], [1, '#228b22']],
                                            width: 8
                                        }
                                    },
                                    axisTick: {            // 坐标轴小标记
                                        show:true,
                                        splitNumber: 10,   // 每份split细分多少段
                                        length: 12,        // 属性length控制线长
                                        lineStyle: {       // 属性lineStyle控制线条样式
                                            color: 'auto'
                                        }
                                    },
                                    axisLabel: {           // 坐标轴文本标签，详见axis.axisLabel
                                        show:false,
                                        textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                                            color: 'auto'
                                        }
                                    },
                                    splitLine: {           // 分隔线
                                        show: true,        // 默认显示，属性show控制显示与否
                                        length: 30,         // 属性length控制线长
                                        lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                                            color: 'auto'
                                        }
                                    },
                                    pointer: {
                                        width: 5
                                    },
                                    title: {
                                        show: true,
                                        offsetCenter: [0, '-40%'],       // x, y，单位px
                                        textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                                            fontWeight: 'bolder',
                                            fontSize:10
                                        }
                                    },
                                    detail: {
                                        formatter: '{value}%',
                                        textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                                            color: 'auto',
                                            fontWeight: 'bolder',
                                            fontSize: 25

                                            
                                        }
                                    },
                                    data: [{ value: 0, name: 'UTILIZATION' }]
                                }
                            ]
                        };

                        // 为echarts对象加载数据 
                        myChart.setOption(option);

                        setInterval(function () {
                            option.series[0].data[0].value = (res[0].OEE * 100).toFixed(0) - 0;
                            myChart.setOption(option, true);
                        }, 2000);
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

            calla("wuxcamx01", 6788, 0, date1, date2, 1, "d1", "Bay-03-1","dd1");
            calla("wuxcamx01", 8481, 0, date1, date2, 1, "d2", "Bay-03-2", "dd2");
            calla("wuxcamx01", 7058, 0, date1, date2, 1, "d3", "Bay-05-1", "dd3");
            calla("wuxcamx01", 7059, 0, date1, date2, 1, "d4", "Bay-05-2", "dd4");
            calla("wuxcamx01", 6876, 0, date1, date2, 1, "d5", "Bay-06-1","dd5");
            calla("wuxcamx01", 11306, 0, date1, date2, 1, "d6", "Bay-06-2", "dd6");
            calla("wuxcamx01", 7060, 0, date1, date2, 1, "d7", "Bay-06A","dd7");
            calla("wuxcamx01", 7061, 0, date1, date2, 1, "d8", "Bay-08-1","dd8");
            calla("wuxcamx01", 7063, 0, date1, date2, 1, "d9", "Bay-08A-1", "dd9");
            calla("wuxcamx01", 7064, 0, date1, date2, 1, "d10", "Bay-08A-2", "dd10");
            calla("wuxcamx01", 7065, 0, date1, date2, 1, "d11", "Bay-09-1", "dd11");
            calla("wuxcamx01", 7848, 0, date1, date2, 1, "d12", "Bay-09-2", "dd12");
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
