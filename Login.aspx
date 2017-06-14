<%@ Page Title="Iniciar sesión" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ComeYA.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div style="height:100%; overflow:auto; width:102%;">
        <h2><%: Title %><asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:usuarioConnectionString %>" SelectCommand="SELECT [nombUs], [passw] FROM [USUARIO]"></asp:SqlDataSource></h2>
        <h3>Usuario</h3>
        <p><asp:TextBox ID="TextBox1" runat="server"></asp:TextBox></p>
        <h3>Contraseña</h3>
        <p>
            <asp:TextBox ID="TextBox2" runat="server" OnTextChanged="TextBox2_TextChanged" TextMode="Password"></asp:TextBox>
        </p>
        <p style="margin-left: 15em"><asp:Button ID="Button1" runat="server" Text="Iniciar sesión" OnClick="Button1_Click" />
        </p>
        <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
    </div>
</asp:Content>
