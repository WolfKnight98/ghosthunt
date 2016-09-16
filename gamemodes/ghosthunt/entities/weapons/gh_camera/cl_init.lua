include('shared.lua')

SWEP.PrintName			= "Camcorder"
SWEP.Slot				= 1
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

local camcorder_visor1 = surface.GetTextureID ( "overlays/camcorder_visor1")
local camcorder_visor2 = surface.GetTextureID ( "overlays/camcorder_visor2")
local camcorder_rec = surface.GetTextureID ( "overlays/camcorder_rec")
local camcorder_hd = surface.GetTextureID ( "overlays/camcorder_hd")
local camcorder_battery = surface.GetTextureID ( "overlays/camcorder_battery")
local vignette = surface.GetTextureID ( "overlays/cc_vignette")

function SWEP:DrawHUD()
	local cc_darka = {
	[ "$pp_colour_addr" ] = 0.275,
	[ "$pp_colour_addg" ] = 0.352,
	[ "$pp_colour_addb" ] = 0.313,
	[ "$pp_colour_brightness" ] = -0.45,
	[ "$pp_colour_contrast" ] = 1.35,
	[ "$pp_colour_colour" ] = 0.50,
	[ "$pp_colour_mulr" ] = 0.0,
	[ "$pp_colour_mulg" ] = 0.0,
	[ "$pp_colour_mulb" ] = 0.0
	}
	
	DrawColorModify( cc_darka )
	
	local w,h = ScrW(),ScrH()
	surface.SetDrawColor ( 255, 255, 255, 255 )
	surface.SetTexture ( vignette )
	surface.DrawTexturedRect ( 0,0, w, h )

	surface.SetDrawColor ( 255, 255, 255, 255 )
	surface.SetTexture ( camcorder_visor1 )
	surface.DrawTexturedRect ( w / 2 - 512, h / 2 - 256, 1024, 512 )
	
	surface.SetDrawColor ( 255, 255, 255, 255 )
	surface.SetTexture ( camcorder_visor2 )
	surface.DrawTexturedRect ( 0, 0, w, h )
	
	surface.SetDrawColor ( 255, 255, 255, 255 )
	surface.SetTexture ( camcorder_rec )
	surface.DrawTexturedRect ( w * 0.84, h * 0.14, 128, 64 )
	
	surface.SetDrawColor ( 255, 255, 255, 255 )
	surface.SetTexture ( camcorder_hd )
	surface.DrawTexturedRect ( w * 0.08, h * 0.79, 128, 128 )
		
	surface.SetDrawColor ( 255, 255, 255, 255 )
	surface.SetTexture ( camcorder_battery )
	surface.DrawTexturedRect ( w * 0.08, h * 0.14, 128, 64 )
end