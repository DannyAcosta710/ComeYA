<%@ Page Title="Iniciar sesión" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ComeYA.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div style="height:100%; overflow:auto; width:102%;">
        <br />
        <div class="cont1" style="text-align:center">
            <h2><%: Title %><asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:usuarioConnectionString %>" SelectCommand="SELECT [nombUs], [passw] FROM [USUARIO]"></asp:SqlDataSource></h2>
            <h3>Usuario</h3>
            <p><asp:TextBox ID="TextBox1" runat="server"></asp:TextBox></p>
            <h3>Contraseña</h3>
            <p>
                <asp:TextBox ID="TextBox2" runat="server" OnTextChanged="TextBox2_TextChanged" TextMode="Password"></asp:TextBox>
            </p>
            <p style="text-align:right;"><asp:Button ID="Button1" runat="server" Text="Iniciar sesión" OnClick="Button1_Click" />
            </p>
        </div>
        <br />
        <div  runat="server" id="divControl">
            <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
        </div>
    </div>
</asp:Content>
