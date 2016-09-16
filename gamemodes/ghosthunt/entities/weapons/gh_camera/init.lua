include('shared.lua')
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

SWEP.Weight			= 5
SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
	self.Owner:SetCanZoom( false )
end

function SWEP:DoRotateThink()
	return true
end

function SWEP:ShouldDropOnDie()
	return false
end