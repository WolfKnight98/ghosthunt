/*---------------------------------------------------------------------------
    
    Ghost Hunt
    Made By: DJH4698
    shared.lua
    
---------------------------------------------------------------------------*/

GM.Name = "Ghost Hunt"
GM.Author = "DJH4698"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Version = "0.02b"

DeriveGamemode( "base" )

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
    model14 = "models/player/Group01/Female_06.mdl",
    model15 = "models/player/Group01/Female_07.mdl"
}

function GM:OnPlayerChat( ply, text, teamchat, dead )
    
    // chat.AddText( player, Color( 255, 255, 255 ), ": ", strText )
    
    local tab = {}
    
    if dead then
        table.insert( tab, Color( 255, 0, 0, 190 ) )
        table.insert( tab, "[ DEAD ] " )
    end
    
    if teamchat then 
        table.insert( tab, Color( 255, 0, 0, 190 ) )
        table.insert( tab, "[ HUNTERS ] " )
    end
    
    if ( IsValid( ply ) ) then
        table.insert( tab, ply )
    else
        table.insert( tab, Color( 150, 255, 150 ) )
        table.insert( tab, "Console" )
    end
    
    table.insert( tab, Color( 255, 0, 0, 190 ) )
    table.insert( tab, ": " .. text )
    
    chat.AddText( unpack( tab ) )

    return true
    
end