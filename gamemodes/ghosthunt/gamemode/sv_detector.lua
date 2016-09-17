/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    sv_detector.lua
    
---------------------------------------------------------------------------*/

-- So far there is only planned support for Breadman's gm_ghoshunt map series
-- More will be supported soon.

if ( MAP_SUPPORTED ) then 
	--
	-- This hook tries to find the ghost detector entity in the map 
	--
	hook.Add( "InitPostEntity", "DetectorFind", function()				
		local detectors = { "detector_physical", "ghost_detector" }
	
		for _, ent in ipairs( ents.GetAll() ) do		
			if ( table.HasValue( detectors, ent:GetName() ) ) then 
				print( "[GHOSTHUNT] Ghost detector entity found in map!\n" )
			end 
		end 
	end )
end 