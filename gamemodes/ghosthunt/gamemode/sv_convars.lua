/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    sv_convars.lua
    
---------------------------------------------------------------------------*/

-- ConVar Settings
CreateConVar( "gh_flashlight", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Toggles player's flashlight on or off.\n0 = off, 1 = on" )
CreateConVar( "gh_walkspeed", "120", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Set the player's walkspeed." )
CreateConVar( "gh_runspeed", "210", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Set the player's runspeed." )
CreateConVar( "gh_pvpdamage", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Allow player vs player damage.\n0 = no, 1 = yes" )
CreateConVar( "gh_stamina", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Toggles the stamina system.\n0 = off, 1 = on" )
CreateConVar( "gh_allowgravpunt", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Allow people to shoot props with the gravity gun.\n0 = no, 1 = yes" )
CreateConVar( "gh_infinite_glowstick", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Should glowsticks stay lit forever?" )
CreateConVar( "gh_glowstick_lifetime", "30", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Set the lifetime of glowsticks." )

cvars.AddChangeCallback( "gh_flashlight", function( convar_name, value_old, value_new ) 
	if ( tonumber(value_new, 10) > 1 ) then GetConVar( "gh_flashlight" ):SetBool( true ) end 
	if ( tonumber(value_new, 10) < 0 ) then GetConVar( "gh_flashlight" ):SetBool( false ) end 
	
	for k, v in pairs( player.GetAll() ) do 
		v:AllowFlashlight( value_new:GetBool() )
	end 
end )

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

cvars.AddChangeCallback( "gh_stamina", function( convar_name, value_old, value_new )
	if ( tonumber(value_new, 10) > 1 ) then GetConVar( "gh_stamina" ):SetBool( true ) end 
	if ( tonumber(value_new, 10) < 0 ) then GetConVar( "gh_stamina" ):SetBool( false ) end 
end )

cvars.AddChangeCallback( "gh_allowgravpunt", function( convar_name, value_old, value_new )
	if ( tonumber(value_new, 10) > 1 ) then GetConVar( "gh_allowgravpunt" ):SetBool( true ) end 
	if ( tonumber(value_new, 10) < 0 ) then GetConVar( "gh_allowgravpunt" ):SetBool( false ) end 
end )