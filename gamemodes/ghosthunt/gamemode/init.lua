/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    init.lua
    
---------------------------------------------------------------------------*/

util.AddNetworkString( "sanity_effect" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include( "shared.lua" )
include( "sv_convars.lua" )
include( "sv_stamina.lua" )
include( "sv_detector.lua" ) 

--
-- Runs the first time a player spawns
--
function GM:PlayerInitialSpawn( ply )
	local randModel = math.random( 1, 10 )

	if ( (randModel >= 1) and (randModel <= 8) ) then 
		local r = math.random( 1, 9 )
		ply:SetModel( "models/player/Group01/male_0" .. r .. ".mdl" )
	else 
		local r = math.random( 1, 6 )
		ply:SetModel( "models/player/Group01/Female_0" .. r .. ".mdl" )
	end 
	
    ply:SetTeam( 1 )
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
		ply:Give( "gh_hands" )
		ply:Give( "gh_camera" )
        ply:Give( "weapon_crowbar" )
        ply:Give( "weapon_physcannon" )
        ply:Give( "weapon_medkit" )
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

--
-- Whether or not a player can pickup an object
--
function GM:AllowPlayerPickup( ply )
	local weapon = ply:GetActiveWeapon():GetClass()
	
	if ( weapon == "gh_camera" ) then 
		return false
	end 
	
	return true 
end 

--
-- Controls gravity punt (primary fire)
--
function GM:GravGunPunt( ply, ent )
	return GetConVar( "gh_allowgravpunt" ):GetBool()
end 

--
-- Controls the I/O of a map 
--
function GM:AcceptInput( ent, inp, act, cal, value )
	if ( MAP_SUPPORTED ) then 
		local entity
		
		if !ent:IsValid() then entity = "error" else entity = ent:GetName() end 

		if ( inp == "ShowSprite" ) then 
			if ( (entity == "detector_sprite5" ) or (entity == "detector_red_light") ) then				
				for _, enti in ipairs( ents.FindInSphere( ent:GetPos(), 96 ) ) do 
					if ( enti:IsPlayer() ) then 
						net.Start( "sanity_effect" ) 
						net.Send( enti )
					end 
				end 
			end 
		end 
	end
end 