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
GM.Version = "1.01"

DeriveGamemode( "base" )

-- Sends the client the content pack from the workshop
if ( SERVER ) then resource.AddWorkshop( "765482742" ) end 

-- Set up the player meta table variable 
PLAYER = FindMetaTable( "Player" )

-- Set up the teams 
TEAM_HUNTERS = 1
team.SetUp( TEAM_HUNTERS, "Hunters", Color( 255, 255, 255, 255 ) )

--
-- make fonts n shit 
-- 
function GM:Initialize()
	self.BaseClass.Initialize( self )
	
	if ( CLIENT ) then 
		surface.CreateFont( "GH_HudLabel", { font = "Coolvetica", size = 20, weight = 0, antialias = true, shadow = false } )
		surface.CreateFont( "GH_PanelTitle", { font = "Coolvetica", size = 48, weight = 0, antialias = true, shadow = false } )
		surface.CreateFont( "GH_PanelText", { font = "Arial", size = 18, weight = 0, antialias = true, shadow = false } )
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