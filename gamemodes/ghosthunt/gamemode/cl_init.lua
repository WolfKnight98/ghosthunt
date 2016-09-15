/*---------------------------------------------------------------------------
    
    Ghost Hunt
    Made By: WolfKnight
    cl_init.lua
    
---------------------------------------------------------------------------*/

include( "shared.lua" )

local detector_state = "0"
local smoothHealth = 100
local smooth = 1
local reverse_smooth = false
local ghost_effect_duration = 10
local MAT_VIGNETTE = Material( "overlays/vignette01" )
local ScrH = ScrH()
local ScrW = ScrW()

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
	local GLOW = 55 + 200 * ( math.abs( math.sin( CurTime() * 1.5 ) ) )
	local STAMINA = LocalPlayer():GetNWInt( "stamina" )
	local NAME = LocalPlayer():Nick()
	smoothHealth = Lerp( 10 * FrameTime(), smoothHealth, HP )
	
    -- Draw the vignette effect, make's it more spoo-o-oooo-ky
    surface.SetMaterial( MAT_VIGNETTE )
    surface.SetDrawColor( 255, 255, 255, 120 )
    surface.DrawTexturedRect( 0, 0, ScrW, ScrH )

	-- Stop drawing the main HUD if we have the camera equipped
    if WEAPON_NAME == "#GMOD_Camera" then return end
    
    -- Draw the basic dot crosshair 
    surface.DrawCircle( ScrW / 2, ScrH / 2, 1, Color( 255, 255, 255, 120 ) )

    -- Draw the HUD box :D
    draw.RoundedBox( 8, 30, ( ScrH - ScrH ) + 18, 250, 110, Color( 20, 20, 20, 180 ) )
    
    -- Draw the health bar with it's back
    draw.RoundedBox( 4, 40, ( ScrH - ScrH ) + 28, 230, 18, Color( 20, 20, 20, 255 ) )
    draw.RoundedBox( 4, 40, ( ScrH - ScrH ) + 28, smoothHealth * 1.15, 18, Color( 255, 0, 0, 255 ) )
	
	if ( STAMINA ) then 
		-- Draw the stamina bar with it's background 
		draw.RoundedBox( 4, 40, ( ScrH - ScrH ) + 50, 230, 9, Color( 20, 20, 20, 255 ) )
		if ( STAMINA > 2 ) then draw.RoundedBox( 4, 40, ( ScrH - ScrH ) + 50, STAMINA * 2.3, 9, Color( 120, 240, 60, GLOW ) ) end 
	end 

    -- Draw the player's name and team
    draw.WordBox( 8, 32, ( ScrH - ScrH ) + 65, NAME, "GH_HudLabel", Color( 255, 255, 255, 0 ), Color( 255, 255, 255, 255 ) )
    draw.SimpleText( "Ghost Hunter", "GH_HudLabel", 87, ( ScrH - ScrH ) + 107, Color( 255, 255, 255, 255 ), 1, 1 )
	
	draw.SimpleText( detector_state, "GH_HudLabel", ScrW/2, ( ScrH - ScrH ) + 130, Color( 255, 255, 255, 255 ), 1, 1 )
end

--
-- Draws the PP effects on the screen when near a ghost
--
function DrawGhostieEffects()
	if !( timer.Exists( "reverse_smooth" ) ) then 
		timer.Create( "reverse_smooth", 8, 1, function()
			reverse_smooth = true
		end )
	end
	
	if ( reverse_smooth ) then 
		smooth = Lerp( 20 * FrameTime(), smooth, 1 )
	else
		smooth = Lerp( 5 * FrameTime(), smooth, 0.2 )
	end 
	
	LocalPlayer():ChatPrint( smooth )
	DrawSobel( smooth )
	DrawMotionBlur( 0.2, 0.8, 0.01 )
end 

function NewDrawGhostieEffects()
	local ply = LocalPlayer()
	
	
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
-- Gets the detector state from the server
--
net.Receive( "detector_state", function()
	detector_state = net.ReadString()
end )

--
-- Controls the ghostie effects 
--
net.Receive( "ghostie_effects", function()		
	if ( timer.Exists( "StopGhostieEffects" ) ) then return end
	
	reverse_smooth = false
	
	hook.Add( "RenderScreenspaceEffects", "GhostieEffects", DrawGhostieEffects )
	timer.Create( "StopGhostieEffects", 10, 1, function()
		hook.Remove( "RenderScreenspaceEffects", "GhostieEffects" )
	end )
	
	smooth = 1
end )