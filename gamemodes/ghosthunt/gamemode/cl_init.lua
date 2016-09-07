/*---------------------------------------------------------------------------
    
    Ghost Hunt
    Made By: DJH4698
    cl_init.lua
    
---------------------------------------------------------------------------*/

include( "shared.lua" )

function GM:Initialize()
    surface.CreateFont( "GH_HudLabel", { font = "Coolvetica", size = 20, weight = 0, antialias = true, shadow = false } )
end


function GM:HUDShouldDraw( name )
    if ( name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" or name == "CHudCrosshair" ) then
        return false
    end
    return true
end


function HUDPaint()

    if !( LocalPlayer() and LocalPlayer():Alive() ) then return end
    if !( LocalPlayer():GetActiveWeapon() and IsValid( LocalPlayer():GetActiveWeapon() ) ) then return end

    -- Define the local variables used for the hud
    local ply = LocalPlayer()
    local HP = math.Clamp( LocalPlayer():Health(), 0, 100 )
    local WEAPON_NAME = LocalPlayer():GetActiveWeapon():GetPrintName()
    local MAT_VIGNETTE = Material( "overlays/vignette01" )
    local color_flash = math.abs( math.sin( CurTime() ) ) 

    -- Draw the vignette effect, make's it more spoo-o-oooo-ky
    surface.SetMaterial( MAT_VIGNETTE )
    surface.SetDrawColor( 255, 255, 255, 150 )
    surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )

    if WEAPON_NAME == "#GMOD_Camera" then return end
    
    -- Draw the basic dot crosshair 
    surface.DrawCircle( ScrW() / 2, ScrH() / 2, 1, Color( 255, 255, 255, 120 ) )

    -- Draw the HUD box :D
    draw.RoundedBox( 8, 30, ( ScrH() - ScrH() ) + 18, 250, 110, Color( 20, 20, 20, 180 ) )
    
    -- Draw the health bar with it's back
    draw.RoundedBox( 4, 40, ( ScrH() - ScrH() ) + 28, 230, 18, Color( 20, 20, 20, 255 ) )
    draw.RoundedBox( 4, 40, ( ScrH() - ScrH() ) + 28, HP * 2.3, 18, Color( ( color_flash * 255 ) * 2, 0, 0, 255 ) )

    -- Draw the player's name and team
    draw.WordBox( 8, 40, ( ScrH() - ScrH() ) + 65, ply:Nick(), "GH_HudLabel", Color( 255, 255, 255, 0 ), Color( 255, 255, 255, 255 ) )
    draw.SimpleText( "Ghost Hunter", "GH_HudLabel", 95, ( ScrH() - ScrH() ) + 107, Color( 255, 255, 255, 255 ), 1, 1 )

end
hook.Add( "HUDPaint", "Paint", HUDPaint )


function GM:PostDrawViewModel( vm, ply, weapon )

    if ( weapon.UseHands || !weapon:IsScripted() ) then

        local hands = LocalPlayer():GetHands()
        if ( IsValid( hands ) ) then hands:DrawModel() end

    end

end