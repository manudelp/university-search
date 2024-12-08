<%@ Page Async="true" Title="Search" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="university_search._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="w-100 d-flex flex-column flex-md-row gap-2 align-items-center justify-content-between">
        <!-- Search by Name -->
        <asp:Panel ID="pnlSearchName" runat="server" DefaultButton="btnSearchName">
            <div class="form-group d-flex gap-2">
                <asp:TextBox 
                    runat="server" 
                    ID="txtName" 
                    Placeholder="Search university..." 
                    CssClass="form-control" 
                    aria-label="Search by university name">
                </asp:TextBox>
                <asp:Button 
                    ID="btnSearchName" 
                    runat="server" 
                    Text="Search" 
                    CssClass="btn btn-primary" 
                    OnClick="btnSearchName_Click" />
            </div>
        </asp:Panel>

        <!-- Search by Country -->
        <asp:Panel ID="pnlSearchCountry" runat="server" DefaultButton="btnSearchCountry">
            <div class="form-group d-flex gap-2">
                <asp:TextBox 
                    runat="server" 
                    ID="txtCountry" 
                    Placeholder="Search by country..." 
                    CssClass="form-control" 
                    aria-label="Search by country">
                </asp:TextBox>
                <asp:Button 
                    ID="btnSearchCountry" 
                    runat="server" 
                    Text="Search" 
                    CssClass="btn btn-primary" 
                    OnClick="btnSearchCountry_Click" />
            </div>
        </asp:Panel>
    </div>

    <!-- Mensaje de error -->
    <asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false"></asp:Label>

    <!-- Tabla responsiva -->
    <div class="table-responsive">
        <asp:GridView 
            ID="gvUniversities" 
            runat="server" 
            CssClass="table table-striped table-bordered mt-4" 
            AutoGenerateColumns="False">
            <Columns>
                <asp:TemplateField HeaderText="Flag">
                    <HeaderStyle CssClass="align-middle text-center" />
                    <ItemStyle CssClass="align-middle text-center" />
                    <ItemTemplate>
                        <img src='<%# $"https://flagsapi.com/{Eval("alpha_two_code")}/flat/64.png" %>' 
                            alt='<%# Eval("country") %>' 
                            class="img-fluid" 
                            style="max-width: 64px;" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="country" HeaderText="Country">
                    <HeaderStyle CssClass="align-middle text-center" />
                    <ItemStyle CssClass="align-middle text-center" />
                </asp:BoundField>

                <asp:TemplateField HeaderText="State/Province">
                    <HeaderStyle CssClass="align-middle text-center" />
                    <ItemStyle CssClass="align-middle text-center" />
                    <ItemTemplate>
                        <%# Eval("state") ?? "N/A" %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="name" HeaderText="Name">
                    <HeaderStyle CssClass="align-middle text-center" />
                    <ItemStyle CssClass="align-middle text-center" />
                </asp:BoundField>

                <asp:TemplateField HeaderText="Domains">
                    <HeaderStyle CssClass="align-middle text-center" />
                    <ItemStyle CssClass="align-middle text-center" />
                    <ItemTemplate>
                        <asp:Repeater ID="rptDomainLinks" runat="server" DataSource='<%# Eval("DomainLinks") %>'>
                            <ItemTemplate>
                                <a href='<%# Eval("Value") %>' target="_blank" class="text-decoration-none">
                                    <%# Eval("Key") %>
                                </a><br />
                            </ItemTemplate>
                        </asp:Repeater>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
