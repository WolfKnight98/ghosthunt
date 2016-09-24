/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    init.lua
    
---------------------------------------------------------------------------*/

util.AddNetworkString( "sanity_effect" )
util.AddNetworkString( "has_detector" )
util.AddNetworkString( "show_help" )
util.AddNetworkString( "spawn_wep" )

AddCSLuaFile( "cl_panels.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include( "shared.lua" )
include( "sv_convars.lua" )
include( "sv_stamina.lua" )
include( "sv_detector.lua" ) 


--
-- Loads the map config if we're on aa supported map 
--
hook.Add( "Initialize", "MapConfigLoad", function()
	local map = game.GetMap()
	local map_config = GAMEMODE.FolderName .. "/gamemode/maps/" .. map .. ".lua"
	
	if ( file.Exists( map_config, "LUA" ) ) then 
		include( map_config )
		MAP_SUPPORTED = true 
	else 
		MAP_SUPPORTED = false 
		
		timer.Create( "NotSupported", 10, 1, function()
			broadcast( "This map is not supported, contact the developer of this gamemode or the map creator.", 1 )
		end )
	end 
end )

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
		ply:Give( "gh_medkit" )
        ply:Give( "weapon_crowbar" )
        ply:Give( "weapon_physcannon" )
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
	local item = ply:GetEyeTrace().Entity
	
	-- We don't want the player to pickup items when they have the camera 
	-- out due to a bug where the weapons switch. 
	if ( weapon == "gh_camera" ) then 
		return false
	end 
	
	-- Attach the ghost detector to the player that has used it 
	-- if ( item:GetName() == self.GhostDetector ) then 
		-- if ( !item.IsAttached or item.IsAttached == false ) then 
			-- ply:ChatPrint( "You are looking at a ghost detector." )
			
			-- local pos = ply:GetPos()
			-- local ang = ply:GetAngles()
			
			-- item:SetPos( pos + Vector( 50, 0, 50 ) )
			-- item:SetAngles( ang )
			-- item:SetParent( ply )
			-- item:SetNoDraw( true )
			-- item.IsAttached = true
			-- item.AttachedTo = ply 
			
			-- net.Start( "has_detector" )
			-- net.Send( ply )
			
			-- return false 
		-- end 
	-- end 
	
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
		
		-- Make sure that the entity is valid so errors don't throw up 
		if !ent:IsValid() then entity = "error" else entity = ent:GetName() end 

		-- This will run when the ghost detector starts lighting up
		if ( inp == "ShowSprite" ) then 
		
			-- Only starts the sanity effect when you're about to get butt-fucked
			if ( entity == self.FinalSprite ) then	
			
				-- Checks a sphere of 96 units around the ghost detector and starts the sanity effect for players in the sphere 
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

--
--  These functions display the derma panels when F1, F2, F3 or F4 are pressed
--
function GM:ShowHelp( ply )
    net.Start( "show_help" )
	net.Send( ply )
end

function GM:ShowTeam( ply )
end

--
--
--
net.Receive( "spawn_wep", function()
	local ply = net.ReadEntity()
	local wep = net.ReadString()
	
	ply:Give( wep )
end )