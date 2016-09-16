/*---------------------------------------------------------------------------
    
    GhostHunt
    Made By: WolfKnight
    sv_convars.lua
    
---------------------------------------------------------------------------*/

-- ConVar Settings
CreateConVar( "gh_flashlight", "1", 256, "Toggles player's flashlight on or off.\n0 = off, 1 = on" )
CreateConVar( "gh_walkspeed", "120", 256, "Set the player's walkspeed." )
CreateConVar( "gh_runspeed", "210", 256, "Set the player's runspeed." )
CreateConVar( "gh_pvpdamage", "0", 256, "Allow player vs player damage.\n0 = no, 1 = yes" )
CreateConVar( "gh_stamina", "1", 256, "Toggles the stamina system.\n0 = off, 1 = on" )

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

cvars.AddChangeCallback( "gh_stamina", function( convar_name, value_old, value_new )
	if ( tonumber(value_new, 10) > 1 ) then GetConVar( "gh_stamina" ):SetBool( true ) end 
	if ( tonumber(value_new, 10) < 0 ) then GetConVar( "gh_stamina" ):SetBool( false ) end 
end )