/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    sv_detector.lua
    
---------------------------------------------------------------------------*/

-- Make a variable that will store the ghost detector entity 
GHOST_DETECTOR_ENT = nil 

-- Only runs if the map is supported 
if ( MAP_SUPPORTED ) then 
	--
	-- This hook tries to find the ghost detector entity in the map 
	--
	hook.Add( "InitPostEntity", "DetectorFind", function()					
		-- Checks every entity in the map on startup to try and find the ghost detector entity
		for _, ent in ipairs( ents.GetAll() ) do		
			if ( table.HasValue( GHOST_DETECTORS, ent:GetName() ) ) then 
				print( "[GHOSTHUNT] Ghost detector entity found in map!\n" )
				GHOST_DETECTOR_ENT = ent
			end 
		end 
	end )
end 