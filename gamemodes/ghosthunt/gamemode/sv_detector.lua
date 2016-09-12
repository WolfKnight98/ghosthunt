/*---------------------------------------------------------------------------
    
    Ghost Hunt
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
		DetectorTable = {}
		LookingFor = { "detector_sprite1", "detector_sprite2", "detector_sprite3", "detector_sprite4", "detector_sprite5", "detector_physical" }
		
		for _, ent in ipairs( ents.GetAll() ) do			
			if ( table.HasValue( LookingFor, ent:GetName() ) ) then 
				if ( ent:GetName() == "detector_physical" ) then Msg( "Ghost detector entity found in map!\n" ) end 
				table.insert( DetectorTable, ent )
			end 
		end 
	end )
end 