/*---------------------------------------------------------------------------
    
    Ghost Hunt
    Made By: WolfKnight
    cl_init.lua
    
---------------------------------------------------------------------------*/

include( "shared.lua" )

local detector_state = "0"
local smoothHealth = 100
local smooth = 1

--
-- Decides what should be drawn from the original hud 
--
function GM:HUDShouldDraw( name )
    if ( name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" or name == "CHudCrosshair" ) then
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
    local HP = math.Clamp( LocalPlayer():Health(), 0, 200 )
    local WEAPON_NAME = LocalPlayer():GetActiveWeapon():GetPrintName()
    local MAT_VIGNETTE = Material( "overlays/vignette01" )
	local glow = 55 + 200 * ( math.abs( math.sin( CurTime() * 1.5 ) ) )
	smoothHealth = Lerp( 10 * FrameTime(), smoothHealth, HP )
	
    -- Draw the vignette effect, make's it more spoo-o-oooo-ky
    surface.SetMaterial( MAT_VIGNETTE )
    surface.SetDrawColor( 255, 255, 255, 120 )
    surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )

    if WEAPON_NAME == "#GMOD_Camera" then return end
    
    -- Draw the basic dot crosshair 
    surface.DrawCircle( ScrW() / 2, ScrH() / 2, 1, Color( 255, 255, 255, 120 ) )

    -- Draw the HUD box :D
    draw.RoundedBox( 8, 30, ( ScrH() - ScrH() ) + 18, 250, 110, Color( 20, 20, 20, 180 ) )
    
    -- Draw the health bar with it's back
    draw.RoundedBox( 4, 40, ( ScrH() - ScrH() ) + 28, 230, 18, Color( 20, 20, 20, 255 ) )
    draw.RoundedBox( 4, 40, ( ScrH() - ScrH() ) + 28, smoothHealth * 1.15, 18, Color( 255, 0, 0, 255 ) )
	
	if ( LocalPlayer():GetNWInt( "stamina" ) ) then 
		-- Draw the stamina bar with it's background 
		draw.RoundedBox( 4, 40, ( ScrH() - ScrH() ) + 50, 230, 9, Color( 20, 20, 20, 255 ) )
		draw.RoundedBox( 4, 40, ( ScrH() - ScrH() ) + 50, LocalPlayer():GetNWInt( "stamina" ) * 2.3, 9, Color( 120, 240, 60, glow ) )
	end 

    -- Draw the player's name and team
    draw.WordBox( 8, 32, ( ScrH() - ScrH() ) + 65, LocalPlayer():Nick(), "GH_HudLabel", Color( 255, 255, 255, 0 ), Color( 255, 255, 255, 255 ) )
    draw.SimpleText( "Ghost Hunter", "GH_HudLabel", 87, ( ScrH() - ScrH() ) + 107, Color( 255, 255, 255, 255 ), 1, 1 )
	
	net.Receive( "detector_state", function( len, ply )
		detector_state = net.ReadString()
	end )
	
	net.Receive( "ghostie_effects", function()		
		if ( timer.Exists( "StopGhostieEffects" ) ) then return end
		
		hook.Add( "RenderScreenspaceEffects", "GhostieEffects", DrawGhostieEffects )
		timer.Create( "StopGhostieEffects", 10, 1, function()
			hook.Remove( "RenderScreenspaceEffects", "GhostieEffects" )
		end )
		
		smooth = 1
	end )
	
	draw.SimpleText( detector_state, "GH_HudLabel", ScrW()/2, ( ScrH() - ScrH() ) + 130, Color( 255, 255, 255, 255 ), 1, 1 )
end

function DrawGhostieEffects()
	smooth = Lerp( 0.005, smooth, 0.2 )
	LocalPlayer():ChatPrint( smooth )
	DrawSobel( smooth )
	DrawMotionBlur( 0.2, 0.8, 0.01 )
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