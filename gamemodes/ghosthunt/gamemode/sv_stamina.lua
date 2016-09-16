/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    sv_stamina.lua
    
---------------------------------------------------------------------------*/

-- STAMINA STUFF
local StaminaDisable          = 0       -- At what unit of stamina should jump & sprint be disabled? 
local StaminaRestoreAmount    = 1       -- How long it takes to restore 1 unit of stamina (in seconds)
local StaminaDecayAmount      = 0.25    -- ?
local StaminaReduceAmount     = 1       -- How many units of stamina to take away

if ( SERVER ) then 
	hook.Add( "PlayerSpawn", "StaminaStart", function( ply )
		ply:SetNWInt( "stamina", 100 )
	end	)
	
	hook.Add( "Think", "StaminaMain", function( ply )
		if ( GetConVar( "gh_stamina" ):GetInt() == 0 ) then return end 
	
		for k, ply in pairs( player.GetAll() ) do 
			if ( !ply or !ply:IsValid() ) then return end 
			
			local realspeed = ply:GetVelocity():Length()
			
			if ( (!ply:InVehicle() and ( ply:KeyDown( IN_SPEED ) and realspeed >= 40 and ply:OnGround() )) and ply:GetMoveType() != MOVETYPE_NOCLIP ) then 
				ply.StaminaLastTook = ply.StaminaLastTook or 0
				
				if ( ply.StaminaLastTook + StaminaDecayAmount <= CurTime() ) then
					ply:SetNWInt( "stamina", math.Clamp( ply:GetNWInt( "stamina" ) - 1, 0, 100 ) )
					
					ply.StaminaLastTook = CurTime()
					ply.StaminaLastAdded = CurTime()
				end 
			elseif ( ply:OnGround() or ply:InVehicle() or !ply:OnGround() ) then 
				ply.StaminaLastAdded = ply.StaminaLastAdded or 0
				
				if ( ply.StaminaLastAdded + StaminaRestoreAmount <= CurTime() ) then 
					ply:SetNWInt( "stamina", math.Clamp( ply:GetNWInt( "stamina" ) + 1, 0, 100 ) )
					
					ply.StaminaLastAdded = CurTime()
				end 
			end 
			
			local speedvar = { GetConVar("gh_walkspeed"):GetInt(), GetConVar("gh_runspeed"):GetInt() }
			
			if ( ply:GetNWInt( "stamina" ) > StaminaDisable ) then 
				GAMEMODE:SetPlayerSpeed( ply, speedvar[1], speedvar[2] )
			else
				GAMEMODE:SetPlayerSpeed( ply, speedvar[1], speedvar[1] )
			end
		end 
	end )
end 