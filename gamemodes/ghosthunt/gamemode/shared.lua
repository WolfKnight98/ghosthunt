/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    shared.lua
    
---------------------------------------------------------------------------*/

GM.Name = "GhostHunt"
GM.Author = "WolfKnight"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Version = "1.00"

DeriveGamemode( "base" )

-- Sends the client the content pack from the workshop
if ( SERVER ) then resource.AddWorkshop( "765482742" ) end 

TEAM_HUNTERS = 1
team.SetUp( TEAM_HUNTERS, "Hunters", Color( 255, 255, 255, 255 ) )

--
-- make fonts n shit 
-- 
function GM:Initialize()
	if ( CLIENT ) then 
		surface.CreateFont( "GH_HudLabel", { font = "Coolvetica", size = 20, weight = 0, antialias = true, shadow = false } )
	end 
	
	if ( SERVER ) then 
		local map = game.GetMap()
		local SupportedMaps = { "gm_ghosthunt_2", "gm_ghosthunt_3", "gm_paranormal" }
		
		if ( table.HasValue( SupportedMaps, map ) ) then 
			MAP_SUPPORTED = true
		else	
			MAP_SUPPORTED = false
			
			timer.Create( "NotSupported", 10, 1, function()
				broadcast( "This map is not supported, contact the developer of this gamemode or the map creator.", 1 )
			end )
		end 
	end 
end

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

function broadcast( str_msg, int_repeat )
	for i = 1, int_repeat do 
		for k, ply in pairs( player.GetAll() ) do 
			ply:ChatPrint( "[GHOSTHUNT] " .. str_msg )
		end 
	end 
end 