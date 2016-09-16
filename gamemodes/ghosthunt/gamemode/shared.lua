/*---------------------------------------------------------------------------
    
    Ghost Hunt
    Made By: WolfKnight
    shared.lua
    
---------------------------------------------------------------------------*/

GM.Name = "Ghost Hunt"
GM.Author = "WolfKnight"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Version = "0.05"

DeriveGamemode( "base" )

if ( CLIENT ) then resource.AddFile( "materials/overlays/vignette01.vmt" ) resource.AddFile( "materials/overlays/vignette01.vtf" ) end 

TEAM_HUNTERS = 1
team.SetUp( TEAM_HUNTERS, "Hunters", Color( 255, 255, 255, 255 ) )

ghmodels = {
    model1 = "models/player/Group01/male_01.mdl",
    model2 = "models/player/Group01/male_02.mdl",
    model3 = "models/player/Group01/male_03.mdl",
    model4 = "models/player/Group01/male_04.mdl",
    model5 = "models/player/Group01/male_05.mdl",
    model6 = "models/player/Group01/male_06.mdl",
    model7 = "models/player/Group01/male_07.mdl",
    model8 = "models/player/Group01/male_08.mdl",
    model9 = "models/player/Group01/male_09.mdl",
    model10 = "models/player/Group01/Female_01.mdl",
    model11 = "models/player/Group01/Female_02.mdl",
    model12 = "models/player/Group01/Female_03.mdl",
    model13 = "models/player/Group01/Female_04.mdl",
    model14 = "models/player/Group01/Female_06.mdl"
}

--
-- make fonts n shit 
-- 
function GM:Initialize()
	if ( CLIENT ) then 
		surface.CreateFont( "GH_HudLabel", { font = "Coolvetica", size = 20, weight = 0, antialias = true, shadow = false } )
	end 
	
	if ( SERVER ) then 
		local map = game.GetMap()
		local SupportedMaps = { "gm_ghosthunt_2", "gm_ghosthunt_3" }
		
		if ( table.HasValue( SupportedMaps, map ) ) then 
			MAP_SUPPORTED = true
		else	
			MAP_SUPPORTED = false
			
			timer.Create( "NotSupported", 10, 1, function()
				broadcast( "This map is not supported, contact the developer of this gamemode.", 3 )
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