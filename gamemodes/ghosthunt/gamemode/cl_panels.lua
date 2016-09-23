/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    cl_panels.lua
    
---------------------------------------------------------------------------*/

net.Receive( "show_help", function()
	HelpMenu()
end )

function HelpMenu()
	local startTime = SysTime()

    local frame = vgui.Create( "DFrame" )
    frame:SetSize( ScrW() * 0.7, ScrH() * 0.7 )
    frame:SetTitle( "" )
	frame:SetVisible( true )
	frame:SetDraggable( false )
	frame:Center()
    frame:MakePopup()
	
	local panel = vgui.Create( "DPanel", frame )
	panel:SetPos( 10, 20 )
	panel:SetSize( frame:GetWide()-20, frame:GetTall()-30 )
	
	local tab_sheet = vgui.Create( "DPropertySheet", panel )
	tab_sheet:SetSize( panel:GetWide(), panel:GetTall() )
	
	local settings = vgui.Create( "DPanelList", panel )	
	settings:EnableHorizontal(false)
	settings:EnableVerticalScrollbar(true)
	
	tab_sheet:AddSheet( "Settings", settings, "icon16/cog.png", false, false, "Clientside settings" )
end 