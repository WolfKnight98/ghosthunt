/*---------------------------------------------------------------------------
    
    Ghost Hunt
    Made By: WolfKnight
    init.lua
    
---------------------------------------------------------------------------*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include( "shared.lua" )
include( "resource.lua" )


-- ConVar Settings
CreateConVar( "gh_flashlight", "1", 256, "Toggles player's flashlight on or off.\n      0 = off, 1 = on" )
CreateConVar( "gh_walkspeed", "120", 256, "Set the player's walkspeed." )
CreateConVar( "gh_runspeed", "210", 256, "Set the player's runspeed." )
CreateConVar( "gh_pvpdamage", "1", 256, "Allow player vs player damage.\n      0 = no, 1 = yes" )

cvars.AddChangeCallback( "gh_flashlight", function( convar_name, value_old, value_new ) 
    for k, v in pairs( player.GetAll() ) do
        if value_new == "1" then v:AllowFlashlight( true )    
        elseif value_new == "0" then v:AllowFlashlight( false ) end
end end )

cvars.AddChangeCallback( "gh_walkspeed", function( convar_name, value_old, value_new ) 
    for k, v in pairs( player.GetAll() ) do
        v:SetWalkSpeed( value_new )
end end )

cvars.AddChangeCallback( "gh_runspeed", function( convar_name, value_old, value_new ) 
    for k, v in pairs( player.GetAll() ) do
        v:SetRunSpeed( value_new )
end end )

cvars.AddChangeCallback( "gh_pvpdamage", function( convar_name, value_old, value_new )
	if ( tonumber(value_new, 10) > 1 ) then GetConVar( "gh_pvpdamage" ):SetBool( true ) end 
	if ( tonumber(value_new, 10) < 0 ) then GetConVar( "gh_pvpdamage" ):SetBool( false ) end 
end )


local function PlayerSpeed( ply )
    timer.Simple( 0.2, function()
        local gh_walkspeed = GetConVar( "gh_walkspeed" )
        local gh_runspeed = GetConVar( "gh_runspeed" )
        GAMEMODE:SetPlayerSpeed( ply, gh_walkspeed:GetInt(), gh_runspeed:GetInt() )
    end )
end
hook.Add( "PlayerInitialSpawn", "GHPlayerSpeed", PlayerSpeed )
hook.Add( "PlayerSpawn", "GHPlayerSpeed", PlayerSpeed )


-- Runs the first time a player spawns
function GM:PlayerInitialSpawn( ply )

    ply:SetTeam( 1 )

end


-- Runs every time a player respawns 
function GM:PlayerSpawn( ply ) 

    if ply:Team() == 1 then

        local gh_flashlight = GetConVar( "gh_flashlight" )
        --local gh_walkspeed = GetConVar( "gh_walkspeed" )
        --local gh_runspeed = GetConVar( "gh_runspeed" )

    -- Health and armour 
        ply:SetHealth( 100 )
        ply:SetArmor( 0 )

    -- Misc stuff
        ply:SetGravity( 1 )
        --ply:SetWalkSpeed( gh_walkspeed:GetInt() )
        --ply:SetRunSpeed( gh_runspeed:GetInt() )
        ply:AllowFlashlight( gh_flashlight:GetBool() )
        ply:SetModel( table.Random( ghmodels ) )

    -- Give sweps/weapons
        ply:StripWeapons()
        ply:Give( "weapon_crowbar" )
        ply:Give( "weapon_physcannon" )
        ply:Give( "weapon_medkit" )
        ply:Give( "gmod_camera" )

    end

    ply:SetupHands()
    
end


function GM:PlayerSetHandsModel( ply, ent )

    local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
    local info = player_manager.TranslatePlayerHands( simplemodel )
    if ( info ) then
        ent:SetModel( info.model )
        ent:SetSkin( info.skin )
        ent:SetBodyGroups( info.body )
    end

end


function GM:PlayerShouldTakeDamage( ply, attacker )
		
	-- Always allow damage in singleplayer
	if ( game.SinglePlayer() ) then return true end 
	
	-- Not allow player vs player damage
	if ( ply:IsPlayer() and attacker:IsPlayer() ) then 
		return GetConVar( "gh_pvpdamage" ):GetBool()
	end 
	
	-- Always allow damage to be taken
	return true
end 

hook.Add( "PlayerNoClip", "DisableNoclip", function( ply ) 
    return ply:IsAdmin() 
end )