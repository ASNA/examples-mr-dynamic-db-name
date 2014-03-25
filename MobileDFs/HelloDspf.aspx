<%@ Page Language="AVR" AutoEventWireup="false" CodeFile="HelloDspf.aspx.vr" Inherits="HelloDspf" MasterPageFile="~/Themes/Current/MasterPage.master" %>
<%@ Register TagPrefix="mdf" Assembly="ASNA.Monarch.WebDspF, Version=11.0.53.0, Culture=neutral, PublicKeyToken=71de708db13b26d3" Namespace="ASNA.Monarch.WebDspF" %>

<%--
    What you get with this Mobile RPG Application template:

    1. This source file that contains the DDS to be used by a RPG ILE program in the IBM i
    2. In the library you selected in the Wizard, in file QRPGLESRC, a member named HELLORPG with this as contents:        
    
       0001.00 FHELLODSPF CF   E             WORKSTN Handler('MOBILERPG')            
       0002.00                                                                       
       0003.00 C*********************************************************************
       0004.00 C* Use the RPG-Cycle to display the main menu, get out on IN03        
       0005.00 C*********************************************************************
       0006.00 C                   ExFmt     HomeMenu                                
       0007.00 C                   Select                                            
       0008.00 C                   When      *In03                                   
       0009.00 C                   Eval      *InLR = *On                             
       0010.00 C                   Return                                            
       0011.00 C                   EndSl                                             

    3. The HELLORPG compiled program.
    4. You are ready to run the mobile application from within Visual Studio 
       by pressing F5. (Visual Studio provides its own intrinsic Web server so you don't need 
       to worry about Web servers until you're ready to the deploy for others to use.)
--%>

<asp:Content runat="server" ContentPlaceHolderID="HeaderPH">
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="AppBody">
    <%-- Invisible DdsFile control --%>
    <mdf:ddsfile ID="Ddsfile1" runat="server" BannerStyle="Invisible" DisplayErrorMessages="False" SrcDdsCcsid="37" PopUpWindows="false" SetDefaultFocus="false" />

    <%-- Home Record: Home Navigation bar and a simple label on the Page --%>
    <mdf:DdsRecord id="_HomeMenu" runat="server" style="position: relative;" Alias="HomeMenu" CssClass="DdsRecord" NavigationBarControlID="HomeNavBar" FuncKeys="F3 03;" EraseFormats="*ALL" >

        <mdf:DdsBar ID="HomeNavBar" runat="server" CssClass="DdsBar" >
            <mdf:DdsBarSegment ID="DdsBarSegment1" runat="server" Alignment="Left">
                <mdf:DdsButton ID="DdsButton1" ButtonStyle="Button" runat="server" CssClass="NavButton" AidKey="F3" Text="End" />
            </mdf:DdsBarSegment>
            <mdf:DdsBarSegment ID="DdsBarSegment2" runat="server" Alignment="Center">
                <span class="PanelTitle" >Mr Hello </span>
            </mdf:DdsBarSegment>

            <mdf:DdsBarSegment ID="rightFiller" runat="server" Alignment="Right">
            </mdf:DdsBarSegment>
        </mdf:DdsBar>

        Hello, world!
        <br />
        <br />
        <br />
        <br />
        <br/>
    </mdf:DdsRecord>

</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="PageScriptPH"  >
    <script type="text/javascript" >
    </script>  
</asp:Content>
