AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_NONE )
	self:DrawShadow(false)
end
function ENT:Think()
	if ( self.Owner:IsBot() ) then self:SetColor( Color( 0, 255, 0, 255 ) ) else self:SetColor( 0, 255, 0, 255 ) end
end