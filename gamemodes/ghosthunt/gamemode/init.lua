/*---------------------------------------------------------------------------
    
    Ghost Hunt
    Made By: WolfKnight
    init.lua
    
---------------------------------------------------------------------------*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include( "shared.lua" )
include( "sv_convars.lua" )
include( "sv_stamina.lua" )

--
-- Runs the first time a player spawns
--
function GM:PlayerInitialSpawn( ply )
    ply:SetTeam( 1 )
	ply:SetModel( table.Random( ghmodels ) )
end

--
-- Runs every time a player respawns 
--
function GM:PlayerSpawn( ply ) 
    if ply:Team() == 1 then
        local gh_flashlight = GetConVar( "gh_flashlight" )
		local walkspeed = GetConVar( "gh_walkspeed" )
		local runspeed  = GetConVar( "gh_runspeed" )

    -- Health and armour 
        ply:SetHealth( 200 )
        ply:SetArmor( 0 )

    -- Misc stuff
		ply:SetWalkSpeed( walkspeed:GetInt() ) 
		ply:SetRunSpeed( runspeed:GetInt() ) 
        ply:SetGravity( 1 )
        ply:AllowFlashlight( gh_flashlight:GetBool() )

    -- Give sweps/weapons
        ply:StripWeapons()
        ply:Give( "weapon_crowbar" )
        ply:Give( "weapon_physcannon" )
        ply:Give( "weapon_medkit" )
        ply:Give( "gmod_camera" )
    end

    ply:SetupHands()
end

--
-- Sets the player's hand model
--
function GM:PlayerSetHandsModel( ply, ent )
    local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
    local info = player_manager.TranslatePlayerHands( simplemodel )
    if ( info ) then
        ent:SetModel( info.model )
        ent:SetSkin( info.skin )
        ent:SetBodyGroups( info.body )
    end
end

--
-- Controls what can damage the player 
--
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

--
-- Noclip 
--
function GM:PlayerNoClip( ply )
	return ply:IsAdmin()
end 