/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    cl_panels.lua
    
---------------------------------------------------------------------------*/

local FrameColor = Color( 55, 15, 15, 255 )

net.Receive( "show_help", function()
	--HelpMenu()
	HelpPanel()
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

function HelpPanel()
    local startTime = SysTime()

    local frame = vgui.Create( "DFrame" )
    frame:SetSize( ScrW() * 0.5, ScrH() * 0.5 )
    frame:Center()
    frame:SetTitle( "GhostHunt - Made by WolfKnight" )
	frame:SetVisible( true )
    frame:MakePopup()
	frame:SetDraggable( false )

    function frame:Paint()
        Derma_DrawBackgroundBlur( frame, startTime )
        surface.SetDrawColor( FrameColor )
        surface.DrawRect( 0, 0, frame:GetWide(), frame:GetTall() )
    end
	
	local sheet = vgui.Create( "DPropertySheet", frame )
	sheet:Dock( FILL )
	sheet.Paint = function()
		-- surface.SetDrawColor( Color( FrameColor.r+60, FrameColor.g+60, FrameColor.b+60 ) )
        -- surface.DrawRect( 0, 0, sheet:GetWide(), sheet:GetTall() )
		for k, v in pairs(sheet.Items) do
			if (!v.Tab) then continue end
			
			if ( sheet:GetActiveTab() == v.Tab ) then 
				v.Tab.Paint = function(self,w,h)
					draw.RoundedBox(0, 0, 0, w, h, Color( FrameColor.r+20, FrameColor.g+20, FrameColor.b+20 ) )
				end
			else
				v.Tab.Paint = function(self,w,h)
					draw.RoundedBox(0, 0, 0, w, h, Color( FrameColor.r+10, FrameColor.g+10, FrameColor.b+10 ) )
				end
			end 
		end
	end 
	
	local help_panel = vgui.Create( "DPanel", sheet )
	help_panel:Dock( FILL )
	help_panel.Paint = function()
		surface.SetDrawColor( Color( FrameColor.r+20, FrameColor.g+20, FrameColor.b+20 ) )
        surface.DrawRect( 0, 0, help_panel:GetWide(), help_panel:GetTall() )
	end 
	sheet:AddSheet( "Basic Help", help_panel, "icon16/user.png", false, false, "Basic help and tips." )
	
	local cl_settings_panel = vgui.Create( "DPanel", sheet )
	cl_settings_panel:Dock( FILL )
	cl_settings_panel.Paint = function()
		surface.SetDrawColor( Color( FrameColor.r+20, FrameColor.g+20, FrameColor.b+20 ) )
        surface.DrawRect( 0, 0, cl_settings_panel:GetWide(), cl_settings_panel:GetTall() )
	end 
	sheet:AddSheet( "Client Settings", cl_settings_panel, "icon16/cog.png", false, false, "Clientside settings." )
	
	if ( LocalPlayer():IsAdmin() ) then 
		local sv_settings_panel = vgui.Create( "DPanel", sheet )
		sv_settings_panel:Dock( FILL )
		sv_settings_panel.Paint = function()
			surface.SetDrawColor( Color( FrameColor.r+20, FrameColor.g+20, FrameColor.b+20 ) )
			surface.DrawRect( 0, 0, sv_settings_panel:GetWide(), sv_settings_panel:GetTall() )
		end 
		sheet:AddSheet( "Server Settings", sv_settings_panel, "icon16/cog.png", false, false, "Server settings." )
	end 
	
end