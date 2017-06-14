<%@ Page Title="Acerca de" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="ComeYA.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div style="height:100%; overflow:auto; width:102%;">
        <h2><%: Title %></h2>
        <h3>ComeYA</h3>
        <p>Aplicación de recetas que funciona al revés. Tú nos dices los ingredientes y nosotros te damos la receta.</p>
    </div>
</asp:Content>