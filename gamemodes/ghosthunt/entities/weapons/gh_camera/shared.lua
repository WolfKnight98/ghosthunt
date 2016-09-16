SWEP.Author			       = "Patrick Hunt & WolfKnight"
SWEP.Contact		       = "http://steamcommunity.com/id/HunteR4708"
SWEP.Purpose		       = "Record ghosties"
SWEP.Instructions	       = "Use secondary attack to zoom in and zoom out."

SWEP.HoldType		       = "rpg"

SWEP.ViewModel		       = ""
SWEP.WorldModel	    	   = "models/weapons/w_camera.mdl"

SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = false
SWEP.Primary.Ammo          = "none"

SWEP.Secondary.ClipSize	   = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo	       = "none"

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	ZoomLevel = 0
end

function SWEP:Precache()
	util.PrecacheModel( SWEP.WorldModel )
	util.PrecacheSound( "cc/zoom-in1.wav" )
	util.PrecacheSound( "cc/zoom-in2.wav" )
	util.PrecacheSound( "cc/zoom-out.wav" )
end

function SWEP:Reload()
	local defaultlens = 75
	self.Owner:SetFOV( defaultlens, 0.25 )
	ZoomLevel = 0
	return true
end

function SWEP:PrimaryAttack()
   return false
end

function SWEP:SecondaryAttack()
	local pitcher = math.random( 90, 105 )
	local defaultlens = 75
	local zoom1lens = 54.4
	local zoom2lens = 39.6
	local zoomspeed = 0.275
	
	if ( ZoomLevel == 0 ) then
 		if ( SERVER ) then
			self.Weapon:EmitSound( "cc/zoom-in1.wav", 35, pitcher, 1, CHAN_WEAPON )
			self.Owner:SetFOV( zoom1lens, zoomspeed )
		end
		ZoomLevel = 1
	elseif ( ZoomLevel == 1 ) then
 		if ( SERVER ) then
			self.Weapon:EmitSound( "cc/zoom-in2.wav", 35, pitcher, 1, CHAN_WEAPON )
			self.Owner:SetFOV( zoom2lens, zoomspeed )
		end
		ZoomLevel = 2
 	else
		if ( SERVER ) then
			self.Weapon:EmitSound( "cc/zoom-out.wav", 35, pitcher, 1, CHAN_WEAPON )
			self.Owner:SetFOV( defaultlens, zoomspeed )
		end
		ZoomLevel = 0
	end
end

function SWEP:Think()
	local amount = 2
	
	if self.Owner:IsBot() then 
		local amount = 1 
	else
		self.Owner:ViewPunch( Angle( math.Rand(-amount*0.02,amount*0.02), math.Rand(-amount*0.02,amount*0.02), math.Rand(-amount*0.02,amount*0.02)  ) )
	end
end

function SWEP:AdjustMouseSensitivity()
	return self.Owner:GetFOV() / 75
end

function SWEP:Holster()
	if self.Owner:IsPlayer() then
		self.Owner:SetFOV( 0, 0.15 )
		self.Owner:SetCanZoom( true )
		ZoomLevel = 0
	end
	return true
end

function SWEP:OnRemove()
	if self.Owner:IsPlayer() then
		self.Owner:SetFOV( 0, 0.15 )
		self.Owner:SetCanZoom( true )
		ZoomLevel = 0
	end
	return true
end