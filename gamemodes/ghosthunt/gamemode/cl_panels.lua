/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    cl_panels.lua
    
---------------------------------------------------------------------------*/

local FrameColor = Color( 55, 15, 15, 155 )
local wep, pl

net.Receive( "show_help", function()
    HelpPanel()
end )

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
		surface.SetDrawColor( Color( FrameColor.r+20, FrameColor.g+20, FrameColor.b+20 ) )
        surface.DrawRect( 0, 20, sheet:GetWide(), sheet:GetTall() )
		for k, v in pairs( sheet.Items ) do
			if ( !v.Tab ) then continue end
			
			if ( sheet:GetActiveTab() == v.Tab ) then 
				v.Tab.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, Color( FrameColor.r+20, FrameColor.g+20, FrameColor.b+20, 255 ) )
				end
			else
				v.Tab.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, Color( FrameColor.r+10, FrameColor.g+10, FrameColor.b+10, 255 ) )
				end
			end 
		end
	end 
	
	
	--
	-- Help section
	--
	local help_panel = vgui.Create( "DPanel", sheet )
	help_panel:Dock( FILL )
	help_panel.Paint = function()
		surface.SetDrawColor( Color( FrameColor.r+20, FrameColor.g+20, FrameColor.b+20 ) )
        surface.DrawRect( 0, 0, help_panel:GetWide(), help_panel:GetTall() )
	end 
	
	
	sheet:AddSheet( "Basic Help", help_panel, "icon16/user.png", false, false, "Basic help and tips." )
	
	
	--
	-- Clientside settings section
	--
	local cl_settings_panel = vgui.Create( "DPanelList", sheet )
	cl_settings_panel:Dock( FILL )
	cl_settings_panel:SetPadding( 20 )
	cl_settings_panel:SetSpacing( 10 )
	cl_settings_panel.Paint = function()
		surface.SetDrawColor( Color( FrameColor.r+20, FrameColor.g+20, FrameColor.b+20 ) )
        surface.DrawRect( 0, 0, cl_settings_panel:GetWide(), cl_settings_panel:GetTall() )
	end 
	
	local draw_crosshair = vgui.Create( "DCheckBoxLabel", cl_settings_panel )
	draw_crosshair:SetText( "Draw crosshair?" )
	draw_crosshair:SetValue( GAMEMODE.DrawCrosshair:GetInt() )
	draw_crosshair:SetConVar( "gh_cl_drawcrosshair" )
	cl_settings_panel:AddItem( draw_crosshair )
	
	local draw_vignette = vgui.Create( "DCheckBoxLabel", cl_settings_panel )
	draw_vignette:SetText( "Draw vignette effect?" )
	draw_vignette:SetValue( GAMEMODE.DrawVignette:GetInt() )
	draw_vignette:SetConVar( "gh_cl_drawvignette" )
	cl_settings_panel:AddItem( draw_vignette )
	
	local draw_stam_flash = vgui.Create( "DCheckBoxLabel", cl_settings_panel )
	draw_stam_flash:SetText( "Should the stamina bar flash?" )
	draw_stam_flash:SetValue( GAMEMODE.ShouldStaminaFlash:GetInt() )
	draw_stam_flash:SetConVar( "gh_cl_staminaflash" )
	cl_settings_panel:AddItem( draw_stam_flash )
	
	local draw_sanity_effect = vgui.Create( "DCheckBoxLabel", cl_settings_panel )
	draw_sanity_effect:SetText( "Enable the sanity system?" )
	draw_sanity_effect:SetValue( GAMEMODE.SanityEffectAllowed:GetInt() )
	draw_sanity_effect:SetConVar( "gh_cl_sanityeffect" )
	cl_settings_panel:AddItem( draw_sanity_effect )
	
	local beta_hud = vgui.Create( "DCheckBoxLabel", cl_settings_panel )
	beta_hud:SetText( "Try the new beta hud (WARNING: EXPERIMENTAL)" )
	beta_hud:SetValue( GAMEMODE.BetaHud:GetInt() )
	beta_hud:SetConVar( "gh_cl_betahud" )
	cl_settings_panel:AddItem( beta_hud )
	
	sheet:AddSheet( "Client Settings", cl_settings_panel, "icon16/cog.png", false, false, "Clientside settings." )
	
	
	--
	-- Admin serverside settings section
	--
	if ( LocalPlayer():IsAdmin() ) then 
		local sv_settings_panel = vgui.Create( "DPanelList", sheet )
		sv_settings_panel:Dock( FILL )
		sv_settings_panel:SetPadding( 20 )
		sv_settings_panel:SetSpacing( 10 )
		sv_settings_panel.Paint = function()
			surface.SetDrawColor( Color( FrameColor.r+20, FrameColor.g+20, FrameColor.b+20 ) )
			surface.DrawRect( 0, 0, sv_settings_panel:GetWide(), sv_settings_panel:GetTall() )
		end 
		
		local flash = vgui.Create( "DCheckBoxLabel", sv_settings_panel )
		flash:SetText( "Allow flashlights?" )
		flash:SetValue( GetConVar( "gh_flashlight" ):GetInt() )
		flash:SetConVar( "gh_flashlight" )
		sv_settings_panel:AddItem( flash ) 
		
		local pvpdam = vgui.Create( "DCheckBoxLabel", sv_settings_panel )
		pvpdam:SetText( "Allow player vs. player damage?" )
		pvpdam:SetValue( GetConVar( "gh_pvpdamage" ):GetInt() )
		pvpdam:SetConVar( "gh_pvpdamage" )
		sv_settings_panel:AddItem( pvpdam )
		
		local stam = vgui.Create( "DCheckBoxLabel", sv_settings_panel )
		stam:SetText( "Enable the stamina system?" )
		stam:SetValue( GetConVar( "gh_stamina" ):GetInt() )
		stam:SetConVar( "gh_stamina" )
		sv_settings_panel:AddItem( stam )
		
		local punt = vgui.Create( "DCheckBoxLabel", sv_settings_panel )
		punt:SetText( "Allow players to shoot props with the gravity gun?" )
		punt:SetValue( GetConVar( "gh_allowgravpunt" ):GetInt() )
		punt:SetConVar( "gh_allowgravpunt" )
		sv_settings_panel:AddItem( punt )
		
		local walkspeed = vgui.Create( "DNumSlider", sv_settings_panel )
		walkspeed:SetText( "Set the global player's walkspeed." )
		walkspeed:SetMin( 10 )
		walkspeed:SetMax( 300 )
		walkspeed:SetValue( GetConVar( "gh_walkspeed" ):GetInt() )
		walkspeed:SetConVar( "gh_walkspeed" )
		sv_settings_panel:AddItem( walkspeed )
		
		local runspeed = vgui.Create( "DNumSlider", sv_settings_panel )
		runspeed:SetText( "Set the global player's runspeed." )
		runspeed:SetMin( 120 )
		runspeed:SetMax( 600 )
		runspeed:SetValue( GetConVar( "gh_runspeed" ):GetInt() )
		runspeed:SetConVar( "gh_runspeed" )
		sv_settings_panel:AddItem( runspeed )
		
		local playerlist = vgui.Create( "DComboBox", sv_settings_panel )
		playerlist:SetValue( "Select a player" )
		for k, v in ipairs( player.GetAll() ) do playerlist:AddChoice( v:GetName() ) end 
		playerlist.OnSelect = function( panel, index, value )
			for k, v in ipairs( player.GetAll() ) do 
				if ( v:GetName() == value ) then pl = v end 
			end 
		end
		sv_settings_panel:AddItem( playerlist )
		
		local weaponlist = vgui.Create( "DComboBox", sv_settings_panel )
		weaponlist:SetValue( "Select a weapon" )
		for k, v in ipairs( weapons.GetList() ) do weaponlist:AddChoice( v.ClassName ) end 
		weaponlist.OnSelect = function( panel, index, value )
			wep = value
			net.Start( "spawn_wep" ) 
				net.WriteEntity( pl ) 
				net.WriteString( wep ) 
			net.SendToServer()
		end
		sv_settings_panel:AddItem( weaponlist )
		
		sheet:AddSheet( "Server Settings", sv_settings_panel, "icon16/cog.png", false, false, "Server settings." )
	end 
	
end