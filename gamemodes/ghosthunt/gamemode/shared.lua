/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    shared.lua
	The Wolf of All Streets sends his regards. 
    
---------------------------------------------------------------------------*/

GM.Name = "GhostHunt"
GM.Author = "WolfKnight"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Version = "1.03"

DeriveGamemode( "base" )

-- Sends the client the content pack from the workshop
if ( SERVER ) then resource.AddWorkshop( "765482742" ) end 

-- Set up the player meta table variable 
PLAYER = FindMetaTable( "Player" )

-- Set up the teams 
TEAM_HUNTERS = 1
team.SetUp( TEAM_HUNTERS, "Hunters", Color( 255, 255, 255, 255 ) )

-- Add glowstick ammo type 
game.AddAmmoType( {
	name = "glowsticks",
	dmgtype = DMG_CRUSH,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	maxcarry = 5
} )

--
-- Runs when the gamemode is first loaded 
-- 
function GM:Initialize()
	self.BaseClass.Initialize( self )
	
	if ( CLIENT ) then 
		surface.CreateFont( "GH_HudLabel", { font = "Coolvetica", size = 20, weight = 0, antialias = true, shadow = false } )
		surface.CreateFont( "GH_PanelTitle", { font = "Coolvetica", size = 48, weight = 0, antialias = true, shadow = false } )
		surface.CreateFont( "GH_PanelHeader", { font = "Roboto", size = 22, antialias = true } )
		surface.CreateFont( "GH_PanelText", { font = "Trebuchet", size = 18, antialias = true } )
	end
end

--
-- Runs every time a player talks in chat 
--
function GM:OnPlayerChat( ply, text, teamchat, dead )
    local tab = {}
    
    if dead then
        table.insert( tab, Color( 255, 0, 0, 190 ) )
        table.insert( tab, "[DEAD] " )
    end
    
    if teamchat then 
        table.insert( tab, Color( 255, 0, 0, 190 ) )
        table.insert( tab, "[HUNTERS] " )
    end
    
    if ( IsValid( ply ) ) then
        table.insert( tab, ply )
    else
        table.insert( tab, Color( 150, 255, 150 ) )
        table.insert( tab, "Console" )
    end
    
    table.insert( tab, Color( 255, 255, 255, 190 ) )
    table.insert( tab, ": " .. text )
    
    chat.AddText( unpack( tab ) )

    return true 
end

--
-- Custom function for broadcasting messages (Hey ArmA devs, broadcast (SPOOKEH))
--
function broadcast( str_msg, int_repeat )
	for i = 1, int_repeat do 
		for k, ply in pairs( player.GetAll() ) do 
			ply:ChatPrint( "[GHOSTHUNT] " .. str_msg )
		end 
	end 
end 