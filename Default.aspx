<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ComeYA._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div style="height:100%; overflow:auto; width:102%;">
        <h1>Buscar</h1>
    
        <asp:TextBox ID="TextBox1" runat="server" Visible="False"></asp:TextBox>
        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource2" DataTextField="nombIng" DataValueField="nombIng">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:usuarioConnectionString %>" SelectCommand="SELECT [nombIng] FROM [INGREDIENTE]"></asp:SqlDataSource>
        <p>
            &nbsp;</p>
        <p>
            <asp:Button ID="Button1" runat="server" Text="Buscar" OnClick="Button1_Click" Width="82px" />
            <p><asp:Label ID="Label1" runat="server"></asp:Label></p>
        </p>

        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
            <ItemTemplate>
                <h1>Titulo</h1>
                <p><%# Eval("titulo") %></p>
                <h1>Preparacion</h1>
                <p><%# Eval("preparación") %></p>
                <h1>Rating</h1>
                <p><%# Eval("ratingProm") %></p>
            </ItemTemplate>
            <SeparatorTemplate><p style="margin-top: 120px"></p></SeparatorTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString='<%$ ConnectionStrings:usuarioConnectionString %>'
            SelectCommand="SELECT [preparación], [titulo], [ratingProm] FROM [RECETA] JOIN RECETA_INGRED ON receta.idReceta=RECETA_INGRED.idReceta JOIN INGREDIENTE ON RECETA_INGRED.idIngred=INGREDIENTE.idIngred WHERE INGREDIENTE.nombIng='@ingred'">
        </asp:SqlDataSource>
    </div>
</asp:Content>
