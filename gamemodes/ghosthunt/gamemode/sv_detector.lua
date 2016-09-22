/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    sv_detector.lua
    
---------------------------------------------------------------------------*/

-- Only runs if the map is supported 
if ( MAP_SUPPORTED ) then 
	-- Make a variable that will store the ghost detector entity 
	GAMEMODE.GHOST_DETECTOR_ENT = nil 
	
	--
	-- This hook tries to find the ghost detector entity in the map 
	--
	hook.Add( "InitPostEntity", "DetectorFind", function()					
		-- Checks every entity in the map on startup to try and find the ghost detector entity
		for _, ent in ipairs( ents.GetAll() ) do		
			if ( ent:GetName() == self.GhostDetector ) then 
				print( "[GHOSTHUNT] Ghost detector entity found in map!\n" )
				GAMEMODE.GHOST_DETECTOR_ENT = ent
			end 
		end 
	end )
end 
