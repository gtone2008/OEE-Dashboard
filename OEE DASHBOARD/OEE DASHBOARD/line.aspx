<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="line.aspx.cs" Inherits="OEE_DASHBOARD.line" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8" />
    <title>LINE CONFIG</title>
    <script src="jquery.js"></script>
    <script src="jquery.validate.js"></script>
    <link href="bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: Arial;
            width: 100%;
            height: 100%;
        }

        span {
            font-size: 30px;
        }

        div {
            display: block;
            margin: 20px 20px auto;
            align-content: center;
            width: 100%;
        }

        .error {
            color: red;
        }
    </style>

    <script>
        function check() {
            //  alert($("#sline").val());
            $("#form1").validate({
                rules: {
                    rgbvalue1: {
                        required: true,
                        digits: true
                    },
                    rgbvalue2: {
                        required: true,
                        digits: true
                    },
                }
            });
        }
    </script>
</head>
<body>
    <form id="form1" class="form-inline" runat="server">
        <div class="form-group">
            <span>Line</span>
            <select id="sline" name="sline">
                <option>Bay-03-1</option>
                <option>Bay-03-2</option>
                <option>Bay-05-1</option>
            </select>
            <select id="stype" name="stype">
                <option>Availability</option>
                <option>Performance</option>
                <option>Quality</option>
            </select>
            <input type="text" id="rgbvalue1" name="rgbvalue1" />
            <input type="text" id="rgbvalue2" name="rgbvalue2" />
            <%--<button type="button" class="btn btn-default" onclick="summit()">Summit</button>--%>
            <asp:Button class="btn btn-default" OnClientClick="check()" runat="server" Text="Submmit" OnClick="Submmit1_Click" ID="Submmit1" />
            <a href="Default.aspx">Go Home</a>
        </div>
        <div class="form-group">
            <asp:GridView ID="gv1" runat="server" BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Horizontal" Width="30%">
                <AlternatingRowStyle BackColor="#F7F7F7" />
                <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                <PagerStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" HorizontalAlign="Right" />
                <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
                <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                <SortedAscendingCellStyle BackColor="#F4F4FD" />
                <SortedAscendingHeaderStyle BackColor="#5A4C9D" />
                <SortedDescendingCellStyle BackColor="#D8D8F0" />
                <SortedDescendingHeaderStyle BackColor="#3E3277" />
            </asp:GridView>
        </div>
    </form>
</body>
</html>
