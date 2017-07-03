<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ComeYA._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div style="height:100%; overflow:auto; width:102%;">
        <br />
        <div class="cont1">
            <h1 style="#display:inline; margin-right: 40px;">Ingrediente</h1>
    
            <asp:TextBox ID="TextBox1" runat="server" Visible="False"></asp:TextBox>
            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource2" DataTextField="nombIng" DataValueField="nombIng" Height="48px" Width="40%" BackColor="#BC6B82" ForeColor="White">
            </asp:DropDownList>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:usuarioConnectionString %>" SelectCommand="SELECT [nombIng] FROM [INGREDIENTE]"></asp:SqlDataSource>
            <p>&nbsp;</p>
            <p style="align-content:center; text-align:right">
                <asp:Button ID="Button1" runat="server" Text="Buscar" OnClick="Button1_Click" Width="120px" BackColor="#BC6B82" BorderColor="White" ForeColor="White" Height="40px" BorderWidth="2px" />
            </p>
        </div>
        <div class="cont2">                
            <p><asp:Label ID="Label1" runat="server"></asp:Label></p
            <table>
            <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
                <ItemTemplate>
                    <tr>
                        <td>
                            <h1 style="color:#fffcfd"><%# Eval("titulo") %></h1>
                        </td>
                        <td>
                            <p><h1 style="display:inline">Rating: </h1> <%# Eval("ratingProm") %>/5</p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        <h1>Preparación</h1>
                        </td>
                    </tr>
                    <tr>
                        <td><p style="margin-left: 15px"><%# Eval("preparación") %></p></td>
                    </tr>
                </ItemTemplate>
                <SeparatorTemplate><p style="margin-top: 50px"> </p></SeparatorTemplate>
            </asp:Repeater>
            </table>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString='<%$ ConnectionStrings:usuarioConnectionString %>'
            SelectCommand="SELECT [preparación], [titulo], [ratingProm] FROM [RECETA] JOIN RECETA_INGRED ON receta.recetaid=RECETA_INGRED.recetaid JOIN INGREDIENTE ON RECETA_INGRED.ingredid=INGREDIENTE.ingredid WHERE INGREDIENTE.nombIng='@ingred'">
        </asp:SqlDataSource>
    </div>
</asp:Content>
