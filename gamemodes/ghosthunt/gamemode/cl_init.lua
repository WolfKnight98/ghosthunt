/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    cl_init.lua
    
---------------------------------------------------------------------------*/

include( "shared.lua" )
include( "cl_panels.lua" )

GM.DrawCrosshair = CreateClientConVar( "gh_cl_drawcrosshair", "0", true, false )
GM.DrawVignette = CreateClientConVar( "gh_cl_drawvignette", "1", true, false )
GM.ShouldStaminaFlash = CreateClientConVar( "gh_cl_staminaflash", "1", true, false )
GM.BetaHud = CreateClientConVar( "gh_cl_betahud", "0", true, false )

local DrawHasDetector = false 
local smoothHealth = 100
local MAT_VIGNETTE = Material( "overlays/vignette01" )
local width 
local height 

local ScrH = ScrH()
local ScrW = ScrW()
local surface = surface
local draw = draw

GM.ToHide = 
{
	"CHudHealth",
	"CHudBattery", 
	"CHudAmmo", 
	"CHudSecondaryAmmo", 
	"CHudCrosshair"
}

--
-- Decides what should be drawn from the original hud 
--
function GM:HUDShouldDraw( name )
    if ( table.HasValue( self.ToHide, name ) ) then
        return false
    end
    return true
end

-- 
-- The main HUD method 
--
function GM:HUDPaint()
    if !( LocalPlayer() and LocalPlayer():Alive() ) then return end
    if !( LocalPlayer():GetActiveWeapon() and IsValid( LocalPlayer():GetActiveWeapon() ) ) then return end

    -- Define the local variables used for the hud
    local HP          = math.Clamp( LocalPlayer():Health(), 0, 200 )
    local WEAPON_NAME = LocalPlayer():GetActiveWeapon():GetPrintName()
	local GLOW        = 55 + 200 * ( math.abs( math.sin( CurTime() * 1.5 ) ) )
	local STAMINA     = LocalPlayer():GetNWInt( "stamina" )
	local NAME        = LocalPlayer():Nick()
	smoothHealth      = Lerp( 10 * FrameTime(), smoothHealth, HP )
	
    -- Draw the vignette effect, make's it more spoo-o-oooo-ky
	if ( GAMEMODE.DrawVignette:GetBool() == true ) then 
		surface.SetMaterial( MAT_VIGNETTE )
		surface.SetDrawColor( 255, 255, 255, 120 )
		surface.DrawTexturedRect( 0, 0, ScrW, ScrH )
    end 
	
	-- Stop drawing the main HUD if we have the camera equipped
    if ( WEAPON_NAME == "Camcorder" ) then return end
    
    -- Draw the basic dot crosshair 
	if ( GAMEMODE.DrawCrosshair:GetBool() == true ) then 
		surface.DrawCircle( ScrW / 2, ScrH / 2, 1, Color( 255, 255, 255, 120 ) )
	end 
	
	if ( GAMEMODE.BetaHud:GetBool() == false ) then 
		-- Draw the HUD box :D
		draw.RoundedBox( 8, 30, ( ScrH - ScrH ) + 18, 250, 110, Color( 20, 20, 20, 180 ) )
		
		-- Draw the health bar with it's back
		draw.RoundedBox( 4, 40, ( ScrH - ScrH ) + 28, 230, 18, Color( 20, 20, 20, 255 ) )
		draw.RoundedBox( 4, 40, ( ScrH - ScrH ) + 28, smoothHealth * 1.15, 18, Color( 255, 0, 0, 255 ) )
		
		if ( STAMINA ) then 
			-- Draw the stamina bar with it's background 
			draw.RoundedBox( 4, 40, ( ScrH - ScrH ) + 50, 230, 9, Color( 20, 20, 20, 255 ) )
			
			if ( STAMINA > 2 ) then
				if ( GAMEMODE.ShouldStaminaFlash:GetBool() == true ) then 
					draw.RoundedBox( 4, 40, ( ScrH - ScrH ) + 50, STAMINA * 2.3, 9, Color( 120, 240, 60, GLOW ) )
				else 
					draw.RoundedBox( 4, 40, ( ScrH - ScrH ) + 50, STAMINA * 2.3, 9, Color( 120, 240, 60, 255 ) )
				end 
			end 
		end 

		-- Draw the player's name and team
		draw.WordBox( 8, 32, ( ScrH - ScrH ) + 65, NAME, "GH_HudLabel", Color( 255, 255, 255, 0 ), Color( 255, 255, 255, 255 ) )
		draw.SimpleText( "Ghost Hunter", "GH_HudLabel", 87, ( ScrH - ScrH ) + 107, Color( 255, 255, 255, 255 ), 1, 1 )
	else
		
	end 
	
	if ( DrawHasDetector ) then 
		draw.SimpleText( "You have the ghost detector.", "GH_HudLabel", ScrW - width, ScrH - height - 30, Color( 255, 255, 255, 255 ), 1, 1 )
	end 
end

--
-- Draws the PP effects on the screen when near a ghost
--
function DrawSanityEffect()
	DrawMotionBlur( 0.12, timer.TimeLeft( "StopSanityEffect" ) / 4, 0.01 )
end 

-- 
-- Some hand shit Garry added 
--
function GM:PostDrawViewModel( vm, ply, weapon )
    if ( weapon.UseHands || !weapon:IsScripted() ) then
        local hands = LocalPlayer():GetHands()
        if ( IsValid( hands ) ) then hands:DrawModel() end
    end
end

--
-- Controls the ghostie effects 
--
net.Receive( "sanity_effect", function()		
	if ( timer.Exists( "StopSanityEffect" ) ) then return end
	
	hook.Add( "RenderScreenspaceEffects", "SanityEffect", DrawSanityEffect )
	timer.Create( "StopSanityEffect", 10, 1, function()
		hook.Remove( "RenderScreenspaceEffects", "SanityEffect" )
	end )
end )

--
--
--
net.Receive( "has_detector", function()
	DrawHasDetector = true 
	surface.SetFont( "GH_HudLabel" )
	width, height = surface.GetTextSize( "You have the ghost detector." )
end )